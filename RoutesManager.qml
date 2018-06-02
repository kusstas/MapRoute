import QtQuick 2.0
import QtLocation 5.9
import QtPositioning 5.8

Item {
    property alias plugin: routeModel.plugin
    property alias routeA: routeA
    property alias routeB: routeB

    signal makeQueryRouteA(var query)
    signal makeQueryRouteB(var query)

    function buildAllRoutes() {
        makeQueryRouteA(routeQuery)
        routeModel.target = routeA
        routeModel.update()
    }

    RouteQuery {
        id: routeQuery
    }

    RouteModel {
        id: routeModel
        query: routeQuery
        property Route target

        onRoutesChanged: {
            var r = get(0)
            target.path = r.path
            target.segments = r.segments

            if (target == routeA) {
                makeQueryRouteB(routeQuery)
                routeModel.target = routeB
                routeModel.update()
            }
        }
    }

    Route {
        id: routeA
    }

    Route {
        id: routeB
    }
}
