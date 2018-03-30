ExportSettings = {}
function ExportSettings.getExportSettings(prefix, suffix, constrain, resolution, width, height, mp, resizeType)
    if not resolution then
        resolution = 240
    end
    if constrain then
        if not width and not height and not mp then
            return "Error: Bad parameters"
        end
    end
    local exportSettings = {
        LR_collisionHandling = "ask",
        LR_embeddedMetadataOption = "all",
        LR_exportServiceProvider = "com.adobe.ag.export.file",
        LR_exportServiceProviderTitle = "Hard Drive",
        LR_export_colorSpace = "AdobeRGB",
        LR_export_destinationPathPrefix = prefix,
        LR_export_destinationPathSuffix = suffix,
        LR_export_destinationType = "specificFolder",
        LR_export_externalEditingApp = "/Applications/Adobe Lightroom Classic CC/Adobe Lightroom Classic CC.app",
        LR_export_postProcessing = "doNothing",
        LR_export_useSubfolder = true,
        LR_export_videoFileHandling = "include",
        LR_export_videoFormat = "4e49434b-4832-3634-fbfb-fbfbfbfbfbfb",
        LR_export_videoPreset = "original",
        LR_extensionCase = "lowercase",
        LR_format = "ORIGINAL",
        LR_includeFaceTagsAsKeywords = true,
        LR_includeFaceTagsInIptc = true,
        LR_includeVideoFiles = true,
        LR_initialSequenceNumber = 1,
        LR_jpeg_limitSize = 4800,
        LR_jpeg_useLimitSize = false,
        LR_metadata_keywordOptions = "flat",
        LR_outputSharpeningLevel = 2,
        LR_outputSharpeningMedia = "screen",
        LR_outputSharpeningOn = false,
        LR_reimportExportedPhoto = false,
        LR_reimport_stackWithOriginal = false,
        LR_reimport_stackWithOriginal_position = "below",
        LR_removeFaceMetadata = false,
        LR_removeLocationMetadata = false,
        LR_renamingTokensOn = true,
        LR_selectedTextFontFamily = "Myriad Web Pro",
        LR_selectedTextFontSize = 12,
        LR_size_doConstrain = constrain,
        LR_size_maxWidth = width,
        LR_size_maxHeight = height,
        LR_size_percentage = 100,
        LR_size_resizeType = resizeType,
        LR_size_resolution = resolution,
        LR_size_units = "inch",
        LR_size_resolutionUnits = "inch",
        LR_tokenCustomString = "Wes Mitchell",
        LR_tokens = "{{image_name}}",
        LR_tokensArchivedToString2 = "{{image_name}}",
        LR_useWatermark = false,
        LR_watermarking_id = "<simpleCopyrightWatermark>",
    }
    return exportSettings
end
return ExportSettings