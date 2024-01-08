local term = require("term")
local event = require("event")

local GUI = {}

function GUI.newButton(x, y, width, height, label, onClick)
    local button = {
        x = x,
        y = y,
        width = width,
        height = height,
        label = label,
        onClick = onClick
    }
    setmetatable(button, { __index = GUI.Button })
    return button
end

function GUI.newTextInput(x, y, width, onEnter)
    local input = {
        x = x,
        y = y,
        width = width,
        value = "",
        onEnter = onEnter
    }
    setmetatable(input, { __index = GUI.TextInput })
    return input
end

function GUI.newListView(x, y, width, height, items, onSelect)
    local listView = {
        x = x,
        y = y,
        width = width,
        height = height,
        items = items,
        selectedIndex = 1,
        onSelect = onSelect
    }
    setmetatable(listView, { __index = GUI.ListView })
    return listView
end

function GUI.newCheckbox(x, y, label, onToggle)
    local checkbox = {
        x = x,
        y = y,
        label = label,
        checked = false,
        onToggle = onToggle
    }
    setmetatable(checkbox, { __index = GUI.Checkbox })
    return checkbox
end

function GUI.newProgressBar(x, y, width, progress)
    local progressBar = {
        x = x,
        y = y,
        width = width,
        progress = progress or 0
    }
    setmetatable(progressBar, { __index = GUI.ProgressBar })
    return progressBar
end

function GUI.Button:draw()
    term.setBackgroundColor(0xCCCCCC)
    term.clear()
    term.setCursor(self.x, self.y)
    term.write(string.rep(" ", self.width))
    term.setCursor(self.x, self.y + self.height - 1)
    term.write(string.rep(" ", self.width))
    for i = self.y + 1, self.y + self.height - 2 do
        term.setCursor(self.x, i)
        term.write(" ")
        term.setCursor(self.x + self.width - 1, i)
        term.write(" ")
    end

    local labelX = self.x + math.floor((self.width - #self.label) / 2)
    local labelY = self.y + math.floor(self.height / 2)
    term.setCursor(labelX, labelY)
    term.write(self.label)
end

function GUI.Button:handleClick(x, y)
    if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
        if self.onClick then
            self.onClick()
        end
    end
end

function GUI.TextInput:draw()
    term.setBackgroundColor(0xFFFFFF)
    term.clear()
    term.setCursor(self.x, self.y)
    term.write(string.rep(" ", self.width))
    term.setCursor(self.x, self.y + 2)
    term.write(string.rep(" ", self.width))
    for i = self.y + 1, self.y + 2 do
        term.setCursor(self.x, i)
        term.write(" ")
        term.setCursor(self.x + self.width - 1, i)
        term.write(" ")
    end

    term.setCursor(self.x + 1, self.y + 1)
    term.write(self.value)
end

function GUI.TextInput:handleKeyPress(char)
    if char >= 32 and char <= 126 then
        self.value = self.value .. string.char(char)
    elseif char == 8 then  -- Backspace
        self.value = string.sub(self.value, 1, -2)
    elseif char == 13 then  -- Enter
        if self.onEnter then
            self.onEnter(self.value)
        end
    end
end

function GUI.ListView:draw()
    term.setBackgroundColor(0xFFFFFF)
    term.clear()
    term.setCursor(self.x, self.y)
    term.write(string.rep(" ", self.width))
    term.setCursor(self.x, self.y + self.height - 1)
    term.write(string.rep(" ", self.width))
    for i = self.y + 1, self.y + self.height - 2 do
        term.setCursor(self.x, i)
        term.write(" ")
        term.setCursor(self.x + self.width - 1, i)
        term.write(" ")
    end

    for i, item in ipairs(self.items) do
        local itemX = self.x + 1
        local itemY = self.y + i
        term.setCursor(itemX, itemY)
        term.write(item)
    end

    local selectedX = self.x + 1
    local selectedY = self.y + self.selectedIndex
    term.setCursor(selectedX, selectedY)
    term.write(">")
end

function GUI.ListView:handleClick(x, y)
    if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
        local clickedIndex = y - self.y
        if clickedIndex >= 1 and clickedIndex <= #self.items then
            self.selectedIndex = clickedIndex
            if self.onSelect then
                self.onSelect(self.items[self.selectedIndex])
            end
        end
    end
end

function GUI.Checkbox:draw()
    term.setBackgroundColor(0xFFFFFF)
    term.clear()
    term.setCursor(self.x, self.y)
    term.write("[ ] " .. self.label)
    if self.checked then
        term.setCursor(self.x + 1, self.y)
        term.write("X")
    end
end

function GUI.Checkbox:handleClick(x, y)
    if x >= self.x and x < self.x + 3 and y == self.y then
        self.checked = not self.checked
        if self.onToggle then
            self.onToggle(self.checked)
        end
    end
end

function GUI.ProgressBar:draw()
    term.setBackgroundColor(0xFFFFFF)
    term.clear()
    term.setCursor(self.x, self.y)
    term.write(string.rep(" ", self.width))

    local filledWidth = math.floor(self.width * self.progress)
    term.setBackgroundColor(0x00FF00)
    term.setCursor(self.x, self.y)
    term.write(string.rep(" ", filledWidth))

    term.setCursor(self.x + filledWidth, self.y)
    term.setBackgroundColor(0xFFFFFF)
    term.write(string.rep(" ", self.width - filledWidth))
end

function GUI.ProgressBar:setProgress(progress)
    self.progress = math.max(0, math.min(1, progress))
end

function GUI.handleEvents(elements)
    while true do
        local eventType, _, x, y, _, _ = event.pullMultiple("touch", "key_down")
        
        if eventType == "touch" then
            for _, elem in ipairs(elements) do
                if elem.handleTouch then
                    elem:handleTouch(x, y)
                end
            end
        elseif eventType == "key_down" then
            for _, elem in ipairs(elements) do
                if elem.handleKeyPress then
                    elem:handleKeyPress(y)
                end
            end
        end
    end
end

return GUI
