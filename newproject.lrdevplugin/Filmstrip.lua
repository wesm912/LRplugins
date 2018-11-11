--[[
    Filmstrip.lua
    Creates a filmstrip object for use in dialogs
--]]
require 'PluginInit'

local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'local LrBinding = import "LrBinding"
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
    if not args or not args.photos then return content end
    local length = args.length or 4
    local height = args.height or 200
    local width = args.width or 800
    local pwidth = math.max(width / length, 120)
    local pheight = pwidth
    local plength = math.max(width/pwidth, 1)
    local content = {}

    PluginInit.outputToLog("Got " .. #args.photos .. " photos")
    LrFunctionContext.callWithContext( 'makeFilmStrip', function( context )
        local f = LrView.osFactory()
        local properties = LrBinding.makePropertyTable( context )
        properties.photos = photos
        properties.firstIndex = 1
        local row_args = {bind_to_object = properties}
        properties.row_args = row_args
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
        PluginInit.outputToLog("Before definition of update_row_args")

        local function update_row_args(props, t, firstIndex)
            PluginInit.outputToLog("Entering update_row_args")
            t.bind_to_object = props
            table.insert(t, f:push_button {
                title = "<",
                action = function (button)
                    props.firstIndex = math.max(props.firstIndex - 1, 1)
                end,
                enabled = LrView.bind {
                    key = "firstIndex",
                    transform = function(value, tbl)
                        return value > 1
                    end
                }
            })
            PluginInit.outputToLog("After adding first button")
            for i = 0, length, 1 do
                table.insert(t, cat_photos[i + firstIndex])
                PluginInit.outputToLog("Added catalog photo at index " .. i + firstIndex
                    .. " " .. tostring(cat_photos[i+firstIndex]) )
            end
            PluginInit.outputToLog("After adding photos")
            table.insert(t,
                f:push_button {
                    title = ">",
                    action = function (button)
                        props.firstIndex = math.min(props.firstIndex + 1, length)
                    end,
                    enabled = LrView.bind {
                        key = "firstIndex",
                        transform = function(value, tbl)
                            return value < length
                        end
                    }
            })
            PluginInit.outputToLog("After adding last button")
            props.row_args = t
        end

        properties:addObserver("firstIndex", function(props, key, newValue)
            update_row_args(props, props.row_args, newValue)
        end
        )
        PluginInit.outputToLog("After adding observer")
        update_row_args(properties, properties.row_args, properties.firstIndex)
        content = f:row (LrView.bind('row_args', properties))
        PluginInit.outputToLog(print_r(properties.row_args))
--        properties.firstIndex = 1
    end)
    return content
end

-- Test
function showFilmStripTest()
--    LrFunctionContext.callWithContext( "TestFilmStripDialog", function( context )
        local photos = catalog:getTargetPhotos()
        local f = LrView.osFactory()
        local result = LrDialogs.presentModalDialog {
            title = "Filmstrip Test",
            contents = Filmstrip.makeFilmStrip({photos = photos})
        }
--    end)
end

showFilmStripTest()

