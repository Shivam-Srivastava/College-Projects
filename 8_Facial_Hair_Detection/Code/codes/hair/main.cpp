#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <cmath>
#include <vector>

#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include "2d_hair_reconstruct.hpp"

using namespace std;
using namespace cv;

Mat src, src_gray;
Mat dst, detected_edges;

int edgeThresh = 1;
int lowThreshold;
int const max_lowThreshold = 100;
int ratio = 3;
int kernel_size = 3;
char* window_name = "Edge Map";

void CannyThreshold(int, void*)
{
	blur( src, detected_edges, Size(3,3) );
	Canny( detected_edges, detected_edges, lowThreshold, lowThreshold*ratio, kernel_size );
	dst = Scalar::all(0);
	src.copyTo( dst, detected_edges);
	imshow( window_name, dst );
}

/* 
 * Input format:
 * image.jpg
 */
int main(int argc, char** argv)
{
	if(argc < 2)
	{
		cout << "Invalid input parameter" << endl;
		return 1;
	}

	Mat img = imread(argv[1]); 
	//Mat img = Mat(Size(ip_img.rows, ip_img.cols), CV_8UC3);
	//Point2f pt = Point2f(ip_img.cols/2, ip_img.rows/2);
	//Mat r = getRotationMatrix2D(pt, 90, 1.0);
	//warpAffine(ip_img, img, r, img.size());

	namedWindow("orig", 0);
	imshow("orig", img);

	Mat hsvimg = Mat(img.size(), CV_8UC3);
	namedWindow("hsv", 0);
	imshow("hsv", hsvimg);

	cvtColor(img, hsvimg, CV_BGR2HSV);
	vector<Mat> mv;
	split(hsvimg, mv);

	Mat simg = mv[1], vimg = mv[2];

	namedWindow("saturation", 0);
	namedWindow("value", 0);
	imshow("saturation", simg);
	imshow("value", vimg);
	
	imwrite("s.jpg", simg);
	imwrite("v.jpg", vimg);

	Mat kernel;
	vector<Mat> vouts(18);
	vector<Mat> souts(18);
	Mat F = Mat::zeros(img.size(), CV_32FC1), O = Mat::zeros(img.size(), CV_8UC1);
	double* maxi = (double*)malloc(sizeof(double));
	double* mini = (double*)malloc(sizeof(double));

	Mat vimg1 = Mat(vimg.size(), CV_32FC1);
	Mat simg1 = Mat(simg.size(), CV_32FC1);

	for(int j = 0; j < vimg.rows; j++)
		for(int k = 0; k < vimg.cols; k++)
		{
			vimg1.at<float>(j, k) = ((float)vimg.at<uchar>(j, k))/255.0f;
			simg1.at<float>(j, k) = ((float)simg.at<uchar>(j, k))/255.0f;
		}

	for(int i = 0; i < 12; i++)
	{
		kernel = getGaborKernel(Size(3, 3), 3, 15*i, 4, 1);
		filter2D(vimg1, vouts[i], CV_32F, kernel);
		filter2D(simg1, souts[i], CV_32F, kernel);
		Mat timg = vouts[i] + souts[i];

		Mat Fnew = Mat::zeros(img.size(), CV_32FC1);
		max(F, timg, Fnew);
		minMaxIdx(timg, NULL, maxi);
		cout << "max value is : " << *maxi << endl;

		//namedWindow("tempimg", 0);
		//imshow("tempimg", Fnew);
		//waitKey(0);

		for(int j = 0; j < F.rows; j++)
			for(int k = 0; k < F.cols; k++)
			{
				if(Fnew.at<float>(j, k) > F.at<float>(j, k))
					O.at<uchar>(j, k) = 15*i;
				F.at<float>(j, k) = Fnew.at<float>(j, k);
			}
		cout << "Done with orientation " << i << endl;
	}
	
	minMaxIdx(F, mini, maxi);
	F = F - *mini;
	F = 255*(F / (*maxi - *mini));

	namedWindow("fmap", 0);
	imshow("fmap", F);
	imwrite("fmap.jpg", F);
	
	for(int j = 0; j < F.rows; j++)
		for(int k = 0; k < F.cols; k++)
		{
			int angle = O.at<uchar>(j, k);
			Point p1, p2;
			
			switch((angle+15) / 45)
			{
				case 0:
					p1 = Point(k, j-1);
					p2 = Point(k, j+1);
					break;

				case 1:
					p1 = Point(k-1, j-1);
					p2 = Point(k+1, j+1);
					break;
				
				case 2:
					p1 = Point(k-1, j);
					p2 = Point(k+1, j);
					break;

				case 3:
					p1 = Point(k-1, j+1);
					p2 = Point(k+1, j-1);
					break;

				default:
					p1 = Point(k, j-1);
					p2 = Point(k, j+1);
					
			}

			bool suppress = false;

			if(p1.x >= 0 && p1.x < F.cols && p1.y >= 0 && p1.y < F.rows)
			{
				if(F.at<float>(j, k) <= F.at<float>(p1.y, p1.x))
					suppress = true;
			}

			if(p2.x >= 0 && p2.x < F.cols && p2.y >= 0 && p2.y < F.rows)
			{
				if(F.at<float>(j, k) <= F.at<float>(p2.y, p2.x))
					suppress = true;
			}

			if(suppress)
			{
				F.at<float>(j, k) = 0;
			}
		}
	
	Mat cmap = Mat(F.size(), CV_8UC1);
	inRange(F, Scalar(0.05*255), Scalar(0.07*255), cmap);
	Mat tmap = Mat(F.size(), CV_8UC1);
	threshold(cmap, tmap, 5, 255, CV_THRESH_BINARY_INV);
	Mat hmap = Mat(F.size(), CV_32FC1);
	distanceTransform(tmap, hmap, CV_DIST_L2, 5);
	hmap = 1 / (1 + hmap);

	double minVal, maxVal;
	Mat draw;
	
	namedWindow("hairmap", 0);
	minMaxLoc(F, &minVal, &maxVal); //find minimum and maximum intensities
	F.convertTo(draw, CV_8U, 255.0/(maxVal - minVal), -minVal * 255.0/(maxVal - minVal));
	imshow("hairmap", draw);
	imwrite("hairmap.jpg", draw);
	
	namedWindow("omap", 0);
	imshow("omap", O);
	imwrite("omap.jpg", O);

	namedWindow("cmap", 0);
	minMaxLoc(cmap, &minVal, &maxVal); //find minimum and maximum intensities
	cmap.convertTo(draw, CV_8U, 255.0/(maxVal - minVal), -minVal * 255.0/(maxVal - minVal));
	imshow("cmap", draw);
	imwrite("cmap.jpg", draw);

	namedWindow("tmap", 0);
	imshow("tmap", tmap);
	imwrite("tmap.jpg", tmap);

	namedWindow("hmap", 0);
	minMaxLoc(hmap, &minVal, &maxVal); //find minimum and maximum intensities
	hmap.convertTo(draw, CV_8U, 255.0/(maxVal - minVal), -minVal * 255.0/(maxVal - minVal));
	imshow("hmap", draw);
	imwrite("hmap.jpg", draw);

	Mat grownHairs = growHair2D(hmap, O);
	namedWindow("grown", 0);
	imshow("grown", grownHairs);
	imwrite("grown.jpg", grownHairs);

	waitKey(0);

	return 0;	
}

