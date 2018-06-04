#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <route_intersector.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qmlRegisterType<RouteIntersector>("Custom.RouteIntersector", 1, 0, "RouteIntersector");

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/images/map-icon.ico"));

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    QObject* root = engine.rootObjects()[0];

    if (engine.rootObjects().isEmpty())
        return -1;

    QObject* routesManager = root->findChild<QObject*>("routesManager");
    QObject* routeIntersector = root->findChild<QObject*>("routeIntersector");
    if (nullptr == routesManager || nullptr == routeIntersector) {
        return -1;
    }

    QObject::connect(routesManager, SIGNAL(complete()), routeIntersector, SLOT(findIntersect()));

    return app.exec();
}
