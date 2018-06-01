import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtPositioning 5.8
import QtLocation 5.9

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("MapRoute")

    property int sizeButtonTools: 45

    AdvancedMap {
        id: map
        anchors.fill: parent
        sizeButtonTools: sizeButtonTools

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

            onClickMakeRoutes: {
                routeAQuery.clearWaypoints()
                routeAQuery.addWaypoint(markerA1.coordinate)
                routeAQuery.addWaypoint(markerA2.coordinate)
                routeAModel.update()

                routeBQuery.clearWaypoints()
                routeBQuery.addWaypoint(markerB1.coordinate)
                routeBQuery.addWaypoint(markerB2.coordinate)
                routeBModel.update()
            }
        }

        RouteQuery {
            id: routeAQuery
        }

        RouteQuery {
            id: routeBQuery
        }

        RouteModel {
            id: routeAModel
            plugin: map.plugin
            query: routeAQuery
        }

        RouteModel {
            id: routeBModel
            plugin: map.plugin
            query: routeBQuery
        }

        MapItemView {
            model: routeAModel
            delegate: MapRoute {
                route: routeData
                line.color: "red"
                line.width: 7
                smooth: true
            }
        }

        MapItemView {
            model: routeBModel
            delegate: MapRoute {
                route: routeData
                line.color: "green"
                line.width: 7
                smooth: true
            }
        }

        Marker {
            id: markerA1
            index: "A1"
            Connections {
                target: map
                onCoordinateSelected: {
                    if (trackingId === markerA1.index)
                        markerA1.coordinate = coordinate
                }
            }
        }

        Marker {
            id: markerA2
            index: "A2"
            Connections {
                target: map
                onCoordinateSelected: {
                    if (trackingId === markerA2.index)
                        markerA2.coordinate = coordinate
                }
            }
        }

        Marker {
            id: markerB1
            index: "B1"
            Connections {
                target: map
                onCoordinateSelected: {
                    if (trackingId === markerB1.index)
                        markerB1.coordinate = coordinate
                }
            }
        }

        Marker {
            id: markerB2
            index: "B2"
            Connections {
                target: map
                onCoordinateSelected: {
                    if (trackingId === markerB2.index)
                        markerB2.coordinate = coordinate
                }
            }
        }

        Marker {
            id: markerOverlap
            index: "O"
        }
    }
}
