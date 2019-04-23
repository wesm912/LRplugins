-- CopyRawForEditDialog.lua
require 'PluginInit'
require 'ExportSettings'
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
local LrExportSession = import 'LrExportSession'
-- local ExportSettings = import 'ExportSettings'

myLogger:enable( "logfile" ) -- Pass either a string or a table of actions.

-- Write trace information to the logger.

local function outputToLog( message )
    myLogger:trace( message )
end
--[[
The focus shifts somewhat from previous versions. The project subdirectories are only there to hold assets
derived from raw files, either by passing to an external editor, or by conversion to jpg or another web
format within LR. We no longer copy all the raw files to the Projects subdirectories.

--]]

LrTasks.startAsyncTask( function ()
    local project = PluginInit.selectedProject()

    if project then
        local projectDir = LrPathUtils.child(projectRoot, project)
        outputToLog("projectDir is " .. projectDir)
        LrFileUtils.createAllDirectories(projectDir)
        LrFileUtils.createAllDirectories(LrPathUtils.child(projectDir, "review"))
        -- "publish" holds finished psd, tiff, raw files ready for conversion to JPG
        -- when converted, they go to a subdirectory of print or web folders
        -- The subdirectory indicates the target, the filename carries the quality and size

        LrFileUtils.createAllDirectories(LrPathUtils.child(projectDir, "publish"))
        LrFileUtils.createAllDirectories(LrPathUtils.child(projectDir, "print"))
        local webDir = LrPathUtils.child(projectDir, "web")
        LrFileUtils.createAllDirectories(webDir)
        local exportSettings = ExportSettings.getExportSettings(projectDir, "edits")
        LrTasks.startAsyncTask(
            function( )
                    outputToLog("Starting async task")
                    local photos = catalog:getTargetPhotos()
                    for _, photo in ipairs(photos) do
                        outputToLog(photo:getFormattedMetadata()['fileName'])
                    end
                local exportSession = LrExportSession({
                    photosToExport = photos,
                    exportSettings = exportSettings,
                })
                local activePhoto = nil
                local result = catalog:withWriteAccessDo("doExportOnCurrentTask",
                        function (context)
                            exportSession:doExportOnCurrentTask()
                            -- Set workflow state so shows up back in LR
                            local first = true
                            for _, rendition in exportSession:renditions() do
                                local success, pathOrMessage = rendition:waitForRender()
                                outputToLog("Got pathOrMessage: " .. pathOrMessage)
                                if success then
                                    local photo = catalog:addPhoto(rendition.destinationPath)
                                    if photo then
                                        photo:setPropertyForPlugin(_PLUGIN, 'workflowState', 'edit')
                                        activePhoto = photo
                                    end
                                else
                                    outputToLog("Got error waiting for rendition: " .. pathOrMessage)
                                end
                            end
                            if activePhoto then
                                local editsFolderPath = LrPathUtils.child(projectDir, "edits")
                                local editsFolder = catalog:getFolderByPath(editsFolderPath)
                                catalog:setActiveSources(editsFolder)
                                activePhoto:getFormattedMetadata("fileName")
--                                outputToLog("Setting activePhoto to " .. activePhoto:getFormattedMetadata("folderName") .. "/" ..
--                                        activePhoto:getFormattedMetadata("fileName"))
                                catalog:setSelectedPhotos(activePhoto, {})
                            end
                        end)
                outputToLog("write access do returned " .. result)
        end)
    end
end)
