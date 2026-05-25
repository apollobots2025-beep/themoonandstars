#include "OrbitMath.h"
#include <QtMath>
double OrbitMath::julianDayNow()
{
    const qint64 secs = QDateTime::currentDateTimeUtc().toSecsSinceEpoch();
    return 2440587.5 + double(secs) / 86400.0;
}
static double solveKepler(double M, double e){ double E=M; for(int i=0;i<16;++i){ const double f=E-e*qSin(E)-M; const double fp=1.0-e*qCos(E); E-=f/fp; } return E; }
QVector3D OrbitMath::positionAtJD(const OrbitElements &el)
{
    if(!el.valid || el.semiMajorAxisAU<=0.0) return QVector3D();
    const double M0=qDegreesToRadians(el.meanAnomalyDeg);
    const double n=el.periodDays>0.0 ? (2.0*M_PI/el.periodDays) : 0.0;
    double M=std::fmod(M0 + n*(julianDayNow()-el.epochJD), 2.0*M_PI); if(M<0) M+=2.0*M_PI;
    const double e=qBound(0.0, el.eccentricity, 0.999999);
    const double E=solveKepler(M,e);
    const double x=el.semiMajorAxisAU*(qCos(E)-e);
    const double y=el.semiMajorAxisAU*qSqrt(1.0-e*e)*qSin(E);
    const double i=qDegreesToRadians(el.inclinationDeg), O=qDegreesToRadians(el.ascendingNodeDeg), w=qDegreesToRadians(el.argPeriapsisDeg);
    const double cw=qCos(w), sw=qSin(w), cO=qCos(O), sO=qSin(O), ci=qCos(i), si=qSin(i);
    return QVector3D(float((cO*cw - sO*sw*ci)*x + (-cO*sw - sO*cw*ci)*y),
                     float((sO*cw + cO*sw*ci)*x + (-sO*sw + cO*cw*ci)*y),
                     float((sw*si)*x + (cw*si)*y));
}
