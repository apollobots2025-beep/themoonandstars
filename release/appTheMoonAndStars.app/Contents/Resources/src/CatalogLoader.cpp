#include "CatalogLoader.h"
#include "Parsing.h"
#include <QDir>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>

CatalogLoader::CatalogLoader(QObject *parent) : QObject(parent)
{
    connect(&m_net, &QNetworkAccessManager::finished, this, &CatalogLoader::onReplyFinished);
}

QString CatalogLoader::cachePath() const
{
    const QString dir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dir);
    return dir + "/universe_cache.json";
}

QNetworkRequest CatalogLoader::makeRequest(const QUrl &url) const
{
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::UserAgentHeader, "TheMoonAndStars/5.0");
    return req;
}

void CatalogLoader::loadCache()
{
    QFile f(cachePath());
    if (!f.open(QIODevice::ReadOnly)) {
        emit status("No cache found yet.");
        return;
    }

    const auto doc = QJsonDocument::fromJson(f.readAll());
    if (!doc.isArray()) {
        emit status("Cache is invalid.");
        return;
    }

    QVector<UniverseRecord> out;
    for (const auto &v : doc.array()) {
        const auto o = v.toObject();
        UniverseRecord r;
        r.source = o["source"].toString();
        r.id = o["id"].toString();
        r.name = o["name"].toString();
        r.category = o["category"].toString();
        r.raDeg = o["raDeg"].toDouble();
        r.decDeg = o["decDeg"].toDouble();
        r.distanceLy = o["distanceLy"].toDouble(-1);
        r.radiusKm = o["radiusKm"].toDouble(-1);
        r.magnitude = o["magnitude"].toDouble(99);
        r.radiusKnown = o["radiusKnown"].toBool();
        r.distanceKnown = o["distanceKnown"].toBool();
        r.magnitudeKnown = o["magnitudeKnown"].toBool();
        r.hasOrbit = o["hasOrbit"].toBool(false);
        r.extra = o["extra"].toObject().toVariantMap();
        out.push_back(r);
    }

    if (!out.isEmpty())
        emit recordsReady(out);
    emit status(QString("Loaded %1 cached records").arg(out.size()));
}

void CatalogLoader::saveCache(const QVector<UniverseRecord> &records) const
{
    QJsonArray arr;
    for (const auto &r : records) {
        QJsonObject o;
        o["source"] = r.source;
        o["id"] = r.id;
        o["name"] = r.name;
        o["category"] = r.category;
        o["raDeg"] = r.raDeg;
        o["decDeg"] = r.decDeg;
        o["distanceLy"] = r.distanceLy;
        o["radiusKm"] = r.radiusKm;
        o["magnitude"] = r.magnitude;
        o["radiusKnown"] = r.radiusKnown;
        o["distanceKnown"] = r.distanceKnown;
        o["magnitudeKnown"] = r.magnitudeKnown;
        o["hasOrbit"] = r.hasOrbit;
        o["extra"] = QJsonObject::fromVariantMap(r.extra);
        arr.push_back(o);
    }

    QFile f(cachePath());
    if (f.open(QIODevice::WriteOnly | QIODevice::Truncate))
        f.write(QJsonDocument(arr).toJson(QJsonDocument::Indented));
}

QVector<CatalogLoader::SourceJob> CatalogLoader::buildTrustedJobs() const
{
    QVector<SourceJob> jobs;
    const QList<double> ras = {0, 72, 144, 216, 288};
    const QList<double> decs = {-60, -30, 0, 30, 60};
    for (double ra : ras) {
        for (double dec : decs) {
            jobs.push_back({"Gaia DR3 / MAST", "votable", QUrl(QString("https://mast.stsci.edu/api/v0.1/Download/file?uri=mast:Gaia/dr3&RA=%1&DEC=%2&SR=0.4").arg(ra).arg(dec)), "sky-tile"});
        }
    }

    const QStringList simbadTargets = {"M31", "M33", "M45", "M42", "M87", "M82", "NGC 1300", "NGC 7293"};
    for (const auto &t : simbadTargets) {
        jobs.push_back({"SIMBAD", "html", QUrl("https://simbad.cds.unistra.fr/simbad/sim-id?Ident=" + QString(QUrl::toPercentEncoding(t))), "object"});
    }

    const QStringList nedTargets = {"arp 220", "ngc 1300", "ngc 224", "ngc 3034", "ngc 5128", "m31"};
    for (const auto &t : nedTargets) {
        jobs.push_back({"NED", "xml", QUrl("https://ned.ipac.caltech.edu/cgi-bin/objsearch?objname=" + QString(QUrl::toPercentEncoding(t)) + "&extend=no&of=xml_main"), "object"});
    }

    jobs.push_back({"NASA Exoplanet Archive", "json", QUrl("https://exoplanetarchive.ipac.caltech.edu/cgi-bin/nstedAPI/nph-nstedAPI?table=pscomppars&select=pl_name,hostname,ra,dec,pl_rade,st_rad,sy_dist,pl_orbper,pl_orbsmax,pl_orbeccen,pl_bmasse,sy_vmag&format=json"), "confirmed-planets"});
    jobs.push_back({"SDSS", "html", QUrl("https://skyserver.sdss.org/dr18/SkyServerWS/SearchTools/Chart/Nearby?ra=180&dec=0&scale=0.2"), "survey"});
    return jobs;
}

void CatalogLoader::loadAll()
{
    m_accum.clear();
    loadCache();
    for (const auto &job : buildTrustedJobs())
        queueRequest(job);
    emit status("Loading trusted sources...");
}

void CatalogLoader::queueRequest(const SourceJob &job)
{
    auto *reply = m_net.get(makeRequest(job.url));
    m_pending.insert(reply, job);
}

void CatalogLoader::flushIfDone()
{
    if (!m_pending.isEmpty()) return;
    if (!m_accum.isEmpty()) { saveCache(m_accum); emit recordsReady(m_accum); }
    emit status(QString("Loaded %1 trusted records").arg(m_accum.size()));
}

void CatalogLoader::onReplyFinished(QNetworkReply *reply)
{
    const SourceJob job = m_pending.take(reply);
    const QByteArray body = reply->readAll();
    reply->deleteLater();

    if (reply->error() != QNetworkReply::NoError) {
        emit status(QString("%1 failed: %2").arg(job.source, reply->errorString()));
        flushIfDone();
        return;
    }

    const auto parsed = parseResponse(job.source, job.kind, body);
    if (!parsed.isEmpty()) m_accum += parsed;

    if (m_pending.isEmpty()) flushIfDone();
}

QVector<UniverseRecord> CatalogLoader::parseResponse(const QString &source, const QString &kind, const QByteArray &body) const
{
    if (kind == "json") return parseJsonArrayRecords(body, source);
    if (kind == "votable") return parseVOTable(body, source);
    if (kind == "xml") return parseXmlRecords(body, source);
    return parseHtmlFallback(body, source);
}
