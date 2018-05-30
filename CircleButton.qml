import QtQuick 2.0
import QtQuick.Controls 2.3

Button {
    property alias color: rect.color
    property alias border: rect.border

    highlighted: true
    background : Rectangle {
        id: rect
        anchors.fill: parent
        radius: width / 2
    }
}
