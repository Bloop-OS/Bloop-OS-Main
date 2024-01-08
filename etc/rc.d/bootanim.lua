local os = require("os")
local component = require("component")
local term = require("term")
local gpu = component.gpu

-- Set background color to black
gpu.setBackground(0x000000)
term.clear()

-- Set text color to white
gpu.setForeground(0xFFFFFF)

-- Print "Bloop OS" at the center of the screen
local screenWidth, screenHeight = gpu.getResolution()
local text = "Bloop OS"
local textX = math.floor((screenWidth - #text) / 2)
local textY = math.floor(screenHeight / 2)
gpu.set(textX, textY, text)

-- Draw the loading bar
local loadingBarWidth = 20
local loadingBarX = math.floor((screenWidth - loadingBarWidth) / 2)
local loadingBarY = textY + 1

-- You can customize the loading animation here
for i = 1, loadingBarWidth do
    gpu.set(loadingBarX + i - 1, loadingBarY, "█")
    os.sleep(0.1)  -- Adjust the sleep duration for desired speed
end

-- Reset colors after the animation
gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
term.clear()
dofile("/lib/desktop.lua")
print("Starting BODE (Bloop OS Desktop Enviroment)")
dofile("/bin/desktop.lua")
