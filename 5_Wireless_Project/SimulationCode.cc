//File taken from lena-intercell-interference.cc
//Some parts have been removed/commented to suit our needs.


#include <fstream>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "ns3/lte-helper.h"
#include "ns3/epc-helper.h"
#include "ns3/ipv4-global-routing-helper.h"
#include "ns3/internet-module.h"
#include "ns3/applications-module.h"
#include "ns3/point-to-point-helper.h"
#include "ns3/on-off-helper.h"

#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/mobility-module.h"
#include "ns3/lte-module.h"
#include "ns3/config-store.h"
#include "ns3/radio-bearer-stats-calculator.h"
#include "ns3/random-variable.h"

#include <iomanip>
#include <string>
#include <time.h>
//3.98*E^(-21) Watts = -174dbm
//19.952Watts = 43dbm

#define TOTAL_SIM_TIME 10//10 hours
#define TIME_INTERVAL 0.2//0.2 hour = 10 mins
#define HIGH_BITRATE 20//TODO:Bitrates in Mbps, try different values
#define LOW_BITRATE 0.750//TODO:Bitrate in Mbps, try different values
#define SUBCHANNELS 128
#define TOTAL_BANDWIDTH 0.2//This is in MHz. Try with 5MHz or 10MHz
#define BANDWIDTH_EACH_SUBCHANNEL 2//TODO:try different values
#define CALL_ARRIVAL_MEAN (float)40/60//In hours. Assuming 20 calls come in 1 hour
#define CALL_HOLD_MEAN (float)50/60//In hours. Assuming each caller holds the call on an average for 2 minutes
#define MBS_SINR_NUM 43//In dbm
#define SIGMA_NOISE -174//TODO: There is an extra term.
#define NOISE_POWER 21//
using namespace ns3;

/**
 * This simulation script creates two eNodeBs and drops randomly several UEs in
 * a disc around them (same number on both). The number of UEs , the radius of
 * that disc and the distance between the eNodeBs can be configured.
 */
	float *logOnePlusSINR;
	float *fairBwAllocThpt;
	float *sinrForUsers;//Initialized to zero right now.
	float *equalBwAllocThpt;//ith value is the averge thpt over all the user's thpt
	int noOfSamples;// = TOTAL_SIM_TIME/TIME_INTERVAL
	int **onOffUsersSample;//[i][j] = 1 if the ith user is active on the jth sample. Else it is = 0.
	int **callExtended;//Is = 1 if the call is extended over many samples together
	float **bitRateRequest;// [i][j] = -1 if the ith user is inactive at the jth sample.
											  // [i][j] = (+ve value) allocated using the Pareto distribution

double convertDbmToWatt(double dbmValue){
	double wattValue = 0;
	wattValue = pow(10.0,dbmValue/10)/1000;
	return wattValue;
}
void initializeArrays(int numUes, int noOfSamples){
	int index, innerIndex;
	logOnePlusSINR = (float*)malloc(numUes*sizeof(float));
	fairBwAllocThpt = (float*)malloc(noOfSamples*sizeof(float));
	equalBwAllocThpt = (float*)malloc(noOfSamples*sizeof(float));
	sinrForUsers = (float*)malloc(numUes*sizeof(float));
	onOffUsersSample = (int**)malloc(numUes*sizeof(int*));
	callExtended = (int**)malloc(numUes*sizeof(int*));
	bitRateRequest = (float**)malloc(numUes*sizeof(float*));
	for(index=0;index<numUes;index++){
		logOnePlusSINR[index] = 0;
		equalBwAllocThpt[index] = 0;
		sinrForUsers[index] = 0;
		onOffUsersSample[index] = (int*)malloc(noOfSamples*sizeof(int));
		callExtended[index] = (int*)malloc((noOfSamples-1)*sizeof(int));
		bitRateRequest[index] = (float*)malloc(noOfSamples*sizeof(float));
		for(innerIndex=0;innerIndex<noOfSamples;innerIndex++){
			onOffUsersSample[index][innerIndex] = 0;
			if(innerIndex<noOfSamples-1)
				callExtended[index][innerIndex] = 0;
			bitRateRequest[index][innerIndex] = -1;//Indicating no bitrate request.
		}
	}
}
static Vector GetPosition (Ptr<Node> node)
{
	Ptr<MobilityModel> mobility = node->GetObject<MobilityModel> ();
	return mobility->GetPosition ();
}
float getNextPareto(){
//TODO: Assign various values 4-5
	int randNo = rand()%10000;
	if(randNo<2000)
		return HIGH_BITRATE;
	else if(randNo>=2000&&randNo<2100)
		return 0.8*HIGH_BITRATE + 0.2*LOW_BITRATE;
	else if(randNo>=2100&&randNo<2200)
		return 0.6*HIGH_BITRATE+0.4*LOW_BITRATE;
	else if(randNo>=2200&&randNo<2250)
		return 0.4*HIGH_BITRATE+0.6*LOW_BITRATE;
	else
		return LOW_BITRATE;
}
double getFairBw(int userNo, int noOfUsers){
	double sumOfLogOnePlusSINR = 0;
	int index=0;
	for(index=0;index<noOfUsers; index++){
		sumOfLogOnePlusSINR+=1/logOnePlusSINR[index];
	}
	return (TOTAL_BANDWIDTH)/sumOfLogOnePlusSINR*logOnePlusSINR[userNo];
}
int main (int argc, char *argv[])
{
	noOfSamples = TOTAL_SIM_TIME/TIME_INTERVAL;
//double enbDist = 100.0; Not needed as we have only one ENB node
	double radius = 100.0;//TODO: 100 meters
	int numUes = 20;//TODO:= 20 
	

	initializeArrays(numUes,noOfSamples);


	SeedManager::SetSeed(time(NULL));

	CommandLine cmd;
	//cmd.AddValue ("enbDist", "distance between the two eNBs", enbDist);// Commented because enbDist is not needed
	cmd.AddValue ("radius", "the radius of the disc where UEs are placed around an eNB", radius);
	cmd.AddValue ("numUes", "how many UEs are attached to each eNB", numUes);
	cmd.Parse (argc, argv);

	ConfigStore inputConfig;
	inputConfig.ConfigureDefaults ();

	// parse again so you can override default values from the command line
	cmd.Parse (argc, argv);

	// determine the string tag that identifies this simulation run
	// this tag is then appended to all filenames

	IntegerValue runValue;
	GlobalValue::GetValueByName ("RngRun", runValue);

	std::ostringstream tag;
	tag  //<< "_enbDist" << std::setw (3) << std::setfill ('0') << std::fixed << std::setprecision (0) << enbDist//endDist not needed
		<< "_radius"  << std::setw (3) << std::setfill ('0') << std::fixed << std::setprecision (0) << radius
		<< "_numUes"  << std::setw (3) << std::setfill ('0')  << numUes
		<< "_rngRun"  << std::setw (3) << std::setfill ('0')  << runValue.Get () ;

	Ptr<LteHelper> lteHelper = CreateObject<LteHelper> ();//Helps set up the topology and its components
  
	lteHelper->SetAttribute ("PathlossModel", StringValue ("ns3::FriisSpectrumPropagationLossModel"));//May need to change this not sure.

	// Create Nodes: eNodeB and UE
	NodeContainer enbNodes;
	NodeContainer ueNodes1;
	enbNodes.Create (1);//Only one ENb Node needed
	ueNodes1.Create (numUes);

	// Position of eNBs
	Ptr<ListPositionAllocator> positionAlloc = CreateObject<ListPositionAllocator> ();
	positionAlloc->Add (Vector (0.0, 0.0, 0.0));//Sets the location of the EnbNode to (0,0,0)
	MobilityHelper enbMobility;
	enbMobility.SetMobilityModel ("ns3::ConstantPositionMobilityModel");//Location of the base station is constant
	enbMobility.SetPositionAllocator (positionAlloc);
	enbMobility.Install (enbNodes);

	// Position of UEs attached to eNB 1
	MobilityHelper ue1mobility;
	ue1mobility.SetPositionAllocator ("ns3::UniformDiscPositionAllocator",//Uniformly distributes the given number of users around
										"X", DoubleValue (0.0),				//This X
										"Y", DoubleValue (0.0),				//This Y
										"rho", DoubleValue (radius));		//Within a radius of 'radius'
	ue1mobility.SetMobilityModel ("ns3::ConstantPositionMobilityModel");	//The users are at a fixed position throughout the simulation
	ue1mobility.Install (ueNodes1);

  //Till now the nodes are empty with no functionality. So we add the devices to them.
  //Create Devices and install them in the Nodes (eNB and UE)
	NetDeviceContainer enbDevs;
	NetDeviceContainer ueDevs1;

	enbDevs = lteHelper->InstallEnbDevice (enbNodes);
	ueDevs1 = lteHelper->InstallUeDevice (ueNodes1);

	// Attach UEs to a eNB
	lteHelper->Attach (ueDevs1, enbDevs.Get (0));

	// Activate an EPS bearer on all UEs
	enum EpsBearer::Qci q = EpsBearer::GBR_CONV_VOICE;
	EpsBearer bearer (q);
	lteHelper->ActivateEpsBearer (ueDevs1, bearer, EpcTft::Default ());
 
	int noOfDevices = ueDevs1.GetN();
//Getting the distances of the devices for calculating their SINRs
	double SINR[noOfDevices];

	int index;
	double x,y;
//	std::cout<<convertDbmToWatt(SIGMA_NOISE + 10*log10((float)TOTAL_BANDWIDTH/SUBCHANNELS) + 60)<<" \n";
	double SINR_constant = convertDbmToWatt((float)MBS_SINR_NUM/SUBCHANNELS)/convertDbmToWatt(SIGMA_NOISE + 10*log10((float)TOTAL_BANDWIDTH/SUBCHANNELS) + 60);//60 for converting MHz
	std::cout<<"SINR_constant = "<<SINR_constant<<"\n";
	
	for(index=0; index<noOfDevices; index++){
		Ptr<NetDevice> p = ueDevs1.Get(index);
		x = (GetPosition(p->GetNode())).x;
		y = (GetPosition(p->GetNode())).y;
//		p->TraceConnectWithoutContext ("PhyRxDrop", MakeCallback (&Gen));
		std::cout<<"  X = "<<x<<" Y = "<<y;
		SINR[index] = SINR_constant*(1/(x*x+y*y));//TODO:Change the numerator
		std::cout<<"  SINR = "<<SINR[index]<<"\n\n";
		logOnePlusSINR[index] = log10(1+SINR[index]);
		std::cout<<"  logOnePlusSINR = "<<logOnePlusSINR[index]<<"\n";
	}

//	ExponentialVariable exp(1.5);
//	for(uint32_t u = 0; u < ueNodes1.GetN (); ++u){
//		std::cout<<"\nValue = "<<exp.GetValue();		
//	}  
	srand(time(NULL));
//	for(int i =0;i<10;i++){
//		int randNo = rand()%1000;
//		if(randNo<200)
//			std::cout<<"Large Bandwidth \n";
//		else{
//			std::cout<<"Smaller bandwidth \n";
//		}
//	}
  
//TIME_INTERVAL = sample_length
//TOTAL_SIM_TIME = Total Simulation Time
int innerIndex=0;//Should be = 0 initially
index=0;
ExponentialVariable intervalExpVar(CALL_ARRIVAL_MEAN);
ExponentialVariable onTimeExpVar(CALL_HOLD_MEAN);
//TODO:For On-Off for each user:
//We need to know if the ith user is requesting at the time of sampling or not.
//Make a matrix of size = noOfUsers*NoOfSamples
//While generating the on-off values ... if a user is on at a certain sampling point then set the value to 1 in the matrix, else 0
//offTime = (...] onTime = (...]
	for(index=0;index<numUes;index++){
		float currentTime = 0;//Starting from the beginning for each user
		for(innerIndex=0;innerIndex<noOfSamples;){
//			currentTime = TIME_INTERVAL*innerIndex;//At t=0 all will be off so it is not counted as a sample. Hence offTime = (...]

			float offTime = intervalExpVar.GetValue();
			for(float temp = currentTime; temp<=currentTime+offTime; temp+=TIME_INTERVAL){
				if(temp<((innerIndex+1)*TIME_INTERVAL)&&((innerIndex+1)*TIME_INTERVAL)<=currentTime+offTime)//if the next sample falls within the off window then set it as 0
				{
					onOffUsersSample[index][innerIndex] = 0;
					innerIndex++;
				}
			}
			currentTime = currentTime+offTime;
			float onTime = onTimeExpVar.GetValue();
			for(float temp = currentTime; temp<=currentTime+onTime; temp+=TIME_INTERVAL){
				if(temp<((innerIndex+1)*TIME_INTERVAL)&&((innerIndex+1)*TIME_INTERVAL)<=currentTime+onTime)//if the next sample falls within the on window then set it as 0
				{
					onOffUsersSample[index][innerIndex] = 1;
					innerIndex++;
				}
			}
			currentTime = currentTime+onTime;		
		}
	}

//TODO:For pareto:
//Generate a 2-d array of integers. Size = NoOfSamples*NoOfUsers
//For each Sample
//For each user
//Get a number from the 20-80 Pareto Distribution and store it
	for(index=0;index<noOfSamples;index++){
		for(innerIndex=0; innerIndex<numUes; innerIndex++){
			if(onOffUsersSample[innerIndex][index]==0){
				bitRateRequest[innerIndex][index] = -1;
				std::cout<<"-1 ";
			}
			else{
				bitRateRequest[innerIndex][index] = getNextPareto();
				std::cout<<bitRateRequest[innerIndex][index]<<" ";
			}
		}
		std::cout<<"\n";
	}

	
//TODO: Allocating without the metric:
//Just allocate each bandwidth requested as it is till the subchannels get exhausted.
	float equalBandwidth=0;
	for(index=0;index<noOfSamples;index++){
		equalBwAllocThpt[index] = 0;
		equalBandwidth=0;
		std::cout<<"For Sample "<<(index+1)<<": ";
		int noOfUsersActive=0;
		for(innerIndex=0;innerIndex<numUes;innerIndex++){
			if(bitRateRequest[innerIndex][index]>0)			
				noOfUsersActive++;
		}
		if(noOfUsersActive>0)
			equalBandwidth = TOTAL_BANDWIDTH/(float)noOfUsersActive;
		for(innerIndex=0;innerIndex<numUes;innerIndex++){
			if(bitRateRequest[innerIndex][index]>0){
				if(bitRateRequest[innerIndex][index]<=equalBandwidth*logOnePlusSINR[innerIndex]){
					equalBwAllocThpt[index]+=1;
					std::cout<<"1 ";
				}
				else{
					equalBwAllocThpt[index]+=(equalBandwidth*logOnePlusSINR[innerIndex]/bitRateRequest[innerIndex][index]);
					std::cout<<(equalBandwidth*logOnePlusSINR[innerIndex]/bitRateRequest[innerIndex][index])<<" ";
				}
			}
		}
		std::cout<<"Total thpt:"<<equalBwAllocThpt[index]<<" \n";
		if(noOfUsersActive>0)
			equalBwAllocThpt[index]/=(float)noOfUsersActive;
		else
			equalBwAllocThpt[index] = 1;
		std::cout<<"\n";
	}
	for(index=0;index<noOfSamples;index++){
		std::cout<<"For sample "<<(index+1)<<" ";
		std::cout<<equalBwAllocThpt[index]<<" \n";
	}
//TODO: Use our fairness metric and allocate the resources
	


	for(index=0;index<noOfSamples;index++){
		fairBwAllocThpt[index] = 0;
		std::cout<<"For Sample "<<(index+1)<<": ";
		int noOfUsersActive=0;
		for(innerIndex=0;innerIndex<numUes;innerIndex++){
			if(bitRateRequest[innerIndex][index]>0)			
				noOfUsersActive++;
		}
		for(innerIndex=0;innerIndex<numUes;innerIndex++){
			if(bitRateRequest[innerIndex][index]>0){
				if(bitRateRequest[innerIndex][index]<=getFairBw(innerIndex,numUes)*logOnePlusSINR[innerIndex]){
					fairBwAllocThpt[index]+=1;
					std::cout<<"1 ";
				}
				else{
					fairBwAllocThpt[index]+=(getFairBw(innerIndex,numUes)*logOnePlusSINR[innerIndex]/bitRateRequest[innerIndex][index]);
					std::cout<<(getFairBw(innerIndex,numUes)*logOnePlusSINR[innerIndex]/bitRateRequest[innerIndex][index])<<" ";
				}
			}
		}
		std::cout<<"Total thpt:"<<fairBwAllocThpt[index]<<" \n";
		if(noOfUsersActive>0)
			fairBwAllocThpt[index]/=(float)noOfUsersActive;
		else
			fairBwAllocThpt[index] = 1;
		std::cout<<"\n";
	}

for(index=0;index<noOfSamples;index++){
		std::cout<<"For sample "<<(index+1)<<" ";
		std::cout<<fairBwAllocThpt[index]<<" \n";
	}

  return 0;
}
