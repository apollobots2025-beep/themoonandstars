#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVariantMap>
#include <QVector>
#include "OrbitMath.h"

struct UniverseRecord
{
    QString source;
    QString id;
    QString name;
    QString category;
    double raDeg = 0.0;
    double decDeg = 0.0;
    double distanceLy = -1.0;
    double radiusKm = -1.0;
    double magnitude = 99.0;
    bool radiusKnown = false;
    bool distanceKnown = false;
    bool magnitudeKnown = false;
    bool hasOrbit = false;
    OrbitElements orbit;
    QVariantMap extra;
};

class CatalogLoader : public QObject
{
    Q_OBJECT
public:
    explicit CatalogLoader(QObject *parent = nullptr);

    void loadCache();
    void loadAll();
    void saveCache(const QVector<UniverseRecord> &records) const;

signals:
    void status(const QString &message);
    void recordsReady(const QVector<UniverseRecord> &records);

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    struct SourceJob { QString source; QString kind; QUrl url; QString note; };
    QString cachePath() const;
    QNetworkRequest makeRequest(const QUrl &url) const;
    QVector<SourceJob> buildTrustedJobs() const;
    void queueRequest(const SourceJob &job);
    void flushIfDone();
    QVector<UniverseRecord> parseResponse(const QString &source, const QString &kind, const QByteArray &body) const;

    QNetworkAccessManager m_net;
    QMap<QNetworkReply*, SourceJob> m_pending;
    QVector<UniverseRecord> m_accum;
};
