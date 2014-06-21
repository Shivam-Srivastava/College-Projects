#include <iostream>
#include <stdio.h>
#include <vector>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace std;
using namespace cv;

typedef Point3_<double> Point3d;

class HairSegment
{
	public:
		Point3d startPoint, endPoint;
		float weight, thickness;
		Scalar c;
};

class Hair
{
	public:
		int m_id;
		bool m_valid;
		vector<HairSegment> m_segments;
};

class HairCollection
{
	public:
		int m_lastID;
		vector<Hair> m_hairs;
};
