#include "opencv2/calib3d/calib3d.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/contrib/contrib.hpp"

#include <stdio.h>

using namespace cv;

static void saveXYZ(const char* filename, const Mat& mat);

void stereo_match(Mat limg, Mat rimg, Mat M1, Mat M2, Mat D1, Mat D2, Mat R, Mat T, char* disparity_filename, char* point_cloud_filename, char* qmatfile);
	
