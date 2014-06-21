#include <math.h>
//#include <cmath>
#include <cv.h>
#include <highgui.h>
#include <iostream>
#include <string>
#include <pcl/common/common_headers.h>
#include <pcl/io/pcd_io.h>
#include <pcl/visualization/pcl_visualizer.h>
#include <boost/thread/thread.hpp>

#define gamma 30
#define growthResolution 1 //This is the number of pixels from ps point in the chosen direction
#define nu_threshold 0.4
#define threshold_to_acceptHair 0.1

int main( int argc, char** argv )
{
	//The dimensions of HairMap and OrientationMap should be same (equal to the size of the image)
	cv::Mat HairMap(100,100,CV_32,0);//Format: rows, columns, datatype, initial value
	cv::Mat OrientationMap(100,100,CV_32,0);// Same format as above

	cv::Mat FinalHairPositions(100,100,CV_32,0);//Stores the final hair particle positions stored using 4.1(b) algorithm
	//1 at (x,y) indicates that a hair particle is stored at (x,y)

	//Question: What is the 0 degree line relative to which the angles in OrientationMap are stored?
	//Assumption1 : No hair strand is at the edge of the picture. All of them lie within. To remove this assumption, extra
	//constraints need to be added to the loops below to ensure (x,y) is within bounds.
	//Assumption2 : The angle is assuming X-axis as the 0 degree line.
	//Assumption3: The width of the segment generated for each H(x,y) = 1 value is 2 pixels uniformly.
	for (int x = 0; x < HairMap.rows; x++)
	{
		for (int y = 0; y < HairMap.cols; y++)
		{
			int max_score = 0;
			int best_x_coord = 0;
			int best_y_coord = 0;
			if(HairMap.at<double>(x,y)==1)
			{
				/*
				 *ξ(dθ) =(1−|dθ|/2γ)*ψ(P(sdθ ))
				 *
				 *ψ(P) = (1/||P||) * SumOverPi((H(pi ) − ν)/(1−ν))
				 */
				double theta = OrientationMap.at<double>(x,y);
				for(int i=-gamma;i<=gamma;i++){
					x1 = ceil(x+growthResolution*cos(theta+i));
					y1 = ceil(x+growthResolution*sin(theta+i));
					x2 = ceil(x+(growthResolution+1)*cos(theta+i));
					y2 = ceil(x+(growthResolution+1)*sin(theta+i));
					double psi_P = (1/2)*(((HairMap.at<double>(x1,y1)-nu_threshold)/(1-nu_threshold))+ ((HairMap.at<double>(x2,y2)-nu_threshold)/(1-nu_threshold)));
					double score = (1 - (abs(i)/2*gamma))*psi_P;
					if(score>max_score){
						max_score = score;
						best_x_coord = x1;
						best_y_coord = y1;
					}
				}
				if(threshold_to_acceptHair<max_score){
					cvSetReal2D(FinalHairPositions, best_x_coord, best_y_coord,1);
				}
			}
			//std::cout << "Q(" << std::endl;
		}
	}
	return 0;
}
