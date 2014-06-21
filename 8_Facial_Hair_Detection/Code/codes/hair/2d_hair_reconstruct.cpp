#include <math.h>
#include <cv.h>
#include <highgui.h>
#include <iostream>
#include <string>
#include <iostream>
#include <vector>
#include <stdlib.h>
#include <stdio.h>

#include "2d_hair_reconstruct.hpp"

using namespace cv;
using namespace std;

bool checkrange(double v, double l, double h)
{
	if( v >= l && v <= h)
		return true;
	return false;
}

double degtorad(double a)
{
	return (a*3.14) / 180.0;
}

/*
 * Input:
 * hairmap.jpg orientationmap.jpg outputhairfilename.jpg
 */
Mat growHair2D(Mat hmap, Mat omap)
{
	vector<Mat> out;
	Mat hairSegments(hmap.size(), CV_8UC3);
	Mat FinalHairPositions(hmap.size(), CV_8UC1);
	Mat angles(hmap.size(), CV_32FC1);

	//Stores the final hair particle positions stored using 4.1(b) algorithm
	//1 at (x,y) indicates that a hair particle is stored at (x,y)

	//Question: What is the 0 degree line relative to which the angles in omap are stored?
	//Assumption1 : No hair strand is at the edge of the picture. All of them lie within. To remove this assumption, extra
	//constraints need to be added to the loops below to ensure (x,y) is within bounds.
	//Assumption2 : The angle is assuming X-axis as the 0 degree line.
	//Assumption3: The width of the segment generated for each H(x,y) = 1 value is 2 pixels uniformly.
	for (int x = 0; x < hmap.rows; x++)
	{
		for (int y = 0; y < hmap.cols; y++)
		{
			float max_score = -100;
			int best_angle = -gamma;

			if(checkrange(hmap.at<float>(x, y), 1.0 - EPS, 1.0 + EPS))
			{
				/*
				 *ξ(dθ) =(1−|dθ|/2γ)*ψ(P(sdθ ))
				 *
				 *ψ(P) = (1/||P||) * SumOverPi((H(pi ) − ν)/(1−ν))
				 */
				//cout << "here" << endl;
				double theta = omap.at<uchar>(x, y);

				for(int i=-gamma; i<=gamma; i++)
				{
					double cangle = degtorad(theta+i);

					double psi_P = 0;

					for(int j = 0; j < growthResolution; j++)
					{
						double x1 = ceil(x + j * cos(cangle));
						double y1 = ceil(y + j * sin(cangle));

						if(!checkrange(x1, 0, hmap.rows) || !checkrange(y1, 0, hmap.cols))
							continue;
						
						//cout << "here" << endl;
						double psi_pt = (hmap.at<float>(x1, y1) - nu_threshold) / (1.0 - nu_threshold);
						psi_P += psi_pt;
					}
					psi_P /= (float)growthResolution;

					//cout << "PSI_P " << psi_P << endl;
					double score = (1.0 - ((float)abs(i) / (2.0*(double)gamma))) * psi_P;
					//cout << "SCORE " << score << endl;

					if(score > max_score)
					{
						max_score = score;
						best_angle = i;
					}
				}
				
				//cout << max_score << endl;
				if(threshold_to_acceptHair < max_score)
				{
					FinalHairPositions.at<uchar>(x, y) = 255;
					angles.at<float>(x, y) = theta + best_angle;
					//cout << "accepted" << endl;
				}
			}
			//std::cout << "Q(" << std::endl;
		}
	}

	Mat seen(hmap.size(), CV_8UC1);

	for (int x = 0; x < hmap.rows; x++)
	{
		cout << "row number: " << x << endl;
		for (int y = 0; y < hmap.cols; y++)
		{
			if(FinalHairPositions.at<uchar>(x, y) != 255)
				continue;

			int b = rand()%256, g = rand()%256, r = rand()%256;

			int x1, x2, y1, y2;

			x1 = x, y1 = y;
			int maxl = 100;

			while(FinalHairPositions.at<uchar>(x1, y1) == 255 && maxl--)
			{
				x2 = (int)ceil(x1 + growthResolution * cos(angles.at<float>(x1, y1)));
				y2 = (int)ceil(y1 + growthResolution * sin(angles.at<float>(x1, y1)));

				if(!checkrange(x2, 0, hmap.rows) || !checkrange(y2, 0, hmap.cols))
					break;
			
				line(hairSegments, Point(y1, x1), Point(y2, x2), Scalar(255, 255, 255), 1);

				x1 = x2;
				y1 = y2;
			}
			
		}
	}

	namedWindow("hair plot", 0);
	imshow("hair plot", hairSegments);
	imwrite("segments.jpg", hairSegments);
	waitKey(0);

	return FinalHairPositions;
}
