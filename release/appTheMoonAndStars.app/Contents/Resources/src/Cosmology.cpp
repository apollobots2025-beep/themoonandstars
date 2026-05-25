#include "Cosmology.h"
#include <QtMath>
static constexpr double H0=67.4, Om=0.315, Or=9.2e-5, Ol=0.6849, Age=13.787, K=1.0227121650537077e-3;
static double H(double a){ return H0*qSqrt(Or/qPow(a,4)+Om/qPow(a,3)+Ol)*K; }
static double ageI(double a){ const int n=3000; const double da=a/n; double s=0; for(int i=1;i<=n;++i){ const double ai=i*da; s += 1.0/(ai*H(ai)); } return s*da; }
double Cosmology::ageGyrForScaleFactor(double a){ a=qBound(1e-6,a,1.0); return qBound(0.001, ageI(a), Age); }
double Cosmology::scaleFactorForAgeGyr(double ageGyr){ ageGyr=qBound(0.001,ageGyr,Age); double lo=1e-6, hi=1.0; for(int i=0;i<48;++i){ const double mid=0.5*(lo+hi); if(ageGyrForScaleFactor(mid)<ageGyr) lo=mid; else hi=mid; } return 0.5*(lo+hi); }
double Cosmology::scaledComovingDistance(double comovingDistance, double ageGyr){ return comovingDistance * scaleFactorForAgeGyr(ageGyr); }
