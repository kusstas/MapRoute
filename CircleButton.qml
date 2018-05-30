import QtQuick 2.0
import QtQuick.Controls 2.3

Button {
    id: button
    property alias color: rect.color
    property alias border: rect.border
    property real scaleHovered: 1.075
    property real scalePressed: 0.975
    property int durationAnimations: 50

    highlighted: true
    background : Rectangle {
        id: rect
        anchors.fill: parent
        radius: width / 2
    }

    onHoveredChanged: animHover.start()
    onPressedChanged: animPress.start()

    PropertyAnimation {
        id: animHover
        target: button
        property: "scale"
        to: hovered ? 1 : scaleHovered
        duration: durationAnimations
    }

    PropertyAnimation {
        id: animPress
        target: button
        property: "scale"
        to: pressed ? 1 : scalePressed
        duration: durationAnimations
    }
}
