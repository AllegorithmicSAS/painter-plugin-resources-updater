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

		Rectangle
		{
			width: parent.width
			height: parent.height
			color: "#141414"
			
			Image
			{
				source: "icon_toolbar.png"
				fillMode: Image.PreserveAspectFit
				width: parent.width
				height: parent.height
				mipmap: true
				opacity: 1
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
