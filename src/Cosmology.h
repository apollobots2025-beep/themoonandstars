#pragma once
class Cosmology
{
public:
    static double scaleFactorForAgeGyr(double ageGyr);
    static double ageGyrForScaleFactor(double a);
    static double scaledComovingDistance(double comovingDistance, double ageGyr);
};
