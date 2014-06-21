#include "opencv2/calib3d/calib3d.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/contrib/contrib.hpp"
#include <iostream>

#include <stdio.h>
#include "stereo_match.hpp"

using namespace cv;
using namespace std;

static void saveXYZ(const char* filename, const Mat& mat)
{
	const double max_z = 1.0e4;
	FILE* fp = fopen(filename, "wt");
	for(int y = 0; y < mat.rows; y++)
	{
		for(int x = 0; x < mat.cols; x++)
		{
			Vec3f point = mat.at<Vec3f>(y, x);
			if(fabs(point[2] - max_z) < FLT_EPSILON || fabs(point[2]) > max_z) continue;
			fprintf(fp, "%f %f %f\n", point[0], point[1], point[2]);
		}
	}
	fclose(fp);
}

void stereo_match(Mat limg, Mat rimg, Mat M1, Mat M2, Mat D1, Mat D2, Mat R, Mat T, char* disparity_filename, char* point_cloud_filename, char* qmatfile)
{
	const char* algorithm_opt = "--algorithm=";
	const char* maxdisp_opt = "--max-disparity=";
	const char* blocksize_opt = "--blocksize=";

	enum { STEREO_BM=0, STEREO_SGBM=1, STEREO_HH=2, STEREO_VAR=3 };
	int alg = STEREO_VAR;
	int SADWindowSize = 5, numberOfDisparities = 256;
	bool no_display = false;
	float scale = 1.f;

	StereoBM bm;
	StereoSGBM sgbm;
	StereoVar var;

	int color_mode = alg == STEREO_BM ? 0 : -1;
	Mat img1 = limg; 
	Mat img2 = rimg;
	
	if( scale != 1.f )
	{
		Mat temp1, temp2;
		int method = scale < 1 ? INTER_AREA : INTER_CUBIC;
		resize(img1, temp1, Size(), scale, scale, method);
		img1 = temp1;
		resize(img2, temp2, Size(), scale, scale, method);
		img2 = temp2;
	}

	Size img_size = Size(2*img1.size().width, img1.size().height);

	Rect roi1, roi2;
	Mat Q;

	M1 *= scale;
	M2 *= scale;

	Mat R1, P1, R2, P2;

	stereoRectify( M1, D1, M2, D2, img_size, R, T, R1, R2, P1, P2, Q, 0/*CALIB_ZERO_DISPARITY*/, 0, img_size, &roi1, &roi2 );

	FileStorage fs(qmatfile, CV_STORAGE_WRITE);
	fs << "Q" << Q;
	cout << Q << endl;

	Mat map11, map12, map21, map22;
	initUndistortRectifyMap(M1, D1, R1, P1, img_size, CV_16SC2, map11, map12);
	initUndistortRectifyMap(M2, D2, R2, P2, img_size, CV_16SC2, map21, map22);

	Mat img1r, img2r;
	namedWindow("image 1", 0);
	namedWindow("image 2", 0);
	imshow("image 1", img1);
	imshow("image 2", img2);

	remap(img1, img1r, map11, map12, INTER_LINEAR);
	remap(img2, img2r, map21, map22, INTER_LINEAR);

	img1 = img1r;
	img2 = img2r;
	imwrite("rectified1.jpg", img1);
	imwrite("rectified2.jpg", img2);

	numberOfDisparities = numberOfDisparities > 0 ? numberOfDisparities : ((img_size.width/8) + 15) & -16;

	bm.state->roi1 = roi1;
	bm.state->roi2 = roi2;
	bm.state->preFilterCap = 31;
	bm.state->SADWindowSize = SADWindowSize > 0 ? SADWindowSize : 9;
	bm.state->minDisparity = 0;
	bm.state->numberOfDisparities = numberOfDisparities;
	bm.state->textureThreshold = 10;
	bm.state->uniquenessRatio = 15;
	bm.state->speckleWindowSize = 100;
	bm.state->speckleRange = 32;
	bm.state->disp12MaxDiff = 1;

	sgbm.preFilterCap = 63;
	sgbm.SADWindowSize = SADWindowSize > 0 ? SADWindowSize : 3;

	int cn = img1.channels();

	sgbm.P1 = 8*cn*sgbm.SADWindowSize*sgbm.SADWindowSize;
	sgbm.P2 = 32*cn*sgbm.SADWindowSize*sgbm.SADWindowSize;
	sgbm.minDisparity = 0;
	sgbm.numberOfDisparities = numberOfDisparities;
	sgbm.uniquenessRatio = 10;
	sgbm.speckleWindowSize = bm.state->speckleWindowSize;
	sgbm.speckleRange = bm.state->speckleRange;
	sgbm.disp12MaxDiff = 1;
	sgbm.fullDP = alg == STEREO_HH;

	var.levels = 4;                                 // ignored with USE_AUTO_PARAMS
	var.pyrScale = 0.5;                             // ignored with USE_AUTO_PARAMS
	var.nIt = 25;
	var.minDisp = -numberOfDisparities;
	var.maxDisp = 0;
	var.poly_n = 7;
	var.poly_sigma = 1.5;
	var.fi = 15.0f;
	var.lambda = 0.03f;
	var.penalization = var.PENALIZATION_TICHONOV;   // ignored with USE_AUTO_PARAMS
	var.cycle = var.CYCLE_V;                        // ignored with USE_AUTO_PARAMS
	var.flags = var.USE_SMART_ID | var.USE_AUTO_PARAMS | var.USE_INITIAL_DISPARITY | var.USE_MEDIAN_FILTERING ;

	Mat disp, disp8;

	int64 t = getTickCount();
	if( alg == STEREO_BM )
		bm(img1, img2, disp);
	else if( alg == STEREO_VAR ) {
		var(img1, img2, disp);
	}
	else if( alg == STEREO_SGBM || alg == STEREO_HH )
		sgbm(img1, img2, disp);
	t = getTickCount() - t;
	printf("Time elapsed: %fms\n", t*1000/getTickFrequency());

	if( alg != STEREO_VAR )
		disp.convertTo(disp8, CV_8U, 255/(numberOfDisparities*16.));
	else
		disp.convertTo(disp8, CV_8U);

	namedWindow("left", 0);
	imshow("left", img1);
	namedWindow("right", 0);
	imshow("right", img2);
	namedWindow("disparity", 0);
	imshow("disparity", disp8);
	printf("press any key to continue...");
	fflush(stdout);
	printf("\n");

	if(disparity_filename)
		imwrite(disparity_filename, disp8);

	if(point_cloud_filename)
	{
		printf("storing the point cloud...");
		fflush(stdout);
		Mat xyz;
		reprojectImageTo3D(disp, xyz, Q, true);
		saveXYZ(point_cloud_filename, xyz);
		printf("\n");
	}

}
