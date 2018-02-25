-- CopyRawForEditDialog.lua
require 'PluginInit'

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

myLogger:enable( "logfile" ) -- Pass either a string or a table of actions.

-- Write trace information to the logger.

local function outputToLog( message )
    myLogger:trace( message )
end

local function containingProject (collection)
    local project = collection:getParent()
    local c = collection
    while project do
        if project:getName() == 'Projects' then
            break
        else
            c = project
            project = c:getParent()
        end
    end
    return (project and c:getName()) or nil
end

local function selectedProject()
    local sources = catalog:getActiveSources()
    local project = nil
    if type(sources) == "string" then
        outputToLog("active sources: " .. sources)
        LrDialogs.error("Operation not supported for collection " .. sources)
    elseif type(sources) ==  "table" then
        for _, val in ipairs(sources) do
            outputToLog(val:getName())
            project = containingProject(val)
            if project then
                break
            end
            outputToLog("Project is " .. (project or "NONE"))
        end
    else
        LrDialogs.error("Collection not part of a project")
        outputToLog("unknown type for sources: " .. type(sources))
    end
    return project
end

LrTasks.startAsyncTask( function ()
    local project = selectedProject()

    if project then
        local projectDir = LrPathUtils.child(projectRoot, project)
        outputToLog("projectDir is " .. projectDir)
        LrFileUtils.createAllDirectories(projectDir)
        local exportSettings = {
            LR_collisionHandling = "ask",
            LR_embeddedMetadataOption = "all",
            LR_exportServiceProvider = "com.adobe.ag.export.file",
            LR_exportServiceProviderTitle = "Hard Drive",
            LR_export_colorSpace = "AdobeRGB",
            LR_export_destinationPathPrefix = projectDir,
            LR_export_destinationPathSuffix = "edits",
            LR_export_destinationType = "specificFolder",
            LR_export_externalEditingApp = "/Applications/Adobe Lightroom Classic CC/Adobe Lightroom Classic CC.app",
            LR_export_postProcessing = "doNothing",
            LR_export_useSubfolder = true,
            LR_export_videoFileHandling = "include",
            LR_export_videoFormat = "4e49434b-4832-3634-fbfb-fbfbfbfbfbfb",
            LR_export_videoPreset = "original",
            LR_extensionCase = "lowercase",
            LR_format = "ORIGINAL",
            LR_includeFaceTagsAsKeywords = true,
            LR_includeFaceTagsInIptc = true,
            LR_includeVideoFiles = true,
            LR_initialSequenceNumber = 1,
            LR_jpeg_limitSize = 4800,
            LR_jpeg_useLimitSize = false,
            LR_metadata_keywordOptions = "flat",
            LR_outputSharpeningLevel = 2,
            LR_outputSharpeningMedia = "screen",
            LR_outputSharpeningOn = false,
            LR_reimportExportedPhoto = false,
            LR_reimport_stackWithOriginal = false,
            LR_reimport_stackWithOriginal_position = "below",
            LR_removeFaceMetadata = false,
            LR_removeLocationMetadata = false,
            LR_renamingTokensOn = true,
            LR_selectedTextFontFamily = "Myriad Web Pro",
            LR_selectedTextFontSize = 12,
            LR_size_doConstrain = false,
            LR_size_percentage = 100,
            LR_size_resolution = 240,
            LR_size_resolutionUnits = "inch",
            LR_tokenCustomString = "Wes Mitchell",
            LR_tokens = "{{image_name}}",
            LR_tokensArchivedToString2 = "{{image_name}}",
            LR_useWatermark = false,
            LR_watermarking_id = "<simpleCopyrightWatermark>",
        }
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
                    local result = catalog:withWriteAccessDo("doExportOnCurrentTask",
                            function (context)
                                exportSession:doExportOnCurrentTask()
                                -- Set workflow state so shows up back in LR
                                for _, rendition in exportSession:renditions() do
                                    local success, pathOrMessage = rendition:waitForRender()
                                    outputToLog("Got pathOrMessage: " .. pathOrMessage)
                                    if success then
                                        local photo = catalog:addPhoto(rendition.destinationPath)
                                        if photo then
                                            photo:setPropertyForPlugin(_PLUGIN, 'workflowState', 'edit')
                                            local externalEdits = PluginInit.getCollection(project .. " external edits")
                                            externalEdits:addPhotos( {photo} )
                                        end
                                    else
                                        outputToLog("Got error waiting for rendition: " .. pathOrMessage)
                                    end
                                end
                            end)
                    outputToLog("write access do returned " .. result)
                end)
    end
    end)
