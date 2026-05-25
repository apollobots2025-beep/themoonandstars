#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "AppModel.h"
#include "TravelController.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName("OpenAI");
    QCoreApplication::setApplicationName("TheMoonAndStars");

    AppModel model;
    TravelController travel;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appModel", &model);
    engine.rootContext()->setContextProperty("travelController", &travel);

    const QUrl url(u"qrc:/MoonStars/qml/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                     [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
