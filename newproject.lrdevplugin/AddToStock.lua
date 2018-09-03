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


LrTasks.startAsyncTask( function ()
    local keyword = nil;
    catalog:withWriteAccessDo("doCreateKeyword",
        function( context )
            keyword = catalog:createKeyword('stock', {}, true, nil, true)
        end)
    if keyword then
        local photos = catalog:getTargetPhotos()
        local result = catalog:withWriteAccessDo("doAddToStock",
            function (context)
                for _, photo in ipairs(photos) do
                    photo:addKeyword(keyword)
                end
        end)
    end
end)