# geo_ip_plugin.py
"""
Plugin: Geolocate remote IPs from host_info.json using ip-api.com.

Based on the geolocation examples from the lectures.
"""

import json
import os
from typing import Dict, Any, List

import requests


def extract_ips_from_hostinfo(hostinfo: Dict[str, Any]) -> List[str]:
    ips = set()
    for conn in hostinfo.get("NetConns", []):
        ip = conn.get("RemoteAddress")
        if not ip:
            continue
        # skip local/empty
        if ip.startswith("127.") or ip == "0.0.0.0" or ip == "::":
            continue
        ips.add(ip)
    return list(ips)


def run(config: Dict[str, Any]) -> Dict[str, Any]:
    base_dir = os.path.join(os.path.dirname(__file__), "..", "..")
    hostinfo_rel = config.get("host_info_json", "sample_output/host_info.json")
    hostinfo_path = os.path.join(base_dir, hostinfo_rel)

    if not os.path.isfile(hostinfo_path):
        return {
            "name": "geo_ip_plugin",
            "status": "no hostinfo",
            "details": f"{hostinfo_path} not found"
        }

    with open(hostinfo_path, "r", encoding="utf-8-sig") as f:
        hostinfo = json.load(f)

    ips = extract_ips_from_hostinfo(hostinfo)
    if not ips:
        return {
            "name": "geo_ip_plugin",
            "status": "no remote ips",
            "details": "no remote IPs found in NetConns"
        }

    max_ips = int(config.get("max_geo_ips", 10))
    to_lookup = ips[:max_ips]

    countries = {}
    looked_up = 0

    for ip in to_lookup:
        try:
            resp = requests.get(f"http://ip-api.com/json/{ip}", timeout=5)
            if resp.status_code == 200:
                data = resp.json()
                country = data.get("country", "Unknown")
                countries[country] = countries.get(country, 0) + 1
                looked_up += 1
        except requests.RequestException:
            continue

    details = f"looked_up={looked_up}, countries={countries}"

    return {
        "name": "geo_ip_plugin",
        "status": "ok" if looked_up > 0 else "no lookups",
        "details": details
    }
