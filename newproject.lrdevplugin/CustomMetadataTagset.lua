--[[----------------------------------------------------------------------------

CustomMetadataTagset.lua
Sample custom metadata tagset

--------------------------------------------------------------------------------

ADOBE SYSTEMS INCORPORATED
 Copyright 2008 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file in accordance
with the terms of the Adobe license agreement accompanying it. If you have received
this file from a source other than Adobe, then your use, modification, or distribution
of it requires the prior written permission of Adobe.

------------------------------------------------------------------------------]]

return{

	title = LOC "$$$/CustomMetadata/Tagset/Title=Dancing Light Custom Metadata",
	id = 'DancingLightCustomMetadataTagset',

	items = {
		{ 'com.adobe.label', label = LOC "$$$/Metadata/OrigLabel=Standard Metadata" },
		'com.adobe.filename',
		'com.adobe.folder',

		'com.adobe.title',
		{ 'com.adobe.caption', height_in_lines = 3 },
		"com.adobe.separator",

		{
			formatter = "com.adobe.label",
		  	label = LOC "$$$/CustomMetadata/Fields/IPTCLabel=IPTC",
		},
		"com.adobe.intellectualGenre",
		"com.adobe.location",
		'com.adobe.city',
        'com.adobe.state',
        'com.adobe.country',
        'com.adobe.isoCountryCode',
		"com.adobe.locationCreated",
		"com.adobe.locationShown",
		"com.adobe.event",
		"com.adobe.iptcPersonShown",
		"com.adobe.separator",

		{
			formatter = "com.adobe.label",
			label = LOC "$$$/CustomMetadata/Fields/Workflow=Workflow",
		},
		"com.dancinglightphotos.workflow.newproject.workflowState",
	},
}
