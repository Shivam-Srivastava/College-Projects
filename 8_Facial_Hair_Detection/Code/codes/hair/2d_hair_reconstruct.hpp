#include <math.h>
#include <cv.h>
#include <highgui.h>
#include <iostream>
#include <string>

#ifndef GROW_HAIR_2D_HPP
#define GROW_HAIR_2D_HPP

#define gamma 60
#define growthResolution 10 //This is the number of pixels from ps point in the chosen direction
#define nu_threshold 0.5
#define threshold_to_acceptHair 0.2
#define EPS 0.001

using namespace cv;

/*
 * Input:
 * hairmap.jpg orientationmap.jpg outputhairfilename.jpg
 */
Mat growHair2D(Mat hmap, Mat omap);

#endif
