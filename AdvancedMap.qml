import QtQuick 2.0
import QtLocation 5.9
import QtPositioning 5.8

Map {
    id: map
    plugin: Plugin { name: "osm" }
    center: startFromSource ? sourceCoordinate() : QtPositioning.coordinate()
    anchors.fill: parent
    copyrightsVisible: false
    zoomLevel: (maximumZoomLevel - minimumZoomLevel) / 2

    property bool startFromSource: true
    property int updateIntervalSource: 1000
    property real animToSourceDuration: 400
    property int sizeButtonTools: 45
    property real stepZoom: 0.2

    property alias markerSource: sourceMarker
    property alias tools: tools
    readonly property alias isTrackingCoordinate: mouseTracker.tracking
    readonly property alias trackingId: mouseTracker.trackingId

    signal coordinateSelected(var trackingId, var coordinate)

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

    function trakingCoordinate(trackingId) {
        if (mouseTracker.tracking)
            return false

        mouseTracker.trackingId = trackingId
        mouseTracker.tracking = true;
        return true
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

    MouseArea {
        id: mouseTracker
        anchors.fill: map
        onClicked: {
            if (tracking)
                coordinateSelected(trackingId, coordinateFromMousePos())
            tracking = false;
        }
        cursorShape: tracking ? Qt.CrossCursor : Qt.ArrowCursor
        focus: isTrackingCoordinate
        Keys.onEscapePressed: unTrakingCoordinate()
        property bool tracking: false
        property string trackingId

    }

    Marker {
        id: sourceMarker
        index: "S"
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
        onClickSetCenter: trakingCoordinate(trackIdSetCenter)
        enabledSetCenter: !isTrackingCoordinate

        property string trackIdSetCenter: "map.center"
    }

    onCoordinateSelected:  {
        if (trackingId === tools.trackIdSetCenter) {
            setCenter(coordinate)
        }
    }

    onZoomLevelChanged: {
        tools.enabledZoomUp = map.zoomLevel < map.maximumZoomLevel
        tools.enabledZoomDown = map.zoomLevel > map.minimumZoomLevel
    }
}
