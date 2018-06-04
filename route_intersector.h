#ifndef ROUTE_INTERSECTOR_H
#define ROUTE_INTERSECTOR_H

#include <QObject>
#include <QThread>
#include <QGeoCoordinate>

#include "route_intercect_worker.h"

class RouteIntersector : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject* routeA READ routeA WRITE setRouteA)
    Q_PROPERTY(QObject* routeB READ routeB WRITE setRouteB)

public:

    explicit RouteIntersector(QObject* parent = nullptr);
    virtual ~RouteIntersector();

    QObject* routeA() const;
    QObject* routeB() const;

    void setRouteA(QObject* routeA);
    void setRouteB(QObject* routeB);

public slots:

    void findIntersect();

signals:

    void started();
    void complete(QGeoCoordinate result);

private:

    QThread m_thread;
    RouteIntercectWorker m_worker;

    QObject* m_routeA;
    QObject* m_routeB;

};

#endif // ROUTE_INTERSECTOR_H
