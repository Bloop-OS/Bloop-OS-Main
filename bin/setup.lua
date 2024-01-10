-- Bloop OS Setup by Carl

local term = require("term")
local gpu = require("component").gpu
local fs = require("filesystem")

local function saveConfig(backgroundColor)
    local config = io.open("/home/user/setup.cfg", "w")
    config:write("backgroundColor=" .. backgroundColor)
    config:close()
end

local function loadConfig()
    local configPath = "/home/user/setup.cfg"

    if fs.exists(configPath) then
        local config = io.open(configPath, "r")
        local backgroundColor = config:read("*a"):match("backgroundColor=(%x+)")
        config:close()
        return backgroundColor
    else
        return nil
    end
end

local function setupGUI()
    term.clear()

    gpu.setBackground(0x000000)  -- Black background
    gpu.setForeground(0xFFFFFF)  -- White text

    print("╔══════════════════════════╗")
    print("║  Welcome to Bloop OS Setup ║")
    print("╠══════════════════════════╣")
    print("║ Please choose a background color:   ║")
    print("║ 1. Black                         ║")
    print("║ 2. Light Blue                    ║")
    print("║ 3. Green                         ║")
    print("║ 4. Light Red                     ║")
    print("║ 5. White                         ║")
    print("╚══════════════════════════╝")

    local choice = tonumber(io.read())

    local backgroundColor
    if choice == 1 then
        backgroundColor = 0x000000
    elseif choice == 2 then
        backgroundColor = 0x0088FF
    elseif choice == 3 then
        backgroundColor = 0x00CC00
    elseif choice == 4 then
        backgroundColor = 0xFF4444
    elseif choice == 5 then
        backgroundColor = 0xFFFFFF
    else
        print("Invalid choice. Exiting setup.")
        return
    end

    saveConfig(backgroundColor)

    print("\nSetup complete! Bloop OS will now launch.")
end

-- Check if setup.cfg exists
local configFile = "/home/user/setup.cfg"

if fs.exists(configFile) then
    print("Bloop OS is already set up. Launching...")
else
    setupGUI()
end

-- Execute Bloop OS
os.execute("/bin/desktop.lua")
