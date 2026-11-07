# port_scan_plugin.py
"""
Plugin: Simple TCP port scan of a target host.

Uses the socket module like the networking lecture examples.
"""

import socket
from typing import Dict, Any, List


def scan_ports(target: str, ports: List[int], timeout: float = 0.5) -> Dict[int, bool]:
    results = {}
    for port in ports:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(timeout)
        try:
            s.connect((target, port))
            results[port] = True  # open
        except Exception:
            results[port] = False  # closed or filtered
        finally:
            s.close()
    return results


def run(config: Dict[str, Any]) -> Dict[str, Any]:
    target = config.get("scan_target", "127.0.0.1")
    ports = config.get("scan_ports", [22, 80, 443])

    results = scan_ports(target, ports)
    open_ports = [p for p, is_open in results.items() if is_open]

    details = f"target={target}, open_ports={open_ports}"

    return {
        "name": "port_scan_plugin",
        "status": "open ports found" if open_ports else "no open ports",
        "details": details
    }
