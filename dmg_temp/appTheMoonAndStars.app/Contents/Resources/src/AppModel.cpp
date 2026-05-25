#include "AppModel.h"

AppModel::AppModel(QObject *parent)
    : QObject(parent)
{
    connect(&m_catalogLoader, QOverload<const QString&>::of(&CatalogLoader::status),
            this, &AppModel::onCatalogStatus);
    connect(&m_catalogLoader, QOverload<const QVector<UniverseRecord>&>::of(&CatalogLoader::recordsReady),
            this, &AppModel::onCatalogReady);
}

AppModel::~AppModel()
{
}

void AppModel::setCurrentMode(const QString &mode)
{
    if (m_currentMode != mode) {
        m_currentMode = mode;
        emit currentModeChanged();
    }
}

void AppModel::loadData()
{
    setStatusMessage("Loading all catalog data...");
    m_catalogLoader.loadAll();
}

void AppModel::loadCache()
{
    setStatusMessage("Loading cache...");
    m_catalogLoader.loadCache();
}

void AppModel::clearData()
{
    setDataLoaded(false);
    setStatusMessage("Data cleared");
}

void AppModel::onCatalogStatus(const QString &message)
{
    setStatusMessage(message);
}

void AppModel::onCatalogReady(const QVector<UniverseRecord> &records)
{
    setDataLoaded(true);
    setStatusMessage(QString("Loaded %1 objects").arg(records.size()));
}

void AppModel::setStatusMessage(const QString &msg)
{
    if (m_statusMessage != msg) {
        m_statusMessage = msg;
        emit statusMessageChanged();
    }
}

void AppModel::setDataLoaded(bool loaded)
{
    if (m_dataLoaded != loaded) {
        m_dataLoaded = loaded;
        emit dataLoadedChanged();
    }
}
