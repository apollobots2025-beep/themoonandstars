#pragma once
#include <QObject>
#include <QVariantList>
#include "CatalogLoader.h"

class AppModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentMode READ currentMode WRITE setCurrentMode NOTIFY currentModeChanged)
    Q_PROPERTY(bool dataLoaded READ dataLoaded NOTIFY dataLoadedChanged)
    Q_PROPERTY(QString statusMessage READ statusMessage NOTIFY statusMessageChanged)

public:
    explicit AppModel(QObject *parent = nullptr);
    ~AppModel();

    QString currentMode() const { return m_currentMode; }
    void setCurrentMode(const QString &mode);

    bool dataLoaded() const { return m_dataLoaded; }
    QString statusMessage() const { return m_statusMessage; }

    Q_INVOKABLE void loadData();
    Q_INVOKABLE void loadCache();
    Q_INVOKABLE void clearData();

signals:
    void currentModeChanged();
    void dataLoadedChanged();
    void statusMessageChanged();

private slots:
    void onCatalogStatus(const QString &message);
    void onCatalogReady(const QVector<UniverseRecord> &records);

private:
    void setStatusMessage(const QString &msg);
    void setDataLoaded(bool loaded);

    QString m_currentMode = "Globe";
    bool m_dataLoaded = false;
    QString m_statusMessage;
    CatalogLoader m_catalogLoader;
};
