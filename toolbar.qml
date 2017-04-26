import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import AlgWidgets 1.0
import AlgWidgets.Style 1.0

Row
{
	property var windowReference : null
	
	Button
	{
		id: rect
		antialiasing: true
		width: 30
		height: 30
		hoverEnabled: true

		Rectangle
		{
			width: parent.width
			height: parent.height
			color: rect.hovered ? "#424242" : "#141414"
			
			Image
			{
				source: "icon.svg"
				fillMode: Image.PreserveAspectFit
				width: parent.width
				height: parent.height
				mipmap: true
			}
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
}
