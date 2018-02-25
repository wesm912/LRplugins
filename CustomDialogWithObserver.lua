--[[----------------------------------------------------------------------------

ADOBE SYSTEMS INCORPORATED
 Copyright 2007 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file in accordance
with the terms of the Adobe license agreement accompanying it. If you have received
this file from a source other than Adobe, then your use, modification, or distribution
of it requires the prior written permission of Adobe.

--------------------------------------------------------------------------------

CustomDialogWithObserver.lua
From the Hello World sample plug-in. Displays several custom dialog and writes debug info.

------------------------------------------------------------------------------]]
require 'CreateCollections'
require 'CreateGlobalCollections'

-- Access the Lightroom SDK namespaces.

local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrLogger = import 'LrLogger'
local LrColor = import 'LrColor'

-- Create the logger and enable the print function.

local myLogger = LrLogger( 'newProjectWorkflow' )
myLogger:enable( "logfile" ) -- Pass either a string or a table of actions.

-- Write trace information to the logger.

local function outputToLog( message )
	myLogger:trace( message )
end

--[[
	Demonstrates a custom dialog with a simple binding. The dialog has a text field
	that is used to update a value in an observable table.  The table has an observer
	attached that will be notified when a key value is updated.  The observer is
	only interested in the props.myObservedString.  When that value changes the
	observer will be notified.
]]
local function showCustomDialogWithObserver()

	LrFunctionContext.callWithContext( "showCustomDialogWithObserver", function( context )

		-- Create a bindable table.  Whenever a field in this table changes then notifications
		-- will be sent.  Note that we do NOT bind this to the UI.

		local props = LrBinding.makePropertyTable( context )
		props.myObservedString = ""
		props.actionEnabled = false

		local f = LrView.osFactory()

		-- Create the UI components like this so we can access the values as vars.

		local updateField = f:edit_field {
			immediate = true,
			bind_to_object = props,
			value = LrView.bind('myObservedString')
		}

		-- This is the function that will run when the value props.myString is changed.


		-- Create the contents for the dialog.

		local c = f:column {
			spacing = f:dialog_spacing(),

			f:row {
				f:static_text {
					alignment = "right",
					width = LrView.share "label_width",
					title = "New value: "
				},
				updateField,
			}, -- end row
		} -- end column

		local result = LrDialogs.presentModalDialog {
				title = "New Project Name",
				contents = c,
				-- actionBinding = {
				-- 	enabled = {
				-- 		bind_to_object = props,
				-- 		key = 'actionEnabled'
				-- 	}
				-- },
			}

		outputToLog(result)

		if ( result == 'ok') then
			LrDialogs.confirm("Include selected photos", nil, "OK","Cancel")
			-- CreateGlobalCollections:createGlobalWorkflow()
			-- outputToLog('Finished global collection set')
			outputToLog(updateField.value)
			CreateCollections.createWorkflow(updateField.value)
		end

	end) -- end main function


end

-- Now display the dialogs.

showCustomDialogWithObserver()
