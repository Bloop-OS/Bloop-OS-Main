local term = require("term")
local event = require("event")
-- Function to load all files in a directory
function loadFiles(directory)
    local files = require("filesystem").list(directory)

    for file in files do
        local filePath = directory .. "/" .. file

        -- Load only Lua files
        if file:sub(-4) == ".lua" then
            local chunk, err = loadfile(filePath)

            if chunk then
                chunk()  -- Execute the loaded file
            else
                print("Error loading file:", filePath)
                print("Error details:", err)
            end
        end
    end
end

-- Load files in lib/core directory
loadFiles("/lib/core")

-- Load the boot animation script
local bootAnimPath = "/EFI/bootanim.lua"
local bootAnimChunk, bootAnimErr = loadfile(bootAnimPath)

if bootAnimChunk then
    bootAnimChunk()  -- Execute the boot animation script
else
    print("Error loading boot animation script:", bootAnimPath)
    print("Error details:", bootAnimErr)
end
