--[[----------------------------------------------------------------------------

DisplayMetadata.lua
Summary information for custom metadata dialog sample plugin

--------------------------------------------------------------------------------

ADOBE SYSTEMS INCORPORATED
 Copyright 2008 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file in accordance
with the terms of the Adobe license agreement accompanying it. If you have received
this file from a source other than Adobe, then your use, modification, or distribution
of it requires the prior written permission of Adobe.

------------------------------------------------------------------------------]]

--[[
	Syncs the private metadata with any changes made to public metadata for certain fields:
		Title
		Caption
		Genre
]]
local LrLogger = import 'LrLogger'

local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local catalog = LrApplication.activeCatalog()
local logger = LrLogger('newProjectWorkflow' )
logger:enable( "logfile" )

CMMenuItem = {}


function CMMenuItem.syncMetaData()

	local titleCount = 0
	local genreCount = 0
	local captionCount = 0
	local result = catalog:withWriteAccessDo("CreateCollectionSets",
		function( context )
			-- Get a reference to the photos within the current catalog.
			local photos = catalog:getTargetPhotos()
			for _, photo in ipairs( photos ) do


				-- Title
				local title = photo:getFormattedMetadata('title')
				if title and title:len() > 0 and title ~= 'No Title' then
					photo:setPropertyForPlugin(_PLUGIN, 'title', title)
					titleCount = titleCount + 1
				end


				-- genre
				local genre = photo:getFormattedMetadata('intellectualGenre')
				if genre and genre:len() > 0 and genre ~= 'No Genre' then
					photo:setPropertyForPlugin(_PLUGIN, 'intellectualGenre', genre)
					genreCount = genreCount + 1
				end


				-- caption
				local caption = photo:getFormattedMetadata('caption')
				if caption and caption:len() > 0 and caption ~= 'No Caption' then
					photo:setPropertyForPlugin(_PLUGIN, 'caption', caption)
					captionCount = captionCount + 1
				end -- if
				local state = photo:getPropertyForPlugin(_PLUGIN, 'workflowState') or "nil"
				logger:trace("Got state " .. state .. " for photo " .. photo:getFormattedMetadata('fileName'))
			end -- for
		end -- function
	) -- withWriteAccessDo

	CMMenuItem.showModalDialog( titleCount, genreCount, captionCount )
end

-- Now display a dialog with the new file entries.

function CMMenuItem.showModalDialog( t, g, c )
	local message = "Synchronized " .. t .. " titles, " .. g .. " genres, and " .. c .." captions"

	LrDialogs.message( "Custom Metadata Dialog", message, "info" )
end

import 'LrTasks'.startAsyncTask( CMMenuItem.syncMetaData )
