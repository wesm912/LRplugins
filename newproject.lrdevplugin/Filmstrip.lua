--[[
    Filmstrip.lua
    Creates a filmstrip object for use in dialogs
--]]
require 'PluginInit'

local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrBinding = import "LrBinding"
local LrDialogs = import "LrDialogs"
local LrFunctionContext = import "LrFunctionContext"
local LrView = import "LrView"
local LrColor = import "LrColor"
--import "math"
local catalog = LrApplication.activeCatalog()

Filmstrip =  {}

--[[
    makeFilmStrip (args)
    args:
        photos: list of photos, default {}
        length: number of photos to show at once, default 4
        width: width of the filmstrip
        height: height of each photo
        onClick: function to run when a photo is clicked
--]]

function print_r (t, indent, done)
  done = done or {}
  indent = indent or ''
  local result = ''
  local nextIndent -- Storage for next indentation value
  for key, value in pairs (t) do
    if type (value) == "table" and not done [value] then
      nextIndent = nextIndent or
          (indent .. string.rep(' ',string.len(tostring (key))+2))
          -- Shortcut conditional allocation
      done [value] = true
      result = result .. indent .. "[" .. tostring (key) .. "] => Table {"
      result = result .. nextIndent .. "{"
      result = result .. print_r (value, nextIndent .. string.rep(' ',2), done)
      result = result .. nextIndent .. "}"
    else
      result = result .. indent .. "[" .. tostring (key) .. "] => " .. tostring (value)..""
    end
  end
  return result
end


function Filmstrip.makeFilmStrip( args )
    PluginInit.outputToLog("Start makeFilmStrip")
    if not args or not args.photos then return nil end
    local length = args.length or #args.photos
    local height = args.height or 200
    local width = args.width or 800
    local pwidth = math.max(width / length, 120)
    local pheight = pwidth
    local plength = math.max(width/pwidth, 1)
    local content = {}

    PluginInit.outputToLog("Got " .. #args.photos .. " photos")
    content = LrFunctionContext.callWithContext( 'makeFilmStrip', function( context )
        local f = LrView.osFactory()
        local properties = LrBinding.makePropertyTable( context )
        properties.photos = args.photos
        local photos = args.photos
        properties.firstIndex = 1
        properties.length = length
        local cat_photos = {}
        for i, photo in ipairs(args.photos) do
            local pargs = {
                height = pheight,
                width = pheight,
                frame_width = 1,
                background_color = LrColor(128,128,128),
                mouse_down = args.callback,
                photo = photo,
                visible = true,
            }
            table.insert(cat_photos, f:catalog_photo(pargs))
        end
        properties.selectedPhoto = photos[properties.firstIndex]
        properties:addObserver("firstIndex", function(props, key, newValue)
                PluginInit.outputToLog("Observer called with key " .. key ..
                    " and newValue  " .. tostring(newValue))
                if key == "firstIndex" then
                    if newValue >= 1 and newValue <= length then
                        properties.selectedPhoto = properties.photos[newValue]
                        PluginInit.outputToLog("Observer: newValue is " .. tostring(newValue))
                    end
                end
            end)

        content = f:column {
            bind_to_object = properties,
            f:row {
                f:catalog_photo({
                    photo = LrView.bind('selectedPhoto')
                    })
            },
            f:row {
                f:push_button {
                    title = "<",
                    action = function (button)
                        properties.firstIndex = math.max(properties.firstIndex - 1, 1)
                        properties.selectedPhoto = properties.photos[properties.firstIndex]
                    end,
                    enabled = LrView.bind {
                        key = "firstIndex",
                        transform = function(value, tbl)
                            return value > 1
                        end
                    }
                },
                f:push_button {
                    title = ">",
                    action = function (button)
                        local old = properties.firstIndex
                        PluginInit.outputToLog("Next: old firstIndex is " .. old)
                        properties.firstIndex = math.min(properties.firstIndex + 1, length)
                        PluginInit.outputToLog("Next: new firstIndex is " .. properties.firstIndex)
                        properties.selectedPhoto = properties.photos[properties.firstIndex]
                    end,
                    enabled = LrView.bind {
                        key = "firstIndex",
                        transform = function(value, tbl)
                            return value < length
                        end
                    }
                },
            },
        }
        return content
    end)
    return content
end

-- Test
function showFilmStripTest()
--    LrFunctionContext.callWithContext( "TestFilmStripDialog", function( context )
        local photos = catalog:getTargetPhotos()
        local f = LrView.osFactory()
        local content = Filmstrip.makeFilmStrip({photos = photos})
        PluginInit.outputToLog("makeFilmStrip returned " .. tostring(content))
        local result = LrDialogs.presentModalDialog {
            title = "Filmstrip Test",
            contents = content,
        }
--    end)
end

showFilmStripTest()

