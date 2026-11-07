# plugins/hash_vt_plugin.py
"""
Plugin: Hash a suspicious file and query VirusTotal.
"""

import hashlib
import os
from typing import Dict, Any

import requests  # make sure to pip install requests


def sha256_file(filepath: str) -> str:
    """Compute SHA-256 hash of a file."""
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


def vt_lookup(api_key: str, file_hash: str) -> Dict[str, Any]:
    """Query VirusTotal for a file hash (v3 API)."""
    url = f"https://www.virustotal.com/api/v3/files/{file_hash}"
    headers = {"x-apikey": api_key}

    try:
        response = requests.get(url, headers=headers, timeout=15)
    except requests.exceptions.RequestException as e:
        return {"error": f"Network/API error: {e}"}

    if response.status_code != 200:
        return {"error": f"VT returned status {response.status_code}"}

    data = response.json()
    stats = data.get("data", {}).get("attributes", {}).get("last_analysis_stats", {})
    malicious = stats.get("malicious", 0)
    suspicious = stats.get("suspicious", 0)
    undetected = stats.get("undetected", 0)
    harmless = stats.get("harmless", 0)

    if malicious > 0:
        label = "MALICIOUS"
    elif suspicious > 0:
        label = "SUSPICIOUS"
    elif harmless > 0 and malicious == 0 and suspicious == 0:
        label = "CLEAN / NO DETECTIONS"
    else:
        label = "UNKNOWN"

    return {
        "label": label,
        "malicious": malicious,
        "suspicious": suspicious,
        "undetected": undetected,
        "harmless": harmless,
    }


def run(config: Dict[str, Any]) -> Dict[str, Any]:
    """Entry point called by main.py via the plugin manager."""
    suspicious_file = os.path.join(
        os.path.dirname(__file__),
        "..",
        "..",
        config["suspicious_file"]
    )

    api_env_var = config.get("vt_api_key_env", "VT_API_KEY")
    api_key = os.environ.get(api_env_var)

    if not os.path.isfile(suspicious_file):
        return {
            "name": "hash_vt_plugin",
            "status": "no file",
            "details": f"Suspicious file not found: {suspicious_file}"
        }

    if not api_key:
        return {
            "name": "hash_vt_plugin",
            "status": "no api key",
            "details": f"Environment variable {api_env_var} is not set."
        }

    try:
        file_hash = sha256_file(suspicious_file)
    except Exception as e:
        return {
            "name": "hash_vt_plugin",
            "status": "hash error",
            "details": str(e)
        }

    vt_result = vt_lookup(api_key, file_hash)

    if "error" in vt_result:
        status = "vt error"
        details = vt_result["error"]
    else:
        status = vt_result["label"]
        details = f"malicious={vt_result['malicious']}, suspicious={vt_result['suspicious']}, harmless={vt_result['harmless']}"

    return {
        "name": "hash_vt_plugin",
        "status": status,
        "details": f"hash={file_hash}; {details}"
    }
