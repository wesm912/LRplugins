--[[
    CreateCollections.lua
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
local LrLogger = import 'LrLogger'
local myLogger = LrLogger( 'newProjectWorkflow' )

myLogger:enable( "logfile" ) -- Pass either a string or a table of actions.

-- Write trace information to the logger.

root = PluginInit.projectRoot
rootLeaf = LrPathUtils.leafName(root)
PluginInit.outputToLog("Project Root is now " .. root)

CreateCollections = {}

local function capitalize(s)
    if s and string.len(s) == 1 then
        return s:upper()
    elseif s and string.len(s) > 1 then
        return string.upper( s:sub(1,1) ) .. s:sub(2)
    else
        return s
    end
end


local function editingSearchDescriptor(project)
    return  {
        {
            combine = "union",
           {
                criteria = "collection",
                operation = "all",
                value = project .. " candidates",
            },
            {
                criteria = "folder",
                operation = "words",
                value = rootLeaf .. " " .. project .. " edits"
            }
        },

        {
            criteria = "sdk:com.dancinglightphotos.workflow.newproject.workflowState",
            operation = "==",
            value = 'edit',
        },
        combine = "intersect",
    }
end

local function reviewSearchDescriptor(project)
    return {
        {
            combine = "union",
           {
                criteria = "collection",
                operation = "all",
                value = project .. " candidates",
            },
            {
                criteria = "folder",
                operation = "words",
                value = rootLeaf .. " " .. project .. " review"
            }
        },

        combine = "intersect",
        {
            criteria = "sdk:com.dancinglightphotos.workflow.newproject.workflowState",
            operation = "==",
            value = 'review'
        },
    }
end

local function finishedSearchDescriptor(project)
    return {
        {
            combine = "union",
           {
                criteria = "collection",
                operation = "all",
                value = project .. " candidates",
            },
            {
                criteria = "folder",
                operation = "words",
                value = rootLeaf .. " " .. project .. " publish"
            }
        },

        combine = "intersect",
        {
            criteria = "sdk:com.dancinglightphotos.workflow.newproject.workflowState",
            operation = "==",
            value = 'finished'
        },
    }
end

local function collectionDescriptor(project)
    return
        {
            criteria = "collection",
            operation = "all",
            value = project .. ' candidates',
        }
end



local function setDefaultPluginProps(photo)

end

local function replaceEmptyMetadata(photo, key, display)
    PluginInit.outputToLog('replaceEmptyMetadata args: ' .. key ..', ' .. display)
    local value = photo:getFormattedMetadata(key)
    PluginInit.outputToLog('replaceEmptyMetadata value: ' .. value)
    if value:len() <= 0 then
        PluginInit.outputToLog('Setting Raw metadata for ' .. key .. ' to No ' .. capitalize(display))
        if key == 'title' then
            PluginInit.outputToLog('Setting plugin property for ' .. key .. ' to No ' .. capitalize(display))
            photo:setPropertyForPlugin(_PLUGIN,  key,
                "No " .. display)
            PluginInit.outputToLog('SUCCESS Setting plugin property for ' .. key .. ' to No ' .. capitalize(display))
        end
        photo:setRawMetadata(key, "No " .. capitalize(display))
    else
        photo:setPropertyForPlugin(_PLUGIN, key, value)
    end
end

function CreateCollections.createWorkflow(collectionName)
    LrFunctionContext.callWithContext( 'createWorkflow',
        function(context, collectionName)
            PluginInit.outputToLog('createWorkflow called with arg ')
            PluginInit.outputToLog(collectionName)
            LrTasks.startAsyncTask(
                function( )
                    PluginInit.outputToLog("Starting async task")
                    local projects, newProject, candidates, externalEdits
                    local result = catalog:withWriteAccessDo("CreateCollectionSets",
                        function (context)
                            PluginInit.outputToLog("Begin creating collection sets")
                            projects = catalog:createCollectionSet('Projects', nil, true)
                            PluginInit.outputToLog("Created 'Projects' collectionSet " )

                            newProject = catalog:createCollectionSet(collectionName, projects, true)

                            local workflow = catalog:createCollectionSet("Workflow", newProject, true)
                            candidates = catalog:createCollection(collectionName .. ' candidates', newProject, true)

                            local metadata = catalog:createCollectionSet('1 Metadata', workflow, true)
                            local fixTitle = catalog:createSmartCollection('1.1 Fix Title',
                            {
                                combine = "intersect",
                                collectionDescriptor(collectionName),
                                {
                                    criteria = "title",
                                    operation = "all",
                                    value = "No Title",
                                    value2 = "",
                                },
                            }, metadata, true)
                            local caption = catalog:createSmartCollection('1.2 Fix Caption',
                            {
                                combine = "intersect",
                                collectionDescriptor(collectionName),
                                {
                                    criteria = "caption",
                                    operation = "all",
                                    value = "No Caption",
                                    value2 = "",
                                },
                            }, metadata, true)
                            local genre = catalog:createSmartCollection('1.3 Fix Genre',
                            {
                                combine = "intersect",
                                collectionDescriptor(collectionName),
                                {
                                    criteria = "iptc",
                                    operation = "words",
                                    value = "No Genre",
                                    value2 = "",
                                },
                            }, metadata, true)
                            local location = catalog:createSmartCollection('1.4 Fix Location',
                            {
                                combine = "intersect",
                                collectionDescriptor(collectionName),
                                {
                                    criteria = "location",
                                    operation = "all",
                                    value = "No Location",
                                    value2 = "",
                                },
                            }, metadata, true)
                            local ready = catalog:createSmartCollection('1.99 Ready to Edit',
                            {
                                combine = "intersect",
                                collectionDescriptor(collectionName),
                                {
                                    criteria = "sdk:com.dancinglightphotos.workflow.newproject.workflowState",
                                    operation = "==",
                                    value = 'fixMetadata'
                                },
                                {
                                    combine = "exclude",
                                    {
                                        criteria = "title",
                                        operation = "all",
                                        value = "No Title",
                                        value2 = "",
                                    },
                                    {
                                        criteria = "caption",
                                        operation = "all",
                                        value = "No Caption",
                                        value2 = "",
                                    },
                                    {
                                        criteria = "iptc",
                                        operation = "words",
                                        value = "No Genre",
                                        value2 = "",
                                    },
                                    {
                                        criteria = "location",
                                        operation = "all",
                                        value = "No Location",
                                        value2 = "",
                                    },

                                },

                            }, metadata, true)

                            local editing = catalog:createSmartCollection('2 Editing',
                                editingSearchDescriptor(collectionName), workflow, true)
                            local reviews = catalog:createSmartCollection('3 Review',
                                reviewSearchDescriptor(collectionName), workflow, true)
                            local finished = catalog:createSmartCollection('4 Ready to Publish',
                                finishedSearchDescriptor(collectionName), workflow, true)
                            local photos = catalog:getTargetPhotos()
                            candidates:addPhotos(photos)
                            for _, photo in ipairs(photos) do
                                replaceEmptyMetadata(photo, 'intellectualGenre', 'genre')
                                replaceEmptyMetadata(photo, 'title', 'title')
                                replaceEmptyMetadata(photo, 'caption', 'caption')
                                replaceEmptyMetadata(photo, 'location', 'location')
                                photo:setPropertyForPlugin(_PLUGIN, 'workflowState', 'fixMetadata')
                            end
                        end,  -- withWriteAccessDo
                        {
                            timeout = 60,
                            callback = function() PluginInit.outputToLog("task timed out") end,
                        }
                    )
                    PluginInit.setCollection(projects)
                    PluginInit.setCollection(newProject)
                    PluginInit.setCollection(candidates)
                    PluginInit.outputToLog("Result returned from call to withWriteAccessDo: " .. result)
                end -- startAsyncTask function
            )
        end, -- callWithContext
        collectionName)
end



