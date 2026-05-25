#pragma once
#include <QVector3D>
#include <QDateTime>

struct OrbitElements
{
    double semiMajorAxisAU = 0.0;
    double eccentricity = 0.0;
    double inclinationDeg = 0.0;
    double ascendingNodeDeg = 0.0;
    double argPeriapsisDeg = 0.0;
    double meanAnomalyDeg = 0.0;
    double periodDays = 0.0;
    double epochJD = 2451545.0;
    bool valid = false;
};

class OrbitMath
{
public:
    static double julianDayNow();
    static QVector3D positionAtJD(const OrbitElements &e);
};
