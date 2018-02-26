--[[----------------------------------------------------------------------------

Info.lua
NewProject.lrplugin


------------------------------------------------------------------------------]]

return {

	LrSdkVersion = 3.0,
    LrSdkMinimumVersion = 3.0, -- minimum SDK version required by this plug-in

    LrToolkitIdentifier = 'com.dancinglightphotos.workflow.newproject',

    LrPluginName = LOC "$$$/NewProject/Workflow/PluginName=New Project Workflow",

    -- Add the menu item to the File menu.

    LrLibraryMenuItems = {
        {
            title = LOC "$$$/NewProject/Workflow/NewProject=New Project",
            file = "CustomDialogWithObserver.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/SyncMetadata=Sync Metadata",
            file = "SyncMetadata.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/CopyRAWforEdit=Copy RAW files for editing",
            file = "CopyRawForEditDialog.lua",
        },
    },
    -- Add the Metadata Definition File
    LrMetadataProvider = 'CustomMetadataDefinition.lua',

    -- Add the Metadata Tagset File
    LrMetadataTagsetFactory =  'CustomMetadataTagset.lua',
--        'AllMetadataTagset.lua',
    -- Add the entry for the Plug-in Manager Dialog
    LrPluginInfoProvider = 'PluginInfoProvider.lua',

--  Export service provider to do copy of original to "editing" folder
--[[
    LrExportServiceProvider = {
        title = "Copy RAW files to edit",
        file = 'ExportOriginalsToEditServiceProvider.lua',
    },
--]]
	VERSION = { major=1, minor=0, revision=0, build=1, },

}
