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

function getPhotoEditFields(photo)
    local title = photo:getFormattedMetadata('title')
    local caption = photo:getFormattedMetadata('caption')
    local genre = photo:getFormattedMetadata('intellectualGenre')
    local width = photo:getRawMetadata('width')
    local height = photo:getRawMetadata('height')
    local aspectRatio = photo:getRawMetadata('aspectRatio')
    return {title = title, caption = caption, genre = genre, height = height, width = width, aspectRatio = aspectRatio}
end

function savePhotoMetadataChanges(photo, args)
    PluginInit.outputToLog("Setting title to " .. args['title'] .. "for photo " .. photo.localIdentifier)
    photo:setRawMetadata('title', args['title'] or 'No Title')
    photo:setRawMetadata('caption', args['caption'] or 'No Caption')
    photo:setRawMetadata('intellectualGenre', args['genre'] or 'No Genre')
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
    content = LrFunctionContext.callWithContext( 'makeFilmStrip',
        function( context )
            local f = LrView.osFactory()
            local properties = LrBinding.makePropertyTable( context )
            properties.photos = args.photos
            local photos = args.photos
            properties.firstIndex = 1
            properties.length = length
            properties.edit_metadata = {}
            cat_photo_thumbnails = {}

            for i, photo in ipairs(args.photos) do
                properties.edit_metadata[photo.localIdentifier] = getPhotoEditFields(photo)
                table.insert(cat_photo_thumbnails,
                    f:catalog_photo({
                        photo = photo,
                        width = 128,
                        height = 128,
                        mouse_down = function (obj)
                            PluginInit.outputToLog("Calling photoOnClick for obj " .. tostring(obj))
                            photoOnClick(obj)
                        end,
                        }))
            end
            properties.selectedPhoto = photos[properties.firstIndex]

            local function saveMetadataChanges(photo)
                PluginInit.outputToLog("Saving metadata for photo " .. photo.localIdentifier)
                LrTasks.startAsyncTask( function()
                    catalog:withWriteAccessDo("saveMetadataChanges",
                        function (context)
                            PluginInit.outputToLog("Saving metadata for individual photo " .. photo.localIdentifier)
                            savePhotoMetadataChanges(photo, properties.edit_metadata[photo.localIdentifier])
                        end)
                    end)
            end
            local function photoOnClick(catPhoto)
                properties.selectedPhoto = catPhoto.photo
                updateSelectedPhotoFields()
            end
           local function updateSelectedPhotoFields()
                local id = properties.selectedPhoto.localIdentifier
                properties.selectedTitle = properties.edit_metadata[id]['title']
                properties.selectedCaption = properties.edit_metadata[id]['caption']
                properties.selectedGenre = properties.edit_metadata[id]['genre']
            end
            updateSelectedPhotoFields()
            content = f:column {
                bind_to_object = properties,
                f:row {
                    spacing = 20,
                    f:catalog_photo({
                        width = 512,
                        height = 512,
                        photo = LrView.bind('selectedPhoto')
                        }),
                    f:group_box {
                        place_vertical = .5,
                        f:row {
                            fill_horizonal = 1,
                            spacing = f:label_spacing(),
                            f:static_text {title = 'Title'},
                            f:edit_field {
                                value = LrView.bind('selectedTitle'),
                                wraps = true,
                                validate = function(view, value)
                                    PluginInit.outputToLog("Validating title field " .. value)
                                    if #value == 0 then
                                        return false, value, "Please type a non-empty string"
                                    else
                                        local id = properties.selectedPhoto.localIdentifier                                        properties.edit_metadata[id]['title'] = value
                                        updateSelectedPhotoFields()
                                        properties.edit_metadata[id]['title'] = value
                                        PluginInit.outputToLog("New value of selectedTitle: " .. properties.selectedTitle)
                                        return true, value, ""
                                    end
                                end
                            },
                        },
                        f:row {
                            fill_horizonal = 1,
                            spacing = f:label_spacing(),
                            f:static_text {title = 'Caption'},
                            f:edit_field {
                                value = LrView.bind('selectedCaption'),

                                validate = function(view, value)
                                    if #value == 0 then
                                        return false, value, "Please type a non-empty string"
                                    else
                                        local id = properties.selectedPhoto.localIdentifier                                        properties.edit_metadata[id]['caption'] = value
                                        properties.edit_metadata[id]['caption'] = value
                                        updateSelectedPhotoFields()
                                        return true, value, ""
                                    end
                                end,
                                wraps = true},
                        },
                        f:row {
                            fill_horizonal = 1,
                            spacing = f:label_spacing(),
                            f:static_text {title = 'Genre'},
                            f:edit_field {
                                value = LrView.bind('selectedGenre'),

                                validate = function(view, value)
                                    if #value == 0 then
                                        return false, value, "Please type a non-empty string"
                                    else
                                        local id = properties.selectedPhoto.localIdentifier
                                        properties.edit_metadata[id]['genre'] = value
                                        updateSelectedPhotoFields()
                                        return true, value, ""
                                    end
                                end,
                                wraps = true},
                        },
                        f:push_button {
                            title = "Save Changes",
                            action = function()
                                PluginInit.outputToLog("Save button action called")
                                saveMetadataChanges(properties.selectedPhoto)
                            end
                        },
                    },
                },
                f:row {
                    spacing = 100,
                    f:push_button {
                        title = "<",
                        action = function (button)
                            properties.firstIndex = math.max(properties.firstIndex - 1, 1)
                            properties.selectedPhoto = properties.photos[properties.firstIndex]
                            updateSelectedPhotoFields()
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
                            properties.firstIndex = math.min(properties.firstIndex + 1, length)
                            properties.selectedPhoto = properties.photos[properties.firstIndex]
                            updateSelectedPhotoFields()
                        end,
                        enabled = LrView.bind {
                            key = "firstIndex",
                            transform = function(value, tbl)
                                return value < length
                            end
                        }
                    },
                },
                f:row {
                    fill_horizontal = 1,
                    margin_vertical = 10,
                    f:scrolled_view {
                        width = 800,
                        fill_horizontal = 1,
                        horizontal_scroller = true,
                        vertical_scroller   = false,
                        f:row (cat_photo_thumbnails),
                    },
                },
            }
            return content
        end)
    return content
end

-- Test
function showFilmStripTest()
    LrTasks.startAsyncTask( function()
        local photos = catalog:getTargetPhotos()
        local f = LrView.osFactory()
        local content = Filmstrip.makeFilmStrip({photos = photos})
        PluginInit.outputToLog("makeFilmStrip returned " .. tostring(content))
        local result = LrDialogs.presentModalDialog {
            title = "Filmstrip Test",
            contents = content,
        }
    end)
end

showFilmStripTest()

