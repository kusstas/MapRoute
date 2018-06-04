#include "route_intersector.h"
#include <QVariantList>
#include <QJSValue>
#include <QDebug>
#include <tuple>
#include <QVector2D>

std::pair<bool, QVector2D> isIntersect(QVector2D const& a1, QVector2D const& a2, QVector2D const& b1, QVector2D const& b2)
{
    std::pair<bool, QVector2D> result;

    if (a1 == b1 || a1 == b2) {
        result.first = true;
        result.second = a1;
        return result;
    }
    if (a2 == b1 || a2 == b2) {
        result.first = true;
        result.second = a2;
        return result;
    }

    QVector2D v = a2 - a1;
    QVector2D v1 = b1 - a1;
    QVector2D v2 = b2 - a1;

    //double z1 = v.x() -
    //double z2;

    return result;
}

RouteIntersector::RouteIntersector(QObject* parent) : QObject(parent)
{

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

void RouteIntersector::computeIntersect()
{
    QGeoCoordinate result;
    QVariantList const& pathA = routeA()->property("path").value<QJSValue>().toVariant().value<QVariantList>();
    QVariantList const& pathB = routeB()->property("path").value<QJSValue>().toVariant().value<QVariantList>();

    for (auto aIt1 = pathA.begin(), aIt2 = aIt1 + 1; aIt2 != pathA.end(); aIt1++, aIt2++) {
        QGeoCoordinate const& a1 = aIt1->value<QGeoCoordinate>();
        QGeoCoordinate const& a2 = aIt2->value<QGeoCoordinate>();
        for (auto bIt1 = pathB.begin(), bIt2 = bIt1 + 1; bIt2 != pathB.end(); bIt1++, bIt2++) {
            QGeoCoordinate const& b1 = bIt1->value<QGeoCoordinate>();
            QGeoCoordinate const& b2 = bIt2->value<QGeoCoordinate>();

            auto intersect = isIntersect(QVector2D(a1.latitude(), a1.longitude()), QVector2D(a2.latitude(), a2.longitude()),
                                      QVector2D(b1.latitude(), b1.longitude()), QVector2D(b2.latitude(), b2.longitude()));

            if (true == intersect.first) {
                result.setLatitude(intersect.second.x());
                result.setLongitude(intersect.second.y());
            }
        }
    }

    emit resultReady(result);
}
