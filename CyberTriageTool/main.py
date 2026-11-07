# main.py
"""
Main entry point for the Cyber Triage Tool.

Steps:
1. Read config.
2. Run the PowerShell triage script via subprocess (collects host info).
3. Load all Python plugins.
4. Run each plugin and collect their results.
5. Print a simple summary.
"""

import json
import os
import subprocess
from typing import Dict, Any, List

from plugin_manager import load_plugins


def load_config(config_path: str = "../config.json") -> Dict[str, Any]:
    config_full = os.path.join(os.path.dirname(__file__), config_path)
    with open(config_full, "r", encoding="utf-8") as f:
        return json.load(f)


def run_powershell_triage(config: Dict[str, Any]) -> None:
    """Call the PowerShell script to collect host data."""
    script_rel = config["powershell_script"]
    output_dir = config["triage_output_dir"]
    timeout_seconds = config.get("timeout_seconds", 30)

    script_path = os.path.join(os.path.dirname(__file__), "..", script_rel)
    output_path = os.path.join(os.path.dirname(__file__), "..", output_dir)

    os.makedirs(output_path, exist_ok=True)

    command = [
        "powershell",
        "-ExecutionPolicy", "Bypass",
        "-File", script_path,
        "-OutputPath", output_path
    ]

    print(f"[+] Running PowerShell triage script: {script_path}")
    try:
        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            timeout=timeout_seconds
        )
        if result.returncode != 0:
            print("[!] PowerShell script failed:")
            print(result.stderr)
        else:
            print("[+] PowerShell triage completed.")
    except subprocess.TimeoutExpired:
        print(f"[!] PowerShell script timed out after {timeout_seconds} seconds.")
    except FileNotFoundError:
        print("[!] PowerShell not found. Are you on Windows and is PowerShell in PATH?")


def run_plugins(config: Dict[str, Any]) -> List[Dict[str, Any]]:
    """Discover and execute all plugins. Each plugin returns a dict summary."""
    print("[+] Loading plugins...")
    plugins = load_plugins()
    results = []

    if not plugins:
        print("[!] No plugins found.")
        return results

    for plugin in plugins:
        name = getattr(plugin, "__name__", "unknown_plugin")
        print(f"[+] Running plugin: {name}")
        try:
            summary = plugin.run(config)
            if isinstance(summary, dict):
                results.append(summary)
        except Exception as e:
            print(f"[!] Plugin {name} failed: {e}")

    return results


def main() -> None:
    config = load_config()
    print("[+] Config loaded.")

    run_powershell_triage(config)
    plugin_summaries = run_plugins(config)

    print("\n=== Triage Summary ===")
    for summary in plugin_summaries:
        print(f"- {summary.get('name', 'plugin')}: {summary.get('status', 'no status')}")
        extra = summary.get("details")
        if extra:
            print(f"  details: {extra}")


if __name__ == "__main__":
    main()
