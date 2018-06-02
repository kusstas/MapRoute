import QtQuick 2.0
import QtLocation 5.9
import QtPositioning 5.8

Map {
    id: map
    plugin: Plugin {
        name: "here"
        PluginParameter { name: "here.app_id"; value: "JBf7DSJc2EG3GndwTA3r" }
        PluginParameter { name: "here.token"; value: "WZX2OJPFdPJd3VQOX7Ik8g" }
    }
    center: startFromSource ? sourceCoordinate() : QtPositioning.coordinate()
    anchors.fill: parent
    copyrightsVisible: false
    zoomLevel: (maximumZoomLevel - minimumZoomLevel) / 2

    property bool startFromSource: true
    property int updateIntervalSource: 1000
    property real animToSourceDuration: 400

    readonly property alias isTrackingCoordinate: mouseTracker.tracking
    readonly property alias trackingId: mouseTracker.trackingId

    signal coordinateSelected(var trackingId, var coordinate)

    function setCenter(coordinate) {
        animToSource.to = coordinate
        animToSource.start()
    }

    function toSourceLocation() {
        setCenter(sourceCoordinate())
    }

    function sourceCoordinate() {
        return positionSource.position.coordinate
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
}
