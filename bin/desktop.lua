local term = require("term")
local event = require("event")
local gpu = require("component").gpu
local os = require("os")
local fs = require("filesystem")

gpu.setResolution(80, 25)

-- Function to draw an icon with the given colors and symbol
local function drawIcon(x, y, symbol, bgColor, textColor)
    gpu.setBackground(bgColor)
    gpu.setForeground(textColor)
    term.setCursor(x, y)
    term.write(" " .. symbol .. " ")
end

-- Function to draw the taskbar
local function drawTaskbar()
    gpu.setBackground(0x0000FF)  -- Blue background
    gpu.setForeground(0xFFFFFF)  -- White text

    term.setCursor(1, 24)
    term.clearLine()
    term.write("  Bloop OS  ")

    -- Display current time
    term.setCursor(70, 24)
    term.write(os.date("%H:%M:%S"))
end

-- Function to draw the taskbar menu
local function drawTaskbarMenu()
    term.setCursor(72, 24)
    term.write("Menu")
end

-- Function to display icons and initiate corresponding actions
local function displayIcons()
    term.clear()

    -- Draw icons with blue background and white text
    drawIcon(2, 2, "F", 0x0000FF, 0xFFFFFF)  -- File Explorer icon
    drawIcon(12, 2, "E", 0x0000FF, 0xFFFFFF)  -- Text Editor icon
    drawIcon(22, 2, "P", 0x00FF00, 0x000000)  -- Paint icon
    drawIcon(32, 2, "M", 0xFFFF00, 0x000000)  -- Music icon
    drawIcon(42, 2, "B", 0xFF0000, 0xFFFFFF)  -- BSOD icon

    -- Draw the taskbar
    drawTaskbar()

    -- Draw the taskbar menu
    drawTaskbarMenu()
end

-- Function to simulate a file explorer
local function fileExplorer()
    term.clear()
    displayIcons()

    -- Get the list of files in the current directory
    local files = fs.list(fs.get("/"))

    -- Display files
    for i, file in ipairs(files) do
        term.setCursor(2, i + 4)
        term.write(file)
    end

    -- Wait for touch to return to desktop
    event.pull("touch")
    displayIcons()
end

-- Function to simulate a simple text editor
local function textEditor()
    term.clear()
    displayIcons()

    term.setCursor(2, 4)
    term.write("Enter your text below (Ctrl + D to save and exit):")

    local input = ""
    local line = 6

    while true do
        term.setCursor(2, line)
        local char = term.read()
        if char == string.char(4) then  -- Ctrl + D to save and exit
            break
        else
            input = input .. char
            line = line + 1
        end
    end

    -- Save the input to a file (you can customize the filename)
    local file = io.open("/home/user/textfile.txt", "w")
    file:write(input)
    file:close()

    displayIcons()
end

-- Function to simulate a Paint app
local function paintApp()
    term.clear()
    displayIcons()

    term.setCursor(2, 4)
    term.write("Welcome to the Paint App!")
    term.setCursor(2, 6)
    term.write("Draw something below (Ctrl + D to exit):")

    local canvas = {}
    for i = 8, 23 do
        canvas[i] = {}
        for j = 2, 79 do
            canvas[i][j] = " "
        end
    end

    local x, y = 2, 8
    while true do
        term.setCursor(x, y)
        local char = term.read()
        if char == string.char(4) then  -- Ctrl + D to exit
            break
        else
            canvas[y][x] = char
            x = x + 1
            if x > 78 then
                x = 2
                y = y + 1
            end
            if y > 23 then
                y = 8
            end
            term.clearLine()
            for i = 8, 23 do
                term.setCursor(2, i)
                term.write(table.concat(canvas[i]))
            end
        end
    end

    displayIcons()
end

-- Function to simulate a Music app
local function musicApp()
    term.clear()
    displayIcons()

    term.setCursor(2, 4)
    term.write("Welcome to the Music App!")
    term.setCursor(2, 6)
    term.write("Now playing: Bloop Symphony No. 1")

    os.sleep(5)  -- Simulate playing music

    displayIcons()
end

-- Function to simulate a Blue Screen of Death (BSOD)
local function bsod(errorMessage)
    term.clear()
    gpu.setBackground(0x0000FF)
    gpu.setForeground(0xFFFFFF)

    print("A problem has been detected and Bloop OS has been shut down to prevent damage to your computer.")
    print("Error Message: " .. errorMessage)
    print("If this is the first time you've seen this stop error screen, restart your computer. If this screen")
    print("appears again, contact your system administrator or technical support for further assistance.")
    print()
    print("Technical information:")
    print("*** STOP: 0x0000000A (0x00000000, 0x00000000, 0x00000000, 0x00000000)")
    print()
end

-- Function to display the taskbar menu options
local function displayTaskbarMenu()
    term.clear()
    drawTaskbarMenu()

    term.setCursor(2, 4)
    term.write("1. Reboot")
    term.setCursor(2, 6)
    term.write("2. Shutdown")

    local option = tonumber(term.read())

    if option == 1 then
        os.reboot()
    elseif option == 2 then
        os.shutdown()
    else
        displayTaskbarMenu()
    end
end

-- Function to handle user input and actions
local function handleInput(x, y)
    if x >= 2 and x <= 5 and y >= 2 and y <= 4 then
        fileExplorer()
    elseif x >= 12 and x <= 15 and y >= 2 and y <= 4 then
        textEditor()
    elseif x >= 22 and x <= 25 and y >= 2 and y <= 4 then
        paintApp()
    elseif x >= 32 and x <= 35 and y >= 2 and y <= 4 then
        musicApp()
    elseif x >= 42 and x <= 45 and y >= 2 and y <= 4 then
        bsod("Advanced BSOD triggered")
    elseif x >= 72 and x <= 75 and y == 24 then
        displayTaskbarMenu()
    end
end

-- Main function to handle user input and actions
local function main()
    while true do
        local _, _, x, y, _ = event.pull("touch")
        handleInput(x, y)
    end
end

-- Display the desktop icons
displayIcons()

-- Main function to handle user input and actions
main()
