# plugin_manager.py
"""
Simple plugin loader.
It scans the 'plugins' folder and imports any .py file that has a run() function.
"""

import importlib
import os
from typing import List, Any

def load_plugins(plugin_package: str = "plugins") -> List[Any]:
    plugins = []
    package_path = os.path.join(os.path.dirname(__file__), plugin_package)

    for filename in os.listdir(package_path):
        if filename.endswith(".py") and not filename.startswith("_"):
            module_name = f"{plugin_package}.{filename[:-3]}"
            try:
                module = importlib.import_module(module_name)
                if hasattr(module, "run"):
                    plugins.append(module)
            except Exception as e:
                print(f"[!] Failed to load plugin {module_name}: {e}")

    return plugins
