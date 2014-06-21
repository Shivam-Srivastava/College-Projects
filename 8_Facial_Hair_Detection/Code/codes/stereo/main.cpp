#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <cmath>

#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include "stereo_match.hpp"

using namespace std;
using namespace cv;

void readCamFile(char* filename, Mat &M, Mat &D, Mat &R, Mat &T)
{
	// initializations
	M = Mat::eye(3, 3, CV_64FC1);
	D = Mat::zeros(1, 5, CV_64FC1);
	R = Mat::eye(3, 3, CV_64FC1);
	T = Mat::zeros(3, 1, CV_64FC1);
	Mat rotvec = Mat::zeros(3, 1, CV_64FC1);

	FILE* fp = fopen(filename, "r");
	double alpha, nx, ny;

	char str[500];
	
	// parse file
	fgets(str, 499, fp);
	
	// intrinsic matrix
	fscanf(fp, "%s %lf %lf %lf %lf %lf", str, &M.at<double>(0, 0), &M.at<double>(1, 1), &M.at<double>(0, 2), &M.at<double>(1, 2), &alpha);
	M.at<double>(0, 1) = M.at<double>(1, 1) * tan(alpha);
	
	// image size
	fscanf(fp, "%lf %lf", &nx, &ny);

	// distortion coefficients
	fscanf(fp, "%lf %lf %lf %lf %lf", &D.at<double>(0, 0), &D.at<double>(0, 1), &D.at<double>(0, 2), &D.at<double>(0, 3), &D.at<double>(0, 4));

	// translation vector
	fscanf(fp, "%lf %lf %lf", &T.at<double>(0, 0), &T.at<double>(0, 1), &T.at<double>(0, 2));

	// rotation vector
	fscanf(fp, "%lf %lf %lf", &rotvec.at<double>(0, 0), &rotvec.at<double>(0, 1), &rotvec.at<double>(0, 2));

	// rotation matrix computation
	Rodrigues(rotvec, R);	
}

Mat rotateImg(Mat img)
{
	Mat out = Mat(Size(img.rows, img.cols), img.type());

	for(int i = 0; i < img.rows; i++)
	{
		for(int j = 0; j < img.cols; j++)
		{
			out.at<Vec3b>(j, img.rows - 1 - i) = img.at<Vec3b>(i, j);
		}
	}

	return out;
}

/* 
 * Input format:
 * left.jpg leftcam.cam right.jpg rightcam.cam disparityout.jpg pointcloudout.txt qmat.xml
 */
int main(int argc, char** argv)
{
	if(argc < 6)
	{
		cout << "Invalid input parameter" << endl;
		return 1;
	}

	cout << argv[1] << endl;
	cout << argv[3] << endl;

	Mat leftimg, rightimg, loadedimg;
	
	loadedimg = imread(argv[1]);
	//if(loadedimg.cols > loadedimg.rows)
	//	leftimg = rotateImg(loadedimg);
	//else
		leftimg = loadedimg;
	
	loadedimg = imread(argv[3]);
	//if(loadedimg.cols > loadedimg.rows)
	//	rightimg = rotateImg(loadedimg);
	//else
		rightimg = loadedimg;

	cout << leftimg.cols << " " << leftimg.rows << endl;
	cout << rightimg.cols << " " << rightimg.rows << endl;

	Mat limg, rimg;
	resize(leftimg, limg, Size(leftimg.cols/2, leftimg.rows/2));
	resize(rightimg, rimg, Size(rightimg.cols/2, rightimg.rows/2));

	vector<Mat> l, r;
	split(limg, l);
	split(rimg, r);

	Mat M1, D1, M2, D2, R1, T1, R2, T2;
	readCamFile(argv[2], M1, D1, R1, T1);
	readCamFile(argv[4], M2, D2, R2, T2);
	
	cout << M1 << endl << D1 << endl << R1 << endl << T1 << endl;
	
	Mat R = R1 * R2.t();
	Mat T = T1 - R * T2;

	stereo_match(r[1], l[1], M2, M1, D2, D1, R, T, argv[5], argv[6], argv[7]);
	
	return 0;	
}

