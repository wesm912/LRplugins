local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local catalog = LrApplication.activeCatalog()
local LrPrefs = import 'LrPrefs'
local LrLogger = import 'LrLogger'
local myLogger = LrLogger( 'newProjectWorkflow' )

myLogger:enable( "logfile" ) -- Pass either a string or a table of actions.
local function outputToLog( message )
    myLogger:trace( message )
end

PluginInit = {
	workflowState = "fixMetadata",
	pluginID = "com.dancinglightphotos.workflow.newproject",
    projectRoot = LrPrefs.prefsForPlugin()['projectRoot'],
    states = {
        'fixMetadata',
        'edit',
        'review',
        'finished',
    },
	URL = "http://dancinglight.photos",
    collectionIds = LrPrefs.prefsForPlugin()['collectionIds'],
}

outputToLog('Project Root')
local root = PluginInit.projectRoot
outputToLog(type(root))
outputToLog(PluginInit.projectRoot)
if root == nil then
    local result =
    LrDialogs.runOpenPanel(
        {
            title = "Choose Project Root",
            prompt= "Choose",
            canChooseFiles= false,
            canChooseDirectories= true,
            canCreateDirectories= true,
            allowsMultipleSelection= false,
            fileTypes= "directory",
            accessoryView= nil,
        }
    )
    outputToLog("Open dialog returned")
    outputToLog(result)
    if result then
        root = result[1]
        local prefs = LrPrefs.prefsForPlugin()
        prefs.projectRoot = root
        PluginInit.projectRoot = root
    end
end
outputToLog("Project Root is now " .. root)

local ids = PluginInit.collectionIds
if ids == nil then
    ids = {}
    PluginInit.collectionIds = ids
    LrPrefs.prefsForPlugin()['collectionIds'] = ids
end

function PluginInit.getCollection(collectionName)
    local ids = LrPrefs.prefsForPlugin()['collectionIds']
    local id = ids[collectionName]
    local collection = nil
    if id then
        collection = catalog:getCollectionByLocalIdentifier( id )
    end
    return collection
end

function PluginInit.setCollection(collection)
    local prefs = LrPrefs.prefsForPlugin()
    local ids = LrPrefs.prefsForPlugin()['collectionIds']
    ids[collection:getName()] = collection.localIdentifier
    prefs['collectionIds'] = ids
end



