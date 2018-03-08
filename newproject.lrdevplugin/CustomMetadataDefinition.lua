--[[----------------------------------------------------------------------------

CustomMetadataDefinition.lua
Sample custom metadata definition

--------------------------------------------------------------------------------

ADOBE SYSTEMS INCORPORATED
 Copyright 2008 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file in accordance
with the terms of the Adobe license agreement accompanying it. If you have received
this file from a source other than Adobe, then your use, modification, or distribution
of it requires the prior written permission of Adobe.

------------------------------------------------------------------------------]]

require "PluginInit"

return {

	metadataFieldsForPhotos = {

		{
			id = 'workflowState',
			title = LOC "$$$/DancingLight/Workflow/Fields/WorkflowState=Workflow State",
			dataType = 'enum',
			values = {
				{
					title = LOC "$$$/DancingLight/Workflow/Fields/fixMetadata=Start",
					value = nil,
				},
				{
					title = LOC "$$$/DancingLight/Workflow/Fields/fixMetadata=Fix Metadata",
					value = 'fixMetadata',
				},
				{
					title = LOC "$$$/DancingLight/Workflow/Fields/Edit=Edit",
					value = 'edit',
				},
				{
					title = LOC "$$$/DancingLight/Workflow/Fields/Edit=Exported",
					value = 'exported',
				},
				{
					title = LOC "$$$/DancingLight/Workflow/Fields/Review=Review",
					value = 'review',
				},
				{
					title = LOC "$$$/DancingLight/Workflow/Fields/Finished=Ready to Publish",
					value = 'finished',
				},
			},
			version = 2,
			browsable = true,
			searchable = true,
		},
		{
			id = 'intellectualGenre',
			title = LOC "$$$/DancingLight/Workflow/Fields/Genre=DL Genre",
			dataType = 'string', -- Specifies the data type for this field.
			readOnly = true,
			browsable = true,
			searchable = true,
		},
		{
			id = 'title',
			title = LOC "$$$/DancingLight/Workflow/Fields/DLTitle=DL Title",
			dataType = 'string', -- Specifies the data type for this field.
			readOnly = true,
			browsable = true,
			searchable = true,
		},
		{
			id = 'caption',
			title = LOC "$$$/DancingLight/Workflow/Fields/DLTitle=DL Caption",
			dataType = 'string', -- Specifies the data type for this field.
			readOnly = true,
			browsable = true,
			searchable = true,
		},

-- 		{
-- 			id = 'workflowState',
-- 			title = LOC "$$$/DancingLight/Workflow/Fields/DLState=Old WorkflowState",
-- 			dataType = 'string', -- Specifies the data type for this field.
-- --			readOnly = true,
-- 			browsable = true,
-- 			searchable = true,
-- 		},
		{
			id = 'location',
			title = LOC "$$$/DancingLight/Workflow/Fields/DLTitle=DL Location",
			dataType = 'string', -- Specifies the data type for this field.
			readOnly = true,
--			browsable = true,
--			searchable = true,
		},
--[[		{
			id = 'b_fixMetadata',
			title = LOC "$$$/DancingLight/Workflow/Fields/Display=Fix Metadata",
			dataType = 'enum',
			values = {
				{
					value = 'false',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/False=False",
				},
				{
					value = 'true',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/True=True",
				},
			},
			searchable = true,
			browsable = true
		},
		{
			id = 'b_metadataDone',
			title = LOC "$$$/DancingLight/Workflow/Fields/Display=Metadata Done",
			dataType = 'enum',
			values = {
				{
					value = 'false',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/False=False",
				},
				{
					value = 'true',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/True=True",
				},
			},
			searchable = true,
			browsable = true
		},
		{
			id = 'b_edit',
			title = LOC "$$$/DancingLight/Workflow/Fields/Display=Edit",
			dataType = 'enum',
			values = {
				{
					value = 'false',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/False=False",
				},
				{
					value = 'true',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/True=True",
				},
			},
			searchable = true,
			browsable = true
		},
		{
			id = 'b_editDone',
			title = LOC "$$$/DancingLight/Workflow/Fields/Display=Edit Done",
			dataType = 'enum',
			values = {
				{
					value = 'false',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/False=False",
				},
				{
					value = 'true',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/True=True",
				},
			},
			searchable = true,
			browsable = true
		},
		{
			id = 'b_review',
			title = LOC "$$$/DancingLight/Workflow/Fields/Display=Review",
			dataType = 'enum',
			values = {
				{
					value = 'false',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/False=False",
				},
				{
					value = 'true',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/True=True",
				},
			},
			searchable = true,
			browsable = true
		},
		{
			id = 'b_reviewDone',
			title = LOC "$$$/DancingLight/Workflow/Fields/Display=Review Done",
			dataType = 'enum',
			values = {
				{
					value = 'false',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/False=False",
				},
				{
					value = 'true',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/True=True",
				},
			},
			searchable = true,
			browsable = true
		},
		{
			id = 'b_finished',
			title = LOC "$$$/DancingLight/Workflow/Fields/Display=Ready to Publish",
			dataType = 'enum',
			values = {
				{
					value = 'false',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/False=False",
				},
				{
					value = 'true',
					title = LOC "$$$/DancingLight/Workflow/Fields/Display/True=True",
				},
			},
			searchable = true,
			browsable = true
		},
	--]]
	},

	schemaVersion = 2, -- must be a number, preferably a positive integer

	updateFromEarlierSchemaVersion = function( catalog, previousSchemaVersion )
		-- Note: This function is called from within a catalog:withPrivateWriteAccessDo
		-- block. You should not call any of the with___Do functions yourself.

        catalog:assertHasPrivateWriteAccess( "CustomMetadataDefinition.updateFromEarlierSchemaVersion" )

        if previousSchemaVersion == 1 then

			-- Retrieve photos that have been used already with the custom metadata.

			local photosToMigrate = catalog:findPhotosWithProperty( PluginInit.pluginID, 'state' )
			for _, photo in ipairs( photosToMigrate ) do
            	photo:setPropertyForPlugin( _PLUGIN, 'workflowState', 'fixMetadata' )
			end
		elseif previousSchemaVersion == 2 then

			-- Optional area to do further processing etc.
        end
    end,

}
