// Copyright (C) 2017 Allegorithmic
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import Painter 1.0
import AlgWidgets 1.0
import AlgWidgets.Style 1.0

PainterPlugin
{
	tickIntervalMS: -1 // Disabled, no need for Tick
	jsonServerPort: -1 // Disabled, no need for JSON server
	
	//Common colors
	property string colorNormal		: AlgStyle.background.color.normal
	property string colorLight 		: AlgStyle.background.color.light
	property string colorGray 		: AlgStyle.background.color.gray
	property string colorDark 		: AlgStyle.background.color.dark
	property string colorDarkGray 	: AlgStyle.background.color.dark
	property string colorOutdated 	: "#662222"
	
	AlgWindow
	{
		id: window
		title: "Substance Painter - Resources Updater"
		visible: false
		width: 750
		height: 500
		
		
		//Flags to keep the window on top
		flags: Qt.Window
			| Qt.WindowTitleHint // title
			| Qt.WindowSystemMenuHint // Recquired to add buttons
			| Qt.WindowMinMaxButtonsHint // minimize and maximize button
			| Qt.WindowCloseButtonHint // close button
			| Qt.WindowStaysOnTopHint;


		ColumnLayout
		{
			id: baseWindowLayout
			anchors.fill: parent
			anchors.margins: 4

			RowLayout
			{
				Layout.preferredWidth: baseWindowLayout.width
				
				AlgLabel
				{
					id: labelProjectName
					font.pixelSize: 14
					padding:8
					
					text: "Project : "
				}
				
				Item
				{
					Layout.fillWidth:true
				}
				
				AlgCheckBox
				{
					text:"Keep window on top"
					Layout.preferredHeight:20
					Layout.preferredWidth:135
					checked:true
					
					onClicked:
					{
						updateWindowFlags()
					}
					
					Component.onCompleted:
					{
						updateWindowFlags()
					}
					
					function updateWindowFlags()
					{
						var CommonFlags = Qt.Window
										| Qt.WindowTitleHint // title
										| Qt.WindowSystemMenuHint // Recquired to add buttons
										| Qt.WindowMinMaxButtonsHint // minimize and maximize button
										| Qt.WindowCloseButtonHint; // close button
						
						if( checked )
						{
							window.flags = CommonFlags | Qt.WindowStaysOnTopHint;
						}
						else
						{
							window.flags = CommonFlags
						}
					}
				}
			}
			
			
			
			Rectangle
			{
				id: rectangleFiltering
				Layout.preferredWidth: baseWindowLayout.width
				height:30
				
				color: colorGray
				border.color: colorLight
				border.width: 2
				radius: 3
				
				RowLayout
				{
					width: parent.width
					anchors { 	horizontalCenter: parent.horizontalCenter;
								top: parent.top;
								topMargin: 3;
							}
					
					AlgLabel
					{
						Layout.leftMargin: 6
						Layout.preferredHeight: 14
						text: "Status : "
						verticalAlignment: Text.AlignVCenter
					}
					
					AlgComboBox
					{
						id: dropdownDisplayMode
						Layout.preferredWidth: 120
						Layout.preferredHeight: 20
						Layout.rightMargin:10
						model: ["All", "Outdated", "Non-Outdated"]
					}
					
					
					AlgLabel
					{
						Layout.leftMargin: 6
						Layout.preferredHeight: 14
						text: "Name filter : "
						verticalAlignment: Text.AlignVCenter
					}
					
					AlgTextInput
					{
						id: textFilter
						Layout.preferredWidth: 128
						text:""
					}
					
					AlgToolButton
					{
						iconName: AlgStyle.icons.datawidget.remove
						visible: textFilter.text !== ""
						
						onClicked:
						{
							textFilter.text = ""
						}
					}
					
					Item
					{
						Layout.fillWidth:true
					}
					
					AlgButton
					{
						text: "Top"
						Layout.preferredWidth:60
						Layout.preferredHeight: 20
						
						onClicked:
						{
							window.scrollResourceListToTop()
						}
					}
					
					AlgButton
					{
						text: "Bottom"
						Layout.preferredWidth:60
						Layout.rightMargin: 6
						Layout.preferredHeight: 20
						
						onClicked:
						{
							window.scrollResourceListToBottom()
						}
					}
				}
			}


		
			AlgScrollView
			{
				id: scrollViewResource
				maximumFlickVelocity : 1000
				height:scrollViewResource.viewportHeight
				Layout.preferredWidth: parent.width
				Layout.fillHeight: true
				
				ListView
				{
					property int backgroundMargin : 8
					
					id: resourceListBase
					leftMargin: 	backgroundMargin
					bottomMargin: 	backgroundMargin
					rightMargin: 	backgroundMargin
					topMargin: 		backgroundMargin
					Layout.minimumHeight: contentHeight + (backgroundMargin * 2)
					
					model: ListModel
					{
						id:resourceList
					}
					
					Rectangle
					{
						color: colorDarkGray
						border.color: colorDark
						border.width: 1
						radius: 3
						width:scrollViewResource.viewportWidth
						height:resourceListBase.contentHeight + (resourceListBase.backgroundMargin * 2)
						z: resourceListBase.z - 1
					}
					
					delegate: Rectangle
					{
						visible: window.resourceCanBeVisible( outdated, name )
												
						width: scrollViewResource.viewportWidth - (resourceListBase.backgroundMargin * 2)
						height: visible ? 80 : 0
						
						radius: 3
						color: bgColor
						border.color: colorDark
						border.width: 1
						
						RowLayout
						{
							id: layoutLine
							anchors.fill: parent

							anchors.leftMargin: 10
							anchors.rightMargin: 10
							
							ColumnLayout
							{
								Image
								{
									source: image
									fillMode: Image.PreserveAspectFit
									Layout.preferredHeight: 24
									Layout.preferredWidth: 24
									mipmap:true
								}
								
								AlgButton
								{
									text: "?"
									Layout.preferredHeight: 20
									Layout.preferredWidth: 20
									Layout.leftMargin: 2
									
									onClicked:
									{
										window.getInfoAboutResource( url, version )
									}
								}
							}
							
							AlgLabel
							{
								text: number
								horizontalAlignment: Text.AlignRight
								Layout.rightMargin: 6
								Layout.preferredWidth: 20
							}
							
							GridLayout
							{
								columns:2
								
								AlgLabel
								{
									text: "Name : "
									verticalAlignment: Text.AlignVCenter
								}
								
								AlgLabel
								{
									text:name
									Layout.fillWidth: true
									verticalAlignment: Text.AlignVCenter
									horizontalAlignment: Text.AlignLeft
									elide: Text.ElideRight
								}
								
								AlgLabel
								{
									text: "URL : "
									verticalAlignment: Text.AlignVCenter
								}
								
								AlgLabel
								{
									text:url
									Layout.fillWidth: true
									verticalAlignment: Text.AlignVCenter
									horizontalAlignment: Text.AlignLeft
									elide: Text.ElideRight
								}
								
								AlgLabel
								{
									text:version
									visible:false
								}
							}

							ColumnLayout
							{
								AlgResourceWidget
								{
									id: ressourceWidget
									filters:filtering
									defaultLabel: "Select new resource"
									Layout.preferredWidth: 200
									Layout.preferredHeight: 36
									
									Component.onCompleted:
									{
										if( outdated )
										{
											requestUrl( newUrl )
										}
									}
									
									onUrlChanged:
									{
										newUrl = url
									}
								}
								
								AlgButton
								{
									Layout.preferredWidth: 200
									text:"Update"
									enabled: ressourceWidget.url !== ""
									
									Rectangle
									{
										width:parent.width
										height:parent.height
										visible: !(ressourceWidget.url !== "")
										radius: 3
										color: colorDark
										opacity: 0.5
									}
									
									onClicked:
									{
										window.updateResource( name, url, version, ressourceWidget.url )
										window.listOutdatedResources()
									}
								}
							}
						} //End RowLayout
					}
				} //End ListView
			} //End ScrollView
			
			
			
			Rectangle
			{
				property int bottomMargin : 8
				
				color: colorGray
				Layout.preferredWidth: parent.width
				height:bottomLayout.height + (bottomMargin * 2)
				
				RowLayout
				{
					id: bottomLayout
					anchors.left:parent.left
					anchors.right:parent.right
					anchors.top:parent.top
					anchors.leftMargin: parent.bottomMargin
					anchors.rightMargin: parent.bottomMargin
					anchors.topMargin: parent.bottomMargin
					
					AlgButton
					{
						id: buttonRefreshList
						Layout.preferredHeight: 24
						text: "Refresh"
						
						onClicked:
						{
							window.listOutdatedResources()
						}
					}
					
					AlgLabel
					{
						id: labelProjectResourcesCount
						Layout.preferredHeight: 16
						Layout.fillWidth:true
						Layout.rightMargin:10
						text: "(0 resources, 0 outdated)"
						opacity: 0.75
					}
					
					
					AlgButton
					{
						id: buttonUpdateAll
						Layout.preferredHeight: 24
						text: "Update All"
						
						onClicked:
						{
							window.updateAllResources()
						}
					}
				}
			}
		}
		
		
		
		AlgPopup
		{
			id: popupResourceInfo
			width: parent.width
			height:scrollViewResource.viewportHeight
			parent: scrollViewResource
			visible:false
			
			Component.onCompleted:
			{
				background.color = colorDark
				background.opacity = 0.8
			}
			
			//Allow to close the popup when clicking outside the
			//rectangle displaying the resource information.
			MouseArea
			{
				parent: popupResourceInfo.background
				anchors.fill: parent
				
				onClicked:
				{
					popupResourceInfo.close()
				}
			}
			
			Rectangle
			{
				id: popupLayoutBase
				
				property int popupMargin : 8
				
				anchors.centerIn:parent
				width:parent.width * 0.8
				height: popupLayout.height + 16
				
				border.color: colorLight
				border.width: 2
				color: colorGray
				radius: 3
				
				//Foreground steal mouse event from the background.
				MouseArea
				{
					anchors.fill: parent
				}
				
				ColumnLayout
				{
					width:parent.width
					
					RowLayout
					{
						Layout.fillWidth:true
						anchors.top:parent.top
						anchors.left:parent.left
						anchors.right:parent.right
						anchors.margins: popupLayoutBase.popupMargin
						
						spacing: popupLayoutBase.popupMargin
						
						Image
						{
							id: popupThumbnail
							source: ""
							fillMode: Image.PreserveAspectFit
							mipmap:true
							Layout.preferredHeight: popupLayout.height
							Layout.preferredWidth: popupLayout.height
							sourceSize.width: 512
							sourceSize.height: 512
						}
						
						GridLayout
						{
							columns:2
							id: popupLayout
							Layout.rightMargin: popupLayoutBase.popupMargin * 2
							
							//---------------------------------
							// Name
							//---------------------------------
							AlgLabel
							{
								text: "Name : "
								verticalAlignment: Text.AlignVCenter
								opacity: popupName.text == "" ? 0.5 : 1.0
							}
							
							AlgLabel
							{
								id: popupName
								text: "None"
								Layout.fillWidth: true
								verticalAlignment: Text.AlignVCenter
								horizontalAlignment: Text.AlignLeft
								elide: Text.ElideRight
							}
							
							
							//---------------------------------
							// Type
							//---------------------------------
							AlgLabel
							{
								text: "Type : "
								verticalAlignment: Text.AlignVCenter
								opacity: popupType.text == "" ? 0.5 : 1.0
							}
							
							AlgLabel
							{
								id: popupType
								text: "None"
								Layout.fillWidth: true
								verticalAlignment: Text.AlignVCenter
								horizontalAlignment: Text.AlignLeft
								elide: Text.ElideRight
							}
							
							
							//---------------------------------
							// Shelf name
							//---------------------------------
							AlgLabel
							{
								text: "Shelf : "
								verticalAlignment: Text.AlignVCenter
								opacity: popupShelf.text == "" ? 0.5 : 1.0
							}
							
							AlgLabel
							{
								id: popupShelf
								text: "None"
								Layout.fillWidth: true
								verticalAlignment: Text.AlignVCenter
								horizontalAlignment: Text.AlignLeft
								elide: Text.ElideRight
							}
							
							
							//---------------------------------
							// Location
							//---------------------------------
							AlgLabel
							{
								text: "Path : "
								verticalAlignment: Text.AlignVCenter
								opacity: popupShelfPath.text == "" ? 0.5 : 1.0
							}
							
							AlgLabel
							{
								id: popupShelfPath
								text: "None"
								Layout.fillWidth: true
								verticalAlignment: Text.AlignVCenter
								horizontalAlignment: Text.AlignLeft
								elide: Text.ElideRight
							}
							
							
							//---------------------------------
							// Category
							//---------------------------------
							AlgLabel
							{
								text: "Category : "
								verticalAlignment: Text.AlignVCenter
								opacity: popupCategory.text == "" ? 0.5 : 1.0
							}
							
							AlgLabel
							{
								id: popupCategory
								text: "None"
								Layout.fillWidth: true
								verticalAlignment: Text.AlignVCenter
								horizontalAlignment: Text.AlignLeft
								elide: Text.ElideRight
							}
							
							
							//---------------------------------
							// Tags
							//---------------------------------
							AlgLabel
							{
								text: "Tags : "
								verticalAlignment: Text.AlignVCenter
								opacity: popupTags.text == "" ? 0.5 : 1.0
							}
							
							AlgLabel
							{
								id: popupTags
								text: "None"
								Layout.fillWidth: true
								verticalAlignment: Text.AlignVCenter
								horizontalAlignment: Text.AlignLeft
								elide: Text.ElideRight
							}
							
							
							//---------------------------------
							// Tags
							//---------------------------------
							AlgLabel
							{
								text: "Usages : "
								verticalAlignment: Text.AlignVCenter
								opacity: popupUsage.text == "" ? 0.5 : 1.0
							}
							
							AlgLabel
							{
								id: popupUsage
								text: "None"
								Layout.fillWidth: true
								verticalAlignment: Text.AlignVCenter
								horizontalAlignment: Text.AlignLeft
								elide: Text.ElideRight
							}
							
							
							//---------------------------------
							// URL
							//---------------------------------
							AlgLabel
							{
								text: "Full URL : "
								verticalAlignment: Text.AlignVCenter
								opacity: popupVersion.text == "" ? 0.5 : 1.0
							}
							
							AlgLabel
							{
								id: popupVersion
								text: "None"
								Layout.fillWidth: true
								verticalAlignment: Text.AlignVCenter
								horizontalAlignment: Text.AlignLeft
								elide: Text.ElideRight
							}
						}
						
					} //RowLayout
					
					AlgButton
					{
						Layout.alignment: Qt.AlignRight
						Layout.topMargin : 16
						Layout.preferredWidth: 60
						text:"Close"
						
						onClicked:
						{
							popupResourceInfo.visible = false
						}
					}
				} //ColumnLayout
			} //Rectangle
		}
		


		function resourceCanBeVisible( IsOudated, TextToMatch )
		{
			try
			{
				//Display mode
				var displayMode = dropdownDisplayMode.currentText === "All"
				|| ( IsOudated && dropdownDisplayMode.currentText === "Outdated" )
				|| ( !IsOudated && dropdownDisplayMode.currentText === "Non-Outdated" );
				
				//Name filtering
				var regexp = new RegExp( textFilter.text , "i" )
				var filterName = TextToMatch.match( regexp  ) || textFilter.text === ""
				
				return displayMode && filterName
			}
			catch(err)
			{
				alg.log.exception( err )
			}
		}
		
		
		
		function listOutdatedResources()
		{
			try
			{
				if( !alg.project.isOpen() )
				{
					alg.log.info( "No project open, resources updater discarded" )
					return
				}
					
				
				//---------------------------------------
				// List resources
				//---------------------------------------
				var AllResources 		= alg.resources.findResources("*", "*")
				var DocumentResources 	= alg.resources.documentResources()
				var OutdatedCounter 	= 0
				var PossibleFilter		= 0

				//Reset UI list before adding the resources found
				resourceList.clear()
				
				
				//Iterate over available ressources in current document
				for( var i = 0; i < DocumentResources.length; i++ )
				{
					var BackgroundColor = (colorNormal).toString()
					var ResourceName 	= DocumentResources[i].name
					var ResourceURL 	= DocumentResources[i].url
					var ResourceVersion	= DocumentResources[i].version
					var ResourceType	= DocumentResources[i].version.split(".").pop()
					var IconURL 		= ""
					
					var IsOutdated 		= false
					var NewShelfURL 	= ""
					
					
					//Update resource icon
					if( ResourceType === "image" )
					{
						IconURL = "file:///" + alg.plugin_root_directory + "icon_bitmap.png"
						PossibleFilter = AlgResourcePicker.TEXTURE
										| AlgResourcePicker.MASK
										| AlgResourcePicker.PROCEDURAL;
					}
					else if( ResourceType === "pkfx" )
					{
						IconURL = "file:///" + alg.plugin_root_directory + "icon_particle.png"
						PossibleFilter = AlgResourcePicker.EMITTER
										| AlgResourcePicker.RECEIVER;
					}
					else //substance
					{
						IconURL = "file:///" + alg.plugin_root_directory + "icon_substance.png"
						PossibleFilter = AlgResourcePicker.FILTER
										| AlgResourcePicker.MATERIAL
										| AlgResourcePicker.GENERATOR
										| AlgResourcePicker.MASK
										| AlgResourcePicker.PROCEDURAL;
					}
					
					
					//Check if resource is outdated
					for( var j = 0; j < AllResources.length; j++ )
					{
						var ResourceShelfName 		= AllResources[j].name
						var ResourceShelfVersion 	= AllResources[j].version
						var ResourceShelfURL 		= AllResources[j].url
						
						if( ResourceShelfName === ResourceName
						&& ResourceShelfVersion != ResourceVersion )
						{
							BackgroundColor = colorOutdated
							OutdatedCounter += 1
							IsOutdated 		= true
							NewShelfURL 	= ResourceShelfURL
						}
					}

					ResourceURL = ResourceURL.split("?")[0]

					//Update resource in the list
					resourceList.append(
						{
							name		: ResourceName,
							number		: i + 1,
							image		: IconURL,
							url			: ResourceURL,
							newUrl		: NewShelfURL,
							version		: ResourceVersion,
							bgColor 	: BackgroundColor,
							filtering 	: PossibleFilter,
							outdated 	: IsOutdated
						} )
				}

				
				//---------------------------------------
				// Update UI
				//---------------------------------------
				labelProjectName.text 			= "Project : " + alg.project.name()
				labelProjectResourcesCount.text = "(" +  DocumentResources.length + " resources, " + OutdatedCounter.toString() + " outdated)"
			}
			catch(err)
			{
				alg.log.warn( err.msg )
			}
		}
				
		
		
		function updateResource( OrignalName, OriginalURL, OriginalVersion, NewURL )
		{
			try
			{
				var OldURL = OriginalURL + "?version=" + OriginalVersion
				
				if( alg.resources.updateDocumentResources( OldURL, NewURL ) )
				{
					alg.log.info( "Resource \"" + OrignalName + "\" has been updated" )
				}
			}
			catch(err)
			{
				alg.log.exception( err )
			}
		}
		
		
		
		function updateAllResources()
		{
			try
			{
				for( var i = 0; i < resourceList.count; i++ )
				{
					var Name 	= resourceList.get(i).name
					var OldURL 	= resourceList.get(i).url
					var Version = resourceList.get(i).version
					var NewURL 	= resourceList.get(i).newUrl
					
					//Only update resource where hte user provided a new asset
					//in the interface
					if( NewURL !== "" )
					{
						window.updateResource( Name, OldURL, Version, NewURL )
					}
				}
				
				window.refreshInterface()
			}
			catch(err)
			{
				alg.log.exception( err )
			}
		}
		
		
		
		function getInfoAboutResource( URL, version )
		{
			try
			{
				//Retrieve information
				var ResUrl 		= URL + "?version=" + version
				var ResInfo 	= {}
				
				//Update popup
				popupName.text 		= ""
				popupType.text 		= ""
				popupShelf.text 	= ""
				popupShelfPath.text = ""
				popupTags.text 		= ""
				popupCategory.text 	= ""
				popupUsage.text 	= ""
				popupVersion.text 	= ResUrl
				
				//Try to get resource info.
				//If object doesn't exist we fail with a warning and keep interface empty.
				try
				{
					ResInfo = alg.resources.getResourceInfo( ResUrl )
				}
				catch(err)
				{
					alg.log.warn( err.message )
				}
				finally
				{
					if( !(ResInfo.guiName === undefined) )
					popupName.text = ResInfo.guiName
					
					if( !(ResInfo.type === undefined) )
					popupType.text = ResInfo.type
					
					if( !(ResInfo.shelfName === undefined) )
					popupShelf.text = ResInfo.shelfName
					
					if( !(ResInfo.shelfPath === undefined) )
					popupShelfPath.text = ResInfo.shelfPath
					
					if( !(ResInfo.tags === undefined) )
					popupTags.text = ResInfo.tags.toString()
					
					if( !(ResInfo.category === undefined) )
					popupCategory.text = ResInfo.category
					
					if( !(ResInfo.usage === undefined) )
					popupUsage.text = ResInfo.usage.toString()
				}
				
				//Update Thumbnail
				popupThumbnail.source = "image://resources/" + URL
				
				//Display popup
				popupResourceInfo.visible = true
			}
			catch(err)
			{
				alg.log.exception( err )
			}
		}
		
		
		
		function scrollResourceListToTop()
		{
			scrollViewResource.contentY = 0
		}
		
		
		
		function scrollResourceListToBottom()
		{
			scrollViewResource.contentY = scrollViewResource.contentHeight
		}
		
		
		
		function hidePopup()
		{
			popupResourceInfo.visible = false
		}
		
		
		function refreshInterface()
		{
			try
			{
				//Clear project name
				labelProjectName.text = "Project : "
				
				hidePopup()
				
				listOutdatedResources()
				
				scrollResourceListToTop()
			}
			catch(err)
			{
				alg.log.exception( err )
			}
		}
	} //end AlgWindow
	
	Component.onCompleted:
	{
		var qmlToolbar = alg.ui.addToolBarWidget( "toolbar.qml" )
		qmlToolbar.windowReference = window
		
		window.refreshInterface()
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
