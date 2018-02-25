--[[
    CreateGlobalCollections.lua
--]]
require 'PluginInit'

local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local catalog = LrApplication.activeCatalog()

local LrLogger = import 'LrLogger'
local myLogger = LrLogger( 'newProjectWorkflow' )

myLogger:enable( "logfile" ) -- Pass either a string or a table of actions.

-- Write trace information to the logger.

local function outputToLog( message )
    myLogger:trace( message )
end

CreateGlobalCollections = {}

function CreateGlobalCollections.createGlobalWorkflow()
    -- LrFunctionContext.callWithContext( 'createGlobalWorkflow',
    --     function(context)
            LrTasks.startAsyncTask(
                function( )
    --                 outputToLog("Starting async task for createGlobalWorkflow")
                    local result = catalog:withWriteAccessDo("CreateGlobalCollectionSets",
                        function (context)
                            outputToLog("Begin creating global collection sets")
                            local globalWorkflow = catalog:createCollectionSet('Global Workflow', nil, true)
                            local firstPass = catalog:createSmartCollection('1. First Pass',
                                     {
                                         criteria = "rating",
                                         operation = "==",
                                         value = 1,
                                     },
                                     globalWorkflow, true)
                            local secondPass = catalog:createSmartCollection('2. Second Pass',
                                     {
                                         criteria = "rating",
                                         operation = "==",
                                         value = 2,
                                     },
                                     globalWorkflow, true)
                            local readyToEdit = catalog:createSmartCollection('3. Ready To Edit',
                                     {
                                         criteria = "rating",
                                         operation = "==",
                                         value = 3,
                                     },
                                     globalWorkflow, true)
                        end,
                        {
                            timeout = 60,
                            callback = function() outputToLog("task timed out") end,
                        }

                    )
                end
            )
    --     end
    -- )
end

