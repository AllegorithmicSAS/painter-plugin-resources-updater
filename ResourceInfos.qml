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
	id: resourceInfos
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
		parent: resourceInfos.background
		anchors.fill: parent
		
		onClicked:
		{
			resourceInfos.close()
		}
	}
	
	Rectangle
	{
		anchors.centerIn: parent
		width: parent.width * 0.8
		height: infosList.height + Style.margin*2
		
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
			width: parent.width
			anchors {
				verticalCenter: parent.verticalCenter;
			}
			
			RowLayout
			{
				Layout.leftMargin: Style.margin
				Layout.rightMargin: Style.margin

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

	function getInfoAboutResource(url)
	{
		try
		{
			var resInfos = alg.resources.getResourceInfo(url)

			infoName.text = resInfos.name !== undefined ?
				resInfos.name :
				""
			infoType.text = resInfos.type !== undefined ?
				resInfos.type :
				""
			infoShelf.text = resInfos.shelfName !== undefined ?
				resInfos.shelfName :
				""
			infoShelfPath.text = resInfos.shelfPath !== undefined ?
				resInfos.shelfPath :
				""
			infoCategory.text = resInfos.category !== undefined ?
				resInfos.category :
				""
			infoTags.text = resInfos.tags !== undefined ?
				resInfos.tags.toString() :
				""
			infoUsages.text = resInfos.usages !== undefined ?
				resInfos.usages.toString() :
				""
			infoUrl.text = url
			
			thumbnail.source = "image://resources/" + url
			
			//Display popup
			resourceInfos.visible = true
		}
		catch(err)
		{
			alg.log.exception( err )
		}
	}
}