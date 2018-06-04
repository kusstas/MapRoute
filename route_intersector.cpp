#include "route_intersector.h"

RouteIntersector::RouteIntersector(QObject* parent) : QObject(parent)
{
    m_worker.moveToThread(&m_thread);
    connect(&m_thread, &QThread::started, &m_worker, &RouteIntercectWorker::compute);
    connect(&m_worker, &RouteIntercectWorker::complete, this, &RouteIntersector::complete);
    connect(&m_worker, &RouteIntercectWorker::complete, &m_thread, &QThread::quit, Qt::DirectConnection);
}

RouteIntersector::~RouteIntersector()
{
    m_thread.quit();
    m_thread.wait();
}

QObject* RouteIntersector::routeA() const
{
    return m_routeA;
}

QObject* RouteIntersector::routeB() const
{
    return m_routeB;
}

void RouteIntersector::setRouteA(QObject* routeA)
{
    m_routeA = routeA;
}

void RouteIntersector::setRouteB(QObject* routeB)
{
    m_routeB = routeB;
}

void RouteIntersector::findIntersect()
{
    if (m_worker.isRunning()) {
        return;
    }
    emit started();

    m_worker.setRouteA(routeA());
    m_worker.setRouteB(routeB());

    m_thread.start();
}
