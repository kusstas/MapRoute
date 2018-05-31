import QtQuick 2.0
import QtLocation 5.9

MapQuickItem {
    property string sourceIcon: "qrc:/images/map-marker.png"
    property string index: "M"

    sourceItem: Image {
        source: sourceIcon
        Text {
            text: index
            anchors.fill: parent

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            anchors.topMargin: 8
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 24
        }
    }
    anchorPoint: Qt.point(sourceItem.width / 2, sourceItem.height)
}
