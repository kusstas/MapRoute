import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

ColumnLayout {

    signal clickToSource()

    readonly property string sourceToSourceIcon: "qrc:/images/map-marker-btn.png"
    readonly property int widthButtons: width
    readonly property int heightButtons: width

    property string colorButtons: "#222f3e"
    property string colorBorderButtons: "white"

    CircleButton {
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons

        Image {
            source: sourceToSourceIcon
            anchors.fill: parent
            anchors.margins: 8
            fillMode: Image.PreserveAspectFit
        }

        onClicked: clickToSource()
    }

    CircleButton {
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons

        Text {
            text: "+"
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: parent.height / 2
            font.bold: true
        }
    }

    CircleButton {
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons

        Text {
            text: "-"
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: parent.height / 2
            font.bold: true
        }
    }

}
