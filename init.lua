local term = require("term")
local event = require("event")

-- Load the boot animation
dofile("EFI/bootanim.lua")

-- Function to clear the screen and initialize the OS
local function initializeOS()
    term.clear()
    print("Welcome to Bloop OS!")

    -- Additional initialization code can go here

    -- Wait for a key press before continuing
    io.write("Press any key to continue...")
    event.pull("key")
end

-- Call the boot animation
initializeOS()
