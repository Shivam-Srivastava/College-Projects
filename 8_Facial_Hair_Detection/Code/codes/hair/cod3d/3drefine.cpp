#include <iostream>
#include <stdio.h>
#include <vector>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include "hair.hpp"

using namespace std;
using namespace cv;

vector<Hair> removeLowConfidenceConn(vector<Hair> hair)
{
	vector<Hair> outhair;

	for(int i = 0; i < hair.size(); i++)
	{
		Hair h = hair[i];
		vector<HairSegment> segments = h.m_segments;
		HairSegment ps = segments[0];

		for(int j = 1; j < segments.size; j++)
		{

		}
	}
}

vector<Hair> addConn(vector<Hair> hair)
{
	vector<Hair> outhair;

	for(int i = 0; i < hair.size(); i++)
	{
		
	}
}

vector<Hair> fixMap(vector<Hair> hair, vector<Mat> masks, vector<Mat> Qmats)
{
	vector<Hair> outhair;

	for(int i = 0; i < hair.size(); i++)
	{
		
	}
}



