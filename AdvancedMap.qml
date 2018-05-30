import QtQuick 2.0
import QtLocation 5.9
import QtPositioning 5.8

Item {
    id: advancedMap
    property bool startFromSource: true
    property int updateIntervalSource: 1000
    property real animToSourceDuration: 400
    property int sizeButtonTools: 44
    property real stepZoom: 0.2
    readonly property alias isTrackingCoordinate: mouseTracker.tracking

    signal coordinateSelected(var coordinate)

    function setCenter(coordinate) {
        animToSource.to = coordinate
        animToSource.start()
    }

    function sourceCoordinate() {
        return positionSource.position.coordinate
    }

    function toSourceLocation() {
        setCenter(sourceCoordinate())
    }

    function coordinateFromMousePos() {
        return map.toCoordinate(Qt.point(mouseTracker.mouseX, mouseTracker.mouseY))
    }

    function trakingCoordinate() {
        mouseTracker.tracking = true;
    }

    function unTrakingCoordinate() {
        mouseTracker.tracking = false;
    }

    PropertyAnimation {
        id: animToSource
        target: map
        property: "center"
        duration: animToSourceDuration
        easing.type: Easing.OutExpo
    }

    PositionSource {
        id: positionSource
        active: true
        updateInterval: updateIntervalSource
        onPositionChanged: sourceMarker.coordinate = position.coordinate
    }

    Map {
        id: map
        plugin: Plugin { name: "osm" }
        center: startFromSource ? sourceCoordinate() : QtPositioning.coordinate()
        anchors.fill: parent
        copyrightsVisible: false
        zoomLevel: (maximumZoomLevel - minimumZoomLevel) / 2

        MouseArea {
            id: mouseTracker
            anchors.fill: map
            onClicked: {
                if (tracking)
                    coordinateSelected(coordinateFromMousePos())
                tracking = false;
            }
            cursorShape: tracking ? Qt.CrossCursor : Qt.ArrowCursor
            property bool tracking: false
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
        enabled: !isTrackingCoordinate

        onClickToSource: toSourceLocation()
        onZoomUp: map.zoomLevel += stepZoom
        onZoomDown: map.zoomLevel -= stepZoom
        onClickSetCenter: { trakingCoordinate(); selectionCenter = true; }

        property bool selectionCenter: false

        Connections {
            target: map
            onZoomLevelChanged: {
                tools.enabledZoomUp = map.zoomLevel < map.maximumZoomLevel
                tools.enabledZoomDown = map.zoomLevel > map.minimumZoomLevel
            }
        }

        Connections {
            target: advancedMap
            onCoordinateSelected: {
                if (tools.selectionCenter) {
                    setCenter(coordinate)
                }
            }
        }
    }
}
