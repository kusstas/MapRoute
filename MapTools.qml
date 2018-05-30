import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

ColumnLayout {

    signal clickToSource()
    signal zoomUp()
    signal zoomDown()

    readonly property string sourceToSourceIcon: "qrc:/images/map-marker-btn.png"
    readonly property int widthButtons: width
    readonly property int heightButtons: width

    property string colorButtons: "#222f3e"
    property string colorBorderButtons: "white"

    property alias enabledZoomUp: btnZoomUp.enabled
    property alias enabledZoomDown: btnZoomDown.enabled

    property int intervalHoldZoom: 100

    Timer {
        id: timerUp
        interval: intervalHoldZoom
        repeat: true
        onTriggered: zoomUp()
    }

    Timer {
        id: timerDown
        interval: intervalHoldZoom
        repeat: true
        onTriggered: zoomDown()
    }

    CircleButton {
        id: btnToSource
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons
        icon.source: sourceToSourceIcon
        onClicked: clickToSource()
    }

    CircleButton {
        id: btnZoomUp
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons
        text: "+"
        font.bold: true
        font.pointSize: 20 * scale
        onClicked: zoomUp()
        onPressAndHold: { zoomUp(); timerUp.start() }
        onReleased: timerUp.stop()
        onCanceled: timerUp.stop()
        onEnabledChanged: { timerUp.stop() }
    }

    CircleButton {
        id: btnZoomDown
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons
        text: "-"
        font.bold: true
        font.pointSize: 20 * scale
        onClicked: zoomDown()
        onPressAndHold: { zoomDown(); timerDown.start() }
        onReleased: timerDown.stop()
        onCanceled: timerDown.stop()
        onEnabledChanged: timerDown.stop()
    }    
}
