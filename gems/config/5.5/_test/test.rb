require "config"

Config.load_and_set_settings(Config.setting_files("/path/to/config_root", "your_project_environment"))

Config.load_and_set_settings("/path/to/yaml1", "/path/to/yaml2")
