--[[
    PublishToInstagram.lua
    Add selected photos to LR/Instagram service
    Later modify to create a separate collection set and collection
--]]

require 'PluginInit'

local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrPathUtils = import 'LrPathUtils'
local catalog = LrApplication.activeCatalog()
local LrPrefs = import 'LrPrefs'

PublishToInstagram = {
    igServiceID = 0,
    igService = nil,
    igCollection = nil,
}

function PublishToInstagram.init()
    LrTasks.startAsyncTask(
        function()
            services = catalog:getPublishServices(nil)
            local photos = catalog:getTargetPhotos()
            for _, service in ipairs(services) do
                name = service:getName()
                id = service.localIdentifier
                if string.find(name, "[Ii]nstagram") then
                    PublishToInstagram.igServiceID = id
                    PublishToInstagram.igService = service
                    catalog:withWriteAccessDo("Create Published Collection LR Imports",
                        function (context)
                            local collection = service:createPublishedCollection( "LR Imports", nil, true )
                            PublishToInstagram.igCollection = collection
                            PluginInit.outputToLog("Found collection " .. tostring(collection) )
                            collection:addPhotos(photos)
                            collection:publishNow()
                        end
                    )
                    break
                end
            end
        end)
end

PublishToInstagram.init()