// Copyright (C) 2017 Allegorithmic
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import AlgWidgets 1.0
import AlgWidgets.Style 1.0
import "."

Rectangle
{
	id: resourcesListView
	Layout.fillHeight: true
	Layout.fillWidth: true
	Layout.leftMargin: 4
	Layout.rightMargin: 4

	color: AlgStyle.background.color.darkGray //#252525

	property int filter_ALL: 0
	property int filter_OUTDATED: 1
	property int filter_NO_OUTDATED: 2
	property var current_filter: filter_ALL

	property string filter_text: ""

	AlgScrollView
	{
		id: scrollArea
		anchors.fill: parent
		anchors.margins: 4
		maximumFlickVelocity : 1500
		contentHeight: content.contentHeight
		
		ListView
		{
			id: content
			Layout.minimumHeight: contentHeight

			model: ListModel
			{
				id: resourcesList
			}

			delegate: Rectangle
			{
				visible: isResourceVisible(outdated, name)
				width: scrollArea.viewportWidth
				height: visible ? Style.widgets.resourceItemHeight : 0
				
				radius: Style.radius
				color: outdated ? "#662222" : AlgStyle.background.color.normal
				border.color: AlgStyle.background.color.dark //#1E1E1E
				
				RowLayout
				{
					anchors.fill: parent

					height: Style.widgets.resourceItemHeight

					anchors.leftMargin: Style.margin
					anchors.rightMargin: Style.margin
					
					Image
					{
						source: "image://resources/" + url
						fillMode: Image.PreserveAspectFit
						mipmap:true
						anchors.top: parent.top
						anchors.bottom: parent.bottom
						anchors.margins: Style.margin
						Layout.preferredWidth: height

						MouseArea {
							anchors.fill: parent
							hoverEnabled: true
							cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
							
							Rectangle
							{
								anchors.fill: parent
								visible: parent.containsMouse
								color: "#FFFFFF"
								opacity: 0.2
							}

							onClicked:
							{
								resourceInfo.getInfoAboutResource(url)
							}
						}

						
					}
					
					AlgLabel
					{
						text: number
						horizontalAlignment: Text.AlignRight
						Layout.rightMargin: Style.margin
						Layout.preferredWidth: 20
					}
					
					GridLayout
					{
						columns: 2
						
						AlgLabel
						{
							text: "Name : "
							verticalAlignment: Text.AlignVCenter
						}
						
						AlgLabel
						{
							text: name
							Layout.fillWidth: true
							verticalAlignment: Text.AlignVCenter
							horizontalAlignment: Text.AlignLeft
							elide: Text.ElideRight
						}
						
						AlgLabel
						{
							text: "Shelf : "
							verticalAlignment: Text.AlignVCenter
						}
						
						AlgLabel
						{
							text: shelfName
							Layout.fillWidth: true
							verticalAlignment: Text.AlignVCenter
							horizontalAlignment: Text.AlignLeft
							elide: Text.ElideRight
						}
					}

					ColumnLayout
					{
						AlgResourceWidget
						{
							id: resourcePicker
							refineQuery: queryFilter
							defaultLabel: "Select new resource"
							Layout.preferredWidth: Style.widgets.buttonWidth*2
							Layout.preferredHeight: 40
							
							Component.onCompleted:
							{
								if(outdated)
								{
									requestUrl(newUrl)
								}
							}
							
							onUrlChanged:
							{
								newUrl = url
							}
						}
						
						AlgButton
						{
							Layout.preferredWidth: Style.widgets.buttonWidth*2
							text: "Update"
							enabled: resourcePicker.url !== ""

							onClicked:
							{
								updateResource()
							}
						}
					}
				}

				function updateResource() {
					try {
						if (!visible || newUrl === "") {
							return false
						}
						if(alg.resources.updateDocumentResources(url, newUrl)) {
							alg.log.info("Resource \"" + name + "\" has been updated")
							url = newUrl
							resourcePicker.requestUrl("")
							outdated = false
							var resInfo = alg.resources.getResourceInfo(url)
							name = resInfo.name
							shelfName = resInfo.shelfName
							queryFilter = resourcesListView.createQuery(resInfo.type, resInfo.usages)
							return true
						}
						return false
					} catch(err) {
						alg.log.exception(err)
					}
				}

			}
		}
	}

	ResourceInfo
	{
		id: resourceInfo
	}


	function updateAllResources() {
		try {
			content.currentIndex = 0
			for(var i = 0; i < content.count; i++) {
				content.currentItem.updateResource()
				content.incrementCurrentIndex()
			}
		} catch(err) {
			alg.log.warn(err.message)
		}
	}
	
	//Try to find a updated resource in the shelf
	//Return empty if the resource isn't outdate
	function findResourceUrlOnShelf(resourceInfo) {
		var regexp = new RegExp(resourceInfo.name , "i")
		var shelfResources = alg.resources.findResources("*", regexp)
		for( var i = 0; i < shelfResources.length; i++ ) {
			var shelfResourceInfo = alg.resources.getResourceInfo(shelfResources[i])
			if(shelfResourceInfo.name === resourceInfo.name
				&& shelfResourceInfo.version != resourceInfo.version) {
				return shelfResources[i]
			}
		}
		return ""
	}

	//Create a query for the picker resource
	function createQuery(resourceType, resourceUsages) {
		if(resourceType === "image") {
			return "u:" + resourceType
		} else if(resourceType === "pkfx" || resourceType === "script") {
			return "u:" + resourceUsages
		} else { //substance
			if (resourceUsages === undefined || resourceUsages.length > 1) {
				return "u:substance"
			}
			return "u:substance " + resourceUsages[0]
		}
	}

	//Check if the resource must be show according to the state filter and text filter
	function isResourceVisible(isOutdated, resourceName) {
		var displayMode = current_filter === filter_ALL
			|| (isOutdated && current_filter === filter_OUTDATED)
			|| (!isOutdated && current_filter === filter_NO_OUTDATED);
		
		var regexp = new RegExp(filter_text, "i")
		var nameMatch = filter_text === "" || resourceName.match(regexp)

		return displayMode && nameMatch
	}

	// Create the model list to show
	function updateResourcesList() {
		try {
			if(!alg.project.isOpen()) {
				alg.log.info("No project open, resources updater discarded")
				return
			}

			//Get all document resources
			var documentResources = alg.resources.documentResources()
			//Sort them by name
			documentResources.sort(function(urlA, urlB) {
				// A url use this format : resource://shelf/name?version=xxxxxx
				// the third splited value is the name
				var nameA = urlA.split("/")[3]
				var nameB = urlB.split("/")[3]
				if (nameA.toUpperCase() <= nameB.toUpperCase()) {
					return -1;
				}
				return 1;
			});

			//Reset UI list before adding the resources found
			resourcesList.clear()

			var nbOutdatedResources = 0

			for( var i = 0; i < documentResources.length; i++ ) {
				//Get resource infos for the current resource
				var resourceInfo = alg.resources.getResourceInfo(documentResources[i])
				//Try to find a updated resource in the shelf
				var shelfResourceUrl = findResourceUrlOnShelf(resourceInfo)

				var isOutdated = shelfResourceUrl === "" ? false : true

				if (isOutdated) {
					++nbOutdatedResources
				}

				var query = createQuery(resourceInfo.type, resourceInfo.usages)
				var resource = {
					name            : resourceInfo.name,
					shelfName       : resourceInfo.shelfName,
					number          : i + 1,
					url             : resourceInfo.url,
					newUrl          : "",
					queryFilter     : query,
					outdated        : isOutdated
				}

				if (isOutdated) {
					// Add the outdated resource in the list
					resource.newUrl = shelfResourceUrl
				}

				//Add the resource to the list
				resourcesList.append(resource)
			}

			
			//---------------------------------------
			// Update UI
			//---------------------------------------
			projectName.text = "Project : " + alg.project.name()
			infoResourcesCount.text = "(" +  documentResources.length + " resources, " + nbOutdatedResources.toString() + " outdated)"
		} catch(err) {
			alg.log.warn(err.message)
		}
	}

	function scrollResourcesListToTop() {
		scrollArea.contentY = 0
	}
	
	function scrollResourcesListToBottom() {
		scrollArea.contentY = scrollArea.contentHeight
	}

}