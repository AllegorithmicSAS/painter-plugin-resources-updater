// Copyright (C) 2017 Allegorithmic
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

import QtQuick 2.7
import Painter 1.0

PainterPlugin
{
	tickIntervalMS: -1 // Disabled, no need for Tick
	jsonServerPort: -1 // Disabled, no need for JSON server

	property var minorVersion: "1.0.5"
	
	ResourceUpdaterWindow
	{
		id: window
	}
	
	Component.onCompleted:
	{
		if (minorVersion <= alg.version.api) {
			var qmlToolbar = alg.ui.addToolBarWidget( "toolbar.qml" )
			qmlToolbar.windowReference = window
		} else {
			alg.log.warn("Resource Updater Plugin need Substance Painter scripting API "+minorVersion+" or higher")
		}
	}
	
	onNewProjectCreated:
	{
		window.refreshInterface()
	}

	onProjectOpened:
	{
		window.refreshInterface()
	}
	
	onProjectAboutToClose:
	{
		window.refreshInterface()
	}
}
