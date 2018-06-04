#ifndef ROUTE_INTERCECT_WORKER_H
#define ROUTE_INTERCECT_WORKER_H

#include <QObject>
#include <QGeoCoordinate>

class RouteIntercectWorker : public QObject
{
    Q_OBJECT

public:

    RouteIntercectWorker(QObject* parent = nullptr);

    QObject* routeA() const;
    QObject* routeB() const;

    void setRouteA(QObject* routeA);
    void setRouteB(QObject* routeB);

    bool isRunning() const;

public slots:

    void compute();

signals:

    void complete(QGeoCoordinate result);

private:

    QObject* m_routeA;
    QObject* m_routeB;


    bool m_isRunning;
};

#endif // ROUTE_INTERCECT_WORKER_H
