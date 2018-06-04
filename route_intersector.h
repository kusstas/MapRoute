#ifndef ROUTE_INTERSECTOR_H
#define ROUTE_INTERSECTOR_H

#include <QObject>
#include <QGeoCoordinate>

class RouteIntersector : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject* routeA READ routeA WRITE setRouteA)
    Q_PROPERTY(QObject* routeB READ routeB WRITE setRouteB)

public:

    explicit RouteIntersector(QObject* parent = nullptr);

    QObject* routeA() const;
    QObject* routeB() const;

    void setRouteA(QObject* routeA);
    void setRouteB(QObject* routeB);

public slots:

    void computeIntersect();

signals:

    void resultReady(QGeoCoordinate result);

private:

    QObject* m_routeA;
    QObject* m_routeB;
};

#endif // ROUTE_INTERSECTOR_H
