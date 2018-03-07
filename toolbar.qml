import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import AlgWidgets 1.0
import AlgWidgets.Style 1.0

Button
{
	id: rect
	antialiasing: true
	width: 32
	height: 32
	hoverEnabled: true

	property var windowReference : null

	background: Rectangle {
		anchors.fill: rect
	    color: rect.hovered ?
	      "#262626" :
	      "transparent"
	}

	Image
	{
		anchors.fill: parent
		anchors.margins: 8
		source: "ressources_updater.svg"
		fillMode: Image.PreserveAspectFit
		sourceSize.width: width
		sourceSize.height: height
		mipmap: true
	}
	
	onClicked:
	{
		try
		{
			windowReference.visible = true
			windowReference.refreshInterface()
			windowReference.raise()
			windowReference.requestActivate()
		}
		catch(err)
		{
			alg.log.exception(err)
		}
	}
}
