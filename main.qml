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
	
	ResourceUpdaterWindow
	{
		id: window
	}
	
	Component.onCompleted:
	{
		var qmlToolbar = alg.ui.addWidgetToPluginToolBar( "toolbar.qml" )
		qmlToolbar.windowReference = window
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
