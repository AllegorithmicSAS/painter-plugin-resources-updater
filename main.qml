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

	property int majorVersionRequired: 2
	property int minorVersionRequired: 6
	
	ResourceUpdaterWindow
	{
		id: window
	}
	
	Component.onCompleted:
	{
		if (isPluginSuported()) {
			var qmlToolbar = alg.ui.addToolBarWidget( "toolbar.qml" )
			qmlToolbar.windowReference = window
			refresh()
		} else {
			alg.log.warn("Resource Updater Plugin need Substance Painter "+majorVersionRequired+"."+minorVersionRequired+" scripting API or higher")
		}
	}
	
	onNewProjectCreated:
	{
		refresh()
	}

	onProjectOpened:
	{
		refresh()
	}
	
	onProjectAboutToClose:
	{
		refresh()
	}

	function isPluginSuported() {
		var version = alg.version.painter.split(".")
		if (version[0] < majorVersionRequired || version[1] < minorVersionRequired) {
			return false
		}
		return true
	}

	function refresh() {
		if (isPluginSuported()) {
			window.refreshInterface()
		}
	}
}
