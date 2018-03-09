import AlgWidgets.Style 1.0
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Button
{
	id: rect
	antialiasing: true
	width: 32
	height: 32
	tooltip: "Resources updater"

	style: ButtonStyle {
		background: Rectangle {
			implicitWidth: rect.width
			implicitHeight: rect.height
			color: rect.hovered ?
				"#262626" :
				"transparent"
		}
	}

	property var windowReference : null

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
