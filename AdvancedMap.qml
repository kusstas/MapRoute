import QtQuick 2.0
import QtLocation 5.9
import QtPositioning 5.8

Item {
    property bool startFromSource: true
    property int updateIntervalSource: 1000
    property real animToSourceDuration: 400
    property int sizeButtonTools: 44
    property real stepZoom: 0.2

    signal coordinateSelected(var coordinate)

    function toSourceLocation() {
        animToSource.to = positionSource.position.coordinate
        animToSource.start()
    }

    function coordinateFromMousePos() {
        return map.toCoordinate(Qt.point(mouseTracker.mouseX, mouseTracker.mouseY))
    }

    PropertyAnimation {
        id: animToSource
        target: map
        properties: "center"
        duration: animToSourceDuration
        easing.type: Easing.OutExpo
    }

    PositionSource {
        id: positionSource
        active: true
        updateInterval: updateInterval
        onPositionChanged: sourceMarker.coordinate = position.coordinate
    }

    Map {
        id: map
        plugin: Plugin { name: "osm" }
        center: startFromSource ? positionSource.position.coordinate : QtPositioning.coordinate()
        anchors.fill: parent
        copyrightsVisible: false
        zoomLevel: (maximumZoomLevel - minimumZoomLevel) / 2
        color: "#75bbfd"

        MouseArea {
            id: mouseTracker
            anchors.fill: map
            onClicked: coordinateSelected(coordinateFromMousePos());
        }

        Marker {
            id: sourceMarker
        }
    }

    MapTools {
        id: tools
        anchors.right: map.right
        anchors.bottom: map.bottom
        anchors.rightMargin: 5
        anchors.bottomMargin: 5
        width: sizeButtonTools

        onClickToSource: toSourceLocation()
        onZoomUp: map.zoomLevel += stepZoom
        onZoomDown: map.zoomLevel -= stepZoom

        Connections {
            target: map
            onZoomLevelChanged: {
                tools.enabledZoomUp = map.zoomLevel < map.maximumZoomLevel
                tools.enabledZoomDown = map.zoomLevel > map.minimumZoomLevel
            }
        }
    }
}
