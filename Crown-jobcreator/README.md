# Crown Job Creator

**Job and grade management for FiveM ESX servers**

[![ESX](https://img.shields.io/badge/ESX-1.2+-blue)](https://github.com/esx-framework/esx-legacy)
[![ox_lib](https://img.shields.io/badge/ox__lib-3.0+-green)](https://github.com/overextended/ox_lib)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange)](https://github.com/crown-development)

Create, edit, and manage jobs through a modern React interface with Discord logging.

---

## Dependencies

**Required:**
- `es_extended` (ESX Framework)
- `ox_lib` (UI & Notifications)
- `oxmysql` (Database)

---

## Installation

1. Place in resources folder
2. Run `install.sql` 
3. Add `ensure Crown-jobcreator` to server.cfg
4. Restart server

---

## Usage

**Open:** Press `F5` or `/jobcreator`  
**Access:** Admin only (configurable in config.lua)

---

## Configuration

Edit `config.lua`:

```lua
Config.Locale = 'en'           -- Language
Config.AdminGroups = {'admin'} -- Who can access
Config.SalaryLimits = {min = 0, max = 20000}
```

**Discord:** Replace webhook URLs in config.lua

---

**Support:** Crown Development | **Version:** 1.0.0