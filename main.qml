import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtPositioning 5.8
import QtLocation 5.9
import Custom.RouteIntersector 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("MapRoute")

    property int sizeButtonTools: 45
    property real stepZoom: 0.2
    property color colorRouteA: "red"
    property color colorRouteB: "blue"
    property int widthLineRoute: 6
    property real opacityLineRoute: 0.85

    footer: Rectangle {
        color: "#222f3e"
        height: 25
        Text {
            id: status
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 5
            verticalAlignment: Text.AlignVCenter
            color: "white"
            text: {
                var format = "Coordinate intersection: %1"
                if (routesManager.isDownloading)
                    return "Downloading..."
                if (!markerIntersect.visible)
                    return "Searching intersection..."
                if (markerIntersect.coordinate !== QtPositioning.coordinate())
                    return format.arg(markerIntersect.coordinate)
                return "None"
            }
        }
        Text {
            id: centerCoordBar
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 5
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            color: "white"
            property string format: "Center: %1"
            text: format.arg(map.center)
        }
    }

    AdvancedMap {
        id: map
        anchors.fill: parent

        RoutesManager {
            id: routesManager
            objectName: "routesManager"
            plugin: map.plugin
            property bool isDownloading: false

            onStarted: {
                isDownloading = true
            }

            onMakeQueryRouteA: {
                query.clearWaypoints()
                query.addWaypoint(markerA1.coordinate)
                query.addWaypoint(markerA2.coordinate)
            }

            onMakeQueryRouteB: {
                query.clearWaypoints()
                query.addWaypoint(markerB1.coordinate)
                query.addWaypoint(markerB2.coordinate)
            }

            onComplete: {
                mapRouteA.visible = true
                mapRouteB.visible = true
                isDownloading = false
            }
        }

        RouteIntersector {
            id: routeIntersector
            objectName: "routeIntersector"
            routeA: routesManager.routeA
            routeB: routesManager.routeB

            onComplete: {
                markerIntersect.coordinate = result
                markerIntersect.visible = true
            }
        }

        MapRoute {
            id: mapRouteA
            route: routesManager.routeA
            line.color: colorRouteA
            line.width: widthLineRoute
            opacity: opacityLineRoute
        }

        MapRoute {
            id: mapRouteB
            route: routesManager.routeB
            line.color: colorRouteB
            line.width: widthLineRoute
            opacity: opacityLineRoute
        }

        Marker {
            id: sourceMarker
            index: "S"
            coordinate: map.sourceCoordinate()
        }

        Marker {
            id: markerA1
            index: "A1"
            Connections {
                target: map
                onCoordinateSelected: {
                    if (trackingId === markerA1.index) {
                        markerA1.coordinate = coordinate
                        mapRouteA.visible = false
                        markerIntersect.visible = false
                    }
                }
            }
        }

        Marker {
            id: markerA2
            index: "A2"
            Connections {
                target: map
                onCoordinateSelected: {
                    if (trackingId === markerA2.index) {
                        markerA2.coordinate = coordinate
                        mapRouteA.visible = false
                        markerIntersect.visible = false
                    }
                }
            }
        }

        Marker {
            id: markerB1
            index: "B1"
            Connections {
                target: map
                onCoordinateSelected: {
                    if (trackingId === markerB1.index) {
                        markerB1.coordinate = coordinate
                        mapRouteB.visible = false
                        markerIntersect.visible = false
                    }
                }
            }
        }

        Marker {
            id: markerB2
            index: "B2"
            Connections {
                target: map
                onCoordinateSelected: {
                    if (trackingId === markerB2.index) {
                        markerB2.coordinate = coordinate
                        mapRouteB.visible = false
                        markerIntersect.visible = false
                    }
                }
            }
        }

        Marker {
            id: markerIntersect
            index: "O"
        }
    }

    MapTools {
        id: tools
        anchors.right: map.right
        anchors.bottom: map.bottom
        anchors.margins: 5
        width: sizeButtonTools

        onClickToSource: map.toSourceLocation()
        onZoomUp: map.zoomLevel += stepZoom
        onZoomDown: map.zoomLevel -= stepZoom
        onClickSetCenter: map.trakingCoordinate(trackIdSetCenter)
        enabledSetCenter: !map.isTrackingCoordinate

        property string trackIdSetCenter: "map.center"

        Connections {
            target: map
            onCoordinateSelected:  {
                if (trackingId === tools.trackIdSetCenter) {
                    map.setCenter(coordinate)
                }
            }
            onZoomLevelChanged: {
                tools.enabledZoomUp = map.zoomLevel < map.maximumZoomLevel
                tools.enabledZoomDown = map.zoomLevel > map.minimumZoomLevel
            }
        }
    }

    RoutesTools {
        id: routesTools
        anchors.right: parent.right
        anchors.top:  parent.top
        anchors.margins: 5
        width: sizeButtonTools
        enabled: !map.isTrackingCoordinate

        onClickA1: map.trakingCoordinate(markerA1.index)
        onClickA2: map.trakingCoordinate(markerA2.index)
        onClickB1: map.trakingCoordinate(markerB1.index)
        onClickB2: map.trakingCoordinate(markerB2.index)

        onClickBuildRoutes: {
            routesManager.buildAllRoutes()
        }
    }
}
