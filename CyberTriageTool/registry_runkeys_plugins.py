# registry_runkeys_plugin.py
"""
Plugin: List programs configured to start at logon from the Windows 'Run' key.

Based on the Windows registry example from the lecture.
"""

from typing import Dict, Any, List

try:
    import winreg  # only available on Windows
except ImportError:
    winreg = None


def read_run_key() -> List[str]:
    entries = []
    if winreg is None:
        return entries

    try:
        key = winreg.OpenKey(
            winreg.HKEY_CURRENT_USER,
            r"Software\Microsoft\Windows\CurrentVersion\Run"
        )
    except OSError:
        return entries

    i = 0
    while True:
        try:
            name, value, _ = winreg.EnumValue(key, i)
            entries.append(f"{name} = {value}")
            i += 1
        except OSError:
            break

    winreg.CloseKey(key)
    return entries


def run(config: Dict[str, Any]) -> Dict[str, Any]:
    if winreg is None:
        return {
            "name": "registry_runkeys_plugin",
            "status": "not supported",
            "details": "winreg module not available (non-Windows?)"
        }

    entries = read_run_key()
    count = len(entries)

    if count == 0:
        return {
            "name": "registry_runkeys_plugin",
            "status": "empty",
            "details": "no Run key entries found"
        }

    # Show just the first few entries in the short summary
    preview = "; ".join(entries[:3])
    if count > 3:
        preview += f" ... (+{count - 3} more)"

    return {
        "name": "registry_runkeys_plugin",
        "status": f"{count} entries",
        "details": preview
    }
