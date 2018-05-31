import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

ColumnLayout {
    signal clickA1;
    signal clickA2;
    signal clickB1;
    signal clickB2;
    signal clickMakeRoutes;

    readonly property int widthButtons: width
    readonly property int heightButtons: width

    property color colorButtons: "#222f3e"
    property color colorBorderButtons: "white"

    CircleButton {
        id: btnA1
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons
        text: "A1"
        font.bold: true
        font.pointSize: 12
        onClicked: clickA1()
    }

    CircleButton {
        id: btnA2
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons
        text: "A2"
        font.bold: true
        font.pointSize: 12
        onClicked: clickA2()
    }

    CircleButton {
        id: btnB1
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons
        text: "B1"
        font.bold: true
        font.pointSize: 12
        onClicked: clickB1()
    }

    CircleButton {
        id: btnB2
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons
        text: "B2"
        font.bold: true
        font.pointSize: 12
        onClicked: clickB2()
    }

    CircleButton {
        id: btnMakeRoute
        Layout.preferredWidth: widthButtons
        Layout.preferredHeight: heightButtons
        color: colorButtons
        border.color: colorBorderButtons
        text: "MK"
        font.bold: true
        font.pointSize: 12
        onClicked: clickMakeRoutes()
    }
}
