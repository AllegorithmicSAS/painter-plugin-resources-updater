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

AlgPopup
{
	id: resourceInfo
	width: parent.width
	height: scrollArea.viewportHeight
	parent: scrollArea
	visible:false
	
	Component.onCompleted:
	{
		background.color = AlgStyle.background.color.dark //#1E1E1E
		background.opacity = 0.8
	}
	
	//Allow to close the popup when clicking outside the
	//rectangle displaying the resource information.
	MouseArea
	{
		parent: resourceInfo.background
		anchors.fill: parent
		
		onClicked:
		{
			resourceInfo.close()
		}
	}
	
	Rectangle
	{
		anchors.centerIn: parent
		width: parent.width * 0.8
		height: content.height
		
		border.color: AlgStyle.background.color.light //#494949
		border.width: Style.borderWidth
		radius: Style.radius

		color: AlgStyle.background.color.gray //#3C3C3C

		MouseArea
		{
			anchors.fill: parent
		}

		ColumnLayout
		{
			id: content
			width: parent.width
			anchors {
				verticalCenter: parent.verticalCenter;
			}
			
			RowLayout
			{
				Layout.margins: Style.margin

				Image
				{
					id: thumbnail
					source: ""
					fillMode: Image.PreserveAspectFit
					mipmap: true
					Layout.preferredHeight: infosList.height
					Layout.preferredWidth: infosList.height
					sourceSize.width: 512
					sourceSize.height: 512
				}
				
				GridLayout
				{
					columns: 2
					id: infosList
					
					//---------------------------------
					// Name
					//---------------------------------
					AlgLabel
					{
						text: "Name : "
						enabled: infoName.text !== ""
					}
					
					AlgLabel
					{
						id: infoName
						text: ""
						Layout.fillWidth: true
						elide: Text.ElideRight
					}
					
					
					//---------------------------------
					// Type
					//---------------------------------
					AlgLabel
					{
						text: "Type : "
						enabled: infoType.text !== ""
					}
					
					AlgLabel
					{
						id: infoType
						text: ""
						Layout.fillWidth: true
						elide: Text.ElideRight
					}
					
					
					//---------------------------------
					// Shelf name
					//---------------------------------
					AlgLabel
					{
						text: "Shelf : "
						enabled: infoShelf.text !== ""
					}
					
					AlgLabel
					{
						id: infoShelf
						text: ""
						Layout.fillWidth: true
						elide: Text.ElideRight
					}
					
					
					//---------------------------------
					// Location
					//---------------------------------
					AlgLabel
					{
						text: "Path : "
						enabled: infoShelfPath.text !== ""
					}
					
					AlgLabel
					{
						id: infoShelfPath
						text: ""
						Layout.fillWidth: true
						elide: Text.ElideRight
					}
					
					
					//---------------------------------
					// Category
					//---------------------------------
					AlgLabel
					{
						text: "Category : "
						enabled: infoCategory.text !== ""
					}
					
					AlgLabel
					{
						id: infoCategory
						text: ""
						Layout.fillWidth: true
						elide: Text.ElideRight
					}
					
					
					//---------------------------------
					// Tags
					//---------------------------------
					AlgLabel
					{
						text: "Tags : "
						enabled: infoTags.text !== ""
					}
					
					AlgLabel
					{
						id: infoTags
						text: ""
						Layout.fillWidth: true
						elide: Text.ElideRight
					}
					
					
					//---------------------------------
					// Usages
					//---------------------------------
					AlgLabel
					{
						text: "Usages : "
						enabled: infoUsages.text !== ""
					}
					
					AlgLabel
					{
						id: infoUsages
						text: ""
						Layout.fillWidth: true
						elide: Text.ElideRight
					}
					
					
					//---------------------------------
					// URL
					//---------------------------------
					AlgLabel
					{
						text: "Full URL : "
						enabled: infoUrl.text !== ""
					}
					
					AlgLabel
					{
						id: infoUrl
						text: ""
						Layout.fillWidth: true
						elide: Text.ElideRight
					}
				}
				
			}
		}
	}

	function getInfoAboutResource(url) {
		try {
			var resInfo = alg.resources.getResourceInfo(url)

			infoName.text = resInfo.name !== undefined ?
				resInfo.name :
				""
			infoType.text = resInfo.type !== undefined ?
				resInfo.type :
				""
			infoShelf.text = resInfo.shelfName !== undefined ?
				resInfo.shelfName :
				""
			infoShelfPath.text = resInfo.shelfPath !== undefined ?
				resInfo.shelfPath :
				""
			infoCategory.text = resInfo.category !== undefined ?
				resInfo.category :
				""
			infoTags.text = resInfo.tags !== undefined ?
				resInfo.tags.toString() :
				""
			infoUsages.text = resInfo.usages !== undefined ?
				resInfo.usages.toString() :
				""
			infoUrl.text = url
			
			thumbnail.source = "image://resources/" + url
			
			//Display popup
			resourceInfo.visible = true
		} catch(err) {
			alg.log.exception(err)
		}
	}
}