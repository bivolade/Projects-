# logs_bruteforce_plugin.py
"""
Plugin: simple brute-force detector using regex on an auth log.

Looks for lines containing 'Failed password' and extracts IPs and usernames,
similar to the examples in the log processing lecture.
"""

import os
import re
from collections import Counter
from typing import Dict, Any


def run(config: Dict[str, Any]) -> Dict[str, Any]:
    log_rel_path = config.get("log_file", "sample_output/auth.log")
    base_dir = os.path.join(os.path.dirname(__file__), "..", "..")
    log_path = os.path.join(base_dir, log_rel_path)

    if not os.path.isfile(log_path):
        return {
            "name": "logs_bruteforce_plugin",
            "status": "no log file",
            "details": f"log file not found: {log_path}"
        }

    # Very similar regex to the lecture: extract IP and username
    ip_pattern = re.compile(r"(\d{1,3}\.){3}\d{1,3}")
    user_pattern = re.compile(r"Failed password for (\w+)")

    ip_counter = Counter()
    user_counter = Counter()
    total_failed = 0

    with open(log_path, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            if "Failed password" in line:
                total_failed += 1

                ip_match = ip_pattern.search(line)
                if ip_match:
                    ip_counter[ip_match.group()] += 1

                user_match = user_pattern.search(line)
                if user_match:
                    user_counter[user_match.group(1)] += 1

    top_ip = ip_counter.most_common(1)[0] if ip_counter else None
    top_user = user_counter.most_common(1)[0] if user_counter else None

    details = f"failed={total_failed}"
    if top_ip:
        details += f", top_ip={top_ip[0]} ({top_ip[1]} attempts)"
    if top_user:
        details += f", top_user={top_user[0]} ({top_user[1]} attempts)"

    return {
        "name": "logs_bruteforce_plugin",
        "status": "ok" if total_failed > 0 else "no failures",
        "details": details
    }
