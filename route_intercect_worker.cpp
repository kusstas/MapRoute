#include "route_intercect_worker.h"

#include <QVariantList>
#include <QJSValue>
#include <QVector2D>

#include <tuple>
#include <cmath>

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

    double z1 = v.x() * v1.y() - v.y() * v1.x();
    double z2 = v.x() * v2.y() - v.y() * v2.x();

    if ((z1 > 0.0 && z2 > 0.0) || (z1 < 0.0 && z2 < 0.0)) {
        result.first = false;
        return result;
    }

    v = b2 - b1;
    v1 = a1 - b1;
    v2 = a2 - b1;

    z1 = v.x() * v1.y() - v.y() * v1.x();
    z2 = v.x() * v2.y() - v.y() * v2.x();

    if ((z1 > 0.0 && z2 > 0.0) || (z1 < 0.0 && z2 < 0.0)) {
        result.first = false;
        return result;
    }

    result.first = true;
    QVector2D& rv = result.second;
    double p = fabs(z1 / (z2 - z1));
    rv.setX(b1.x() + (b2.x() - b1.x()) * p);
    rv.setY(b1.y() + (b2.y() - b1.y()) * p);

    return result;
}

RouteIntercectWorker::RouteIntercectWorker(QObject* parent) : QObject(parent), m_isRunning(false)
{
}

QObject* RouteIntercectWorker::routeA() const
{
    return m_routeA;
}

QObject* RouteIntercectWorker::routeB() const
{
    return m_routeB;
}

void RouteIntercectWorker::setRouteA(QObject* routeA)
{
    m_routeA = routeA;
}

void RouteIntercectWorker::setRouteB(QObject* routeB)
{
    m_routeB = routeB;
}

bool RouteIntercectWorker::isRunning() const
{
    return m_isRunning;
}

void RouteIntercectWorker::compute()
{
    m_isRunning = true;
    bool intersectFind = false;
    QGeoCoordinate result;
    QVariantList const& pathA = routeA()->property("path").value<QJSValue>().toVariant().value<QVariantList>();
    QVariantList const& pathB = routeB()->property("path").value<QJSValue>().toVariant().value<QVariantList>();

    for (auto aIt1 = pathA.begin(), aIt2 = aIt1 + 1; aIt2 != pathA.end() && !intersectFind; aIt1++, aIt2++) {
        QGeoCoordinate const& a1 = aIt1->value<QGeoCoordinate>();
        QGeoCoordinate const& a2 = aIt2->value<QGeoCoordinate>();
        for (auto bIt1 = pathB.begin(), bIt2 = bIt1 + 1; bIt2 != pathB.end() && !intersectFind; bIt1++, bIt2++) {
            QGeoCoordinate const& b1 = bIt1->value<QGeoCoordinate>();
            QGeoCoordinate const& b2 = bIt2->value<QGeoCoordinate>();

            auto const& intersect = isIntersect(QVector2D(a1.latitude(), a1.longitude()), QVector2D(a2.latitude(), a2.longitude()),
                                                QVector2D(b1.latitude(), b1.longitude()), QVector2D(b2.latitude(), b2.longitude()));

            intersectFind = intersect.first;
            if (intersectFind) {
                result.setLatitude(intersect.second.x());
                result.setLongitude(intersect.second.y());
            }
        }
    }
    emit complete(result);
    m_isRunning = false;
}
