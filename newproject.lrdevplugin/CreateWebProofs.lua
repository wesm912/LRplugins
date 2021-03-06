-- CreateWebProofs.lua

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
    "publish" 2M jpeg proofs of the selected photos
--]]

LrTasks.startAsyncTask( function ()
    local project = PluginInit.selectedProject()
    outputToLog("Starting with project root " .. projectRoot)
    local projectDir
    if project then
        projectDir = LrPathUtils.child(projectRoot, project)
    else
        projectDir = LrPathUtils.child(projectRoot, "export")
    end
    outputToLog("Starting with export root " .. projectDir)
    LrFileUtils.createAllDirectories(projectDir)
    local web = LrPathUtils.child(projectDir, "web")
    LrFileUtils.createAllDirectories(web)
    local proofs = LrPathUtils.child(web, "proofs")
    LrFileUtils.createAllDirectories(proofs)

    result = LrDialogs.runOpenPanel({
            title = "Choose Folder",
            prompt = "Choose",
            canChooseFiles = false,
            canChooseDirectories = true,
            canCreateDirectories = true,
            allowsMultipleSelection = false,
            initialDirectory = proofs,
        })
    local target = proofs
    if not result then
        outputToLog("No new directory chosen")
    else
        target = result[1]
        outputToLog("Chose new directory " .. result[1])
    end
    local exportSettings = ExportSettings.getWebExportSettings(target, "proofs")
    LrTasks.startAsyncTask(
        function( )
            outputToLog("Starting async task exporting web proofs")
            local photos = catalog:getTargetPhotos()
            if #photos == 0 then return end

            local exportSession = LrExportSession({
                photosToExport = photos,
                exportSettings = exportSettings,
            })

            local result = catalog:withWriteAccessDo("doExportOnCurrentTask",
                    function (context)
                        exportSession:doExportOnCurrentTask()
                        for _, rendition in exportSession:renditions() do
                            local success, pathOrMessage = rendition:waitForRender()
                            outputToLog("Got pathOrMessage: " .. pathOrMessage)
                            if success then
                                outputToLog("Exported rendition: " .. pathOrMessage)
                            else
                                outputToLog("Got error waiting for rendition: " .. pathOrMessage)
                            end
                        end
                    end)
            outputToLog("write access do returned " .. result)
    end)
end)
