--[[----------------------------------------------------------------------------

Info.lua
NewProject.lrplugin


------------------------------------------------------------------------------]]

return {

	LrSdkVersion = 3.0,
    LrSdkMinimumVersion = 3.0, -- minimum SDK version required by this plug-in

    LrToolkitIdentifier = 'com.dancinglightphotos.workflow.newproject',

    LrPluginName = LOC "$$$/NewProject/Workflow/PluginName=New Project Workflow",

    -- Add the menu item to the Library menu.

    LrLibraryMenuItems = {
        {
            title = LOC "$$$/NewProject/Workflow/NewProject=New Project",
            file = "CustomDialogWithObserver.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/AddToProject=Add Photos to Project",
            file = "AddToProject.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/CopyRAWforEdit=Copy RAW files for editing",
            file = "CopyRawForEditDialog.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/MoveToReview=Move to Review",
            file = "MoveToReview.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/AddToStock=Add to Stock",
            file = "AddToStock.lua",
        },
    },

    LrExportMenuItems = {
        {
            title = LOC "$$$/NewProject/Workflow/NewProject=New Project",
            file = "CustomDialogWithObserver.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/AddToProject=Add Photos to Project",
            file = "AddToProject.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/CopyRAWforEdit=Copy RAW files for editing",
            file = "CopyRawForEditDialog.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/MoveToReview=Move to Review",
            file = "MoveToReview.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/AddToStock=Add to Stock",
            file = "AddToStock.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/ShowFilmStrip=Filmstrip",
            file = "Filmstrip.lua",
        },
        {
            title = LOC "$$$/NewProject/Workflow/PublishToInstagram=Publish to Instagram",
            file = "PublishToInstagram.lua",
        },
    },
    -- Add the Metadata Definition File
    LrMetadataProvider = 'CustomMetadataDefinition.lua',

    -- Add the Metadata Tagset File
    LrMetadataTagsetFactory =  'CustomMetadataTagset.lua',
--        'AllMetadataTagset.lua',
    -- Add the entry for the Plug-in Manager Dialog
    LrPluginInfoProvider = 'PluginInfoProvider.lua',

	VERSION = { major=1, minor=0, revision=1, build=1, },

}
