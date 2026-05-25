#pragma once
#include <QByteArray>
#include <QVector>
#include "CatalogLoader.h"
QVector<UniverseRecord> parseVOTable(const QByteArray &xml, const QString &source);
QVector<UniverseRecord> parseJsonArrayRecords(const QByteArray &json, const QString &source);
QVector<UniverseRecord> parseXmlRecords(const QByteArray &xml, const QString &source);
QVector<UniverseRecord> parseHtmlFallback(const QByteArray &html, const QString &source);
