--[[
    AddToProject.lua
--]]

require "PluginInit"


local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local catalog = LrApplication.activeCatalog()
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'
local LrLogger = import 'LrLogger'
local myLogger = LrLogger( 'newProjectWorkflow' )
local projectRoot = PluginInit.projectRoot
local bind = LrView.bind


local function showProjectPickerDialog()
    -- -- outputToLog("Entering showProjectPickerDialog")
    LrTasks.startAsyncTask(
        function()
            local currentProject = PluginInit.selectedProject()
            local projectNames = {}
            local allProjects = PluginInit.getProjects()
            -- outputToLog("Current project: " .. (currentProject or "NONE"))
            local popupItems = {}
            local chosenIndex = -1
            for i, p in ipairs(allProjects) do
                table.insert(popupItems, {title = p:getName(), value = i})
                -- outputToLog("inserted " .. p:getName() .. " and value " .. i)
                if p:getName() == currentProject then
                    -- outputToLog("setting chosenIndex to " .. i)
                    chosenIndex = i
                end
            end
            LrFunctionContext.callWithContext( "showProjectPickerDialog", function( context )

                local props = LrBinding.makePropertyTable( context )
                props.chosenProject = currentProject or ""
                props.chosenIndex = chosenIndex

                local f = LrView.osFactory()

                -- create view hierarchy
                local contents = f:column {
                    fill_horizontal = 1,
                    spacing = f:control_spacing(),
                    bind_to_object = props,
                    -- default bound table is the one we made
                    f:static_text {
                        alignment = "left",
                        title = "Choose a Project: "
                    },

                    f:group_box {
                        fill_horizontal = 1,
                        spacing = f:control_spacing(),
                        f:popup_menu {
                            value = bind 'chosenIndex',
                            items = popupItems,
                        },
                    },
                }

                local result = LrDialogs.presentModalDialog {
                        title = "Add Photos to Project",
                        contents = contents,
                }
                -- outputToLog("Chose Project " .. props.chosenIndex)
                -- outputToLog(result)

                if ( result == 'ok') then
                    local chosenProject = allProjects[props.chosenIndex]
                    local candidates = nil
                    for j, c in ipairs(chosenProject:getChildCollections()) do
                        if c:getName() == chosenProject:getName() .. " candidates" then
                            -- outputToLog("Found candidates " .. c:getName())
                            candidates = c
                            break
                        end
                    end
                    if candidates then
                        photos = catalog:getTargetPhotos()
                        catalog:withWriteAccessDo("AddPhotosToCollection",
                            function(context)
                                candidates:addPhotos(photos)
                                for _, photo in ipairs(photos) do
                                    -- outputToLog("Added candidate " .. photo:getFormattedMetadata("fileName"))
                                    photo:setPropertyForPlugin(_PLUGIN, 'workflowState', 'fixMetadata')
                                end
                            end
                        )
                    end
                end
            end) -- end main function
        end) -- startAsyncTask
end

-- Now display the dialogs.

showProjectPickerDialog()

