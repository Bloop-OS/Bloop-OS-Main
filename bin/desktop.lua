-- Bloop OS (formerly CraftDE) by Carl

local term = require("term")
local event = require("event")
local gpu = require("component").gpu
local os = require("os")

gpu.setResolution(80, 25)

-- Window Manager
local windows = {}

local function openWindow(title, x, y, width, height, contentFn)
    local window = {
        title = title,
        x = x,
        y = y,
        width = width,
        height = height,
        contentFn = contentFn,
    }
    table.insert(windows, window)
end

local function closeWindow()
    table.remove(windows)
end

local function drawWindows()
    term.clear()
    for _, window in ipairs(windows) do
        term.setCursor(window.x, window.y)
        print("+" .. string.rep("-", window.width - 2) .. "+")
        for i = 1, window.height - 2 do
            term.setCursor(window.x, window.y + i)
            print("|" .. string.rep(" ", window.width - 2) .. "|")
        end
        term.setCursor(window.x, window.y + window.height - 1)
        print("+" .. string.rep("-", window.width - 2) .. "+")
        term.setCursor(window.x + 2, window.y)
        term.write(window.title)
        term.setCursorBlink(false)
        window.contentFn(window.x + 2, window.y + 1, window.width - 4, window.height - 3)
    end
end

-- Function to simulate a Blue Screen of Death (BSOD)
local function bsod(errorMessage)
    term.clear()
    gpu.setBackground(0x000000)  -- Black background
    gpu.setForeground(0xFF0000)  -- Red text

    print("A problem has been detected, and Bloop OS has been shut down to prevent damage to your computer.")
    print("Error Message: " .. errorMessage)
    print("If this is the first time you've seen this stop error screen, restart your computer. If this screen")
    print("appears again, contact your system administrator or technical support for further assistance.")
    print()
    print("Technical information:")
    print("*** STOP: 0x0000000A (0x00000000, 0x00000000, 0x00000000, 0x00000000)")

    os.sleep(5)  -- Pause for dramatic effect

    os.shutdown()
end

-- Function to display icons and initiate corresponding actions
local function displayIcons()
    drawWindows()

    -- Draw taskbar with black background and red text
    gpu.setBackground(0x000000)  -- Black background
    gpu.setForeground(0xFF0000)  -- Red text

    term.setCursor(1, 24)
    term.clearLine()
    term.write("  Bloop OS  ")

    -- Draw icons with red foreground and black background
    openWindow("File Explorer", 2, 2, 20, 10, function(x, y, width, height)
        -- Placeholder: Display files in the current directory
    end)

    openWindow("Text Editor", 24, 2, 20, 10, function(x, y, width, height)
        term.setCursor(x, y)
        term.write("Enter your text below (Ctrl + D to save and exit):")

        local input = ""
        local line = y + 2

        while true do
            term.setCursor(x, line)
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

        closeWindow()
        displayIcons()
    end)

    openWindow("Settings", 46, 2, 20, 10, function(x, y, width, height)
        term.setCursor(x, y + 2)
        term.write("1. Change Background Color")

        term.setCursor(x, y + 5)
        term.write("Select an option: ")
        local option = tonumber(term.read())

        if option == 1 then
            term.clear()
            term.setCursor(x, y)
            term.write("Choose a background color:")
            term.setCursor(x, y + 2)
            term.write("1. Black")
            term.setCursor(x, y + 4)
            term.write("2. Blue")
            term.setCursor(x, y + 6)
            term.write("3. Green")
            term.setCursor(x, y + 8)
            term.write("4. Red")
            term.setCursor(x, y + 10)
            term.write("5. White")

            term.setCursor(x, y + 13)
            term.write("Enter the corresponding number: ")
            local colorOption = tonumber(term.read())

            if colorOption == 1 then
                gpu.setBackground(0x000000)  -- Black background
            elseif colorOption == 2 then
                gpu.setBackground(0x0000FF)  -- Blue background
            elseif colorOption == 3 then
                gpu.setBackground(0x00FF00)  -- Green background
            elseif colorOption == 4 then
                gpu.setBackground(0xFF0000)  -- Red background
            elseif colorOption == 5 then
                gpu.setBackground(0xFFFFFF)  -- White background
            end

            term.clear()
            displayIcons()
        else
            term.clear()
            term.setCursor(x, y)
            term.write("Invalid option. Please select a valid option.")
            os.sleep(2)
            term.clear()
            displayIcons()
        end
    end)
end

-- Main function to handle user input and actions
local function main()
    while true do
        local _, _, x, y, _ = event.pull("touch")

        for _, window in ipairs(windows) do
            if x >= window.x and x < window.x + window.width and y >= window.y and y < window.y + window.height then
                -- Click inside a window
                term.setCursorBlink(true)
                window.contentFn(window.x + 2, window.y + 1, window.width - 4, window.height - 3)
                break
            end
        end
    end
end

-- Display the desktop icons
displayIcons()

-- Main function to handle user input and actions
main()
