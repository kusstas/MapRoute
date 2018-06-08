#include "route_intercect_worker.h"

#include <QVariantList>
#include <QVector>
#include <QJSValue>
#include <QVector2D>
#include <QDebug>

#include <algorithm>
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
    QGeoCoordinate result;
    QVariantList const& pathA = routeA()->property("path").value<QJSValue>().toVariant().value<QVariantList>();
    QVariantList const& pathB = routeB()->property("path").value<QJSValue>().toVariant().value<QVariantList>();

    using LineSegment = std::pair<QVector2D, QVector2D>;

    QVector<LineSegment> lpA(pathA.size() - 1);
    QVector<LineSegment> lpB(pathB.size() - 1);

    auto itA = pathA.begin();
    for (auto it = lpA.begin(); it != lpA.end(); ++it) {
        auto const& c1 = itA->value<QGeoCoordinate>();
        auto const& c2 = (++itA)->value<QGeoCoordinate>();

        auto const& x1 = c1.latitude();
        auto const& x2 = c2.latitude();

        *it = x1 < x2 ? std::make_pair(QVector2D(c1.latitude(), c1.longitude()), QVector2D(c2.latitude(), c2.longitude())) :
                        std::make_pair(QVector2D(c2.latitude(), c2.longitude()), QVector2D(c1.latitude(), c1.longitude()));
    }

    auto itB = pathB.begin();
    for (auto it = lpB.begin(); it != lpB.end(); ++it) {
        auto const& c1 = itB->value<QGeoCoordinate>();
        auto const& c2 = (++itB)->value<QGeoCoordinate>();

        auto const& x1 = c1.latitude();
        auto const& x2 = c2.latitude();

        *it = x1 < x2 ? std::make_pair(QVector2D(c1.latitude(), c1.longitude()), QVector2D(c2.latitude(), c2.longitude())) :
                        std::make_pair(QVector2D(c2.latitude(), c2.longitude()), QVector2D(c1.latitude(), c1.longitude()));
    }

    auto xless = [] (LineSegment const& l, LineSegment const& r) {
        return l.first.x() < r.first.x();
    };

    std::sort(lpA.begin(), lpA.end(), xless);
    std::sort(lpB.begin(), lpB.end(), xless);

    auto a = lpA.begin();
    auto b = lpB.begin();
    while (a != lpA.end() && b != lpB.end()) {
        if (a->second.x() < b->first.x()) {
            ++a;
        }
        else if (b->second.x() < a->first.x()) {
            ++b;
        }
        else {
            auto res = isIntersect(a->first, a->second, b->first, b->second);
            if (res.first) {
                result.setLatitude(res.second.x());
                result.setLongitude(res.second.y());
                break;
            }
            else {
                ++a;
                ++b;
            }
        }
    }
    emit complete(result);
    m_isRunning = false;
}
