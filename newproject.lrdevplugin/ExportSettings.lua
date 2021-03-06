ExportSettings = {}
function ExportSettings.getWebExportSettings(directory, subdirectory)
    local exportSettings = {
        LR_collisionHandling = "ask",
        LR_embeddedMetadataOption = "all",
        LR_exportServiceProvider = "com.adobe.ag.export.file",
        LR_exportServiceProviderTitle = "Hard Drive",
        LR_export_colorSpace = "AdobeRGB",
        LR_export_destinationPathPrefix = directory,
        LR_export_destinationPathSuffix = subdirectory,
        LR_export_destinationType = "specificFolder",
        LR_export_externalEditingApp = "/Applications/Adobe Lightroom Classic CC/Adobe Lightroom Classic CC.app",
        LR_export_postProcessing = "revealInFinder",
        LR_export_useSubfolder = false,
        LR_export_videoFileHandling = "include",
        LR_export_videoFormat = "4e49434b-4832-3634-fbfb-fbfbfbfbfbfb",
        LR_export_videoPreset = "original",
        LR_extensionCase = "lowercase",
        LR_format = "JPEG",
        LR_includeFaceTagsAsKeywords = false,
        LR_includeFaceTagsInIptc = false,
        LR_includeVideoFiles = true,
        LR_initialSequenceNumber = 1,
        LR_jpeg_limitSize = 2048,
        LR_jpeg_useLimitSize = true,
        LR_metadata_keywordOptions = "flat",
        LR_outputSharpeningLevel = 2,
        LR_outputSharpeningMedia = "screen",
        LR_outputSharpeningOn = true,
        LR_reimportExportedPhoto = true,
        LR_reimport_stackWithOriginal = true,
        LR_reimport_stackWithOriginal_position = "below",
        LR_removeFaceMetadata = true,
        LR_removeLocationMetadata = false,
        LR_renamingTokensOn = true,
        LR_selectedTextFontFamily = "Myriad Web Pro",
        LR_selectedTextFontSize = 12,
        LR_size_doConstrain = true,
        LR_size_maxWidth = 1800,
        LR_size_maxHeight = 1800,
        LR_size_percentage = 100,
        LR_size_resizeType = "longEdge",
        LR_size_resolution = 120,
        LR_size_units = "pixels",
        LR_size_resolutionUnits = "inch",
        LR_tokenCustomString = "Wes Mitchell",
        LR_tokens = "{{image_name}}",
        LR_tokensArchivedToString2 = "{{image_name}}",
        LR_useWatermark = true,
        LR_watermarking_id = "<dancingLight>",
    }
    return exportSettings
end
return ExportSettings