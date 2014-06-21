package entree;

/*
 * 
 * If the restaurant id input is -1, then read the attribute values of the ideal restaurant
 * entered by the user at the beginning.
 * The user gives the weights to each of the 6 attributes initially. These weights are used for both the similarity functions. 
 * Two kinds of similarity measures have been defined.
 * Similarity with flag = 0, is used only at the time the user enters the program.
 * Similarity with flag = 1, otherwise.
 * 0 - cheaper
 * 1 - nicer
 * 2 - traditional
 * 3 - creative
 * 4 - lively
 * 5 - quieter
 */
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;
import java.io.*;

public class Similarity_measure {
	public static String[] feature_map = new String[257];
	public static float[][] S_data = new float[676][6];
	public static int[][] cuisine_data = new int[676][30];//Assuming no restaurant has more than 20 fields
	public static float cheap = (float) 0.3,wt_cheap = 1; 
	public static float nice = (float) 0.3,wt_nice = 1;
	public static float traditional = (float) 0.3, wt_traditional = 1;
	public static float creative = (float) 0.3, wt_creative = 1;
	public static float lively = (float) 0.3,wt_lively = 1;
	public static float quiet = (float) 0.3, wt_quiet = 1;
	public static float[] numeric_normalization = new float[6];
/*	public static void main(String[] args) throws IOException{
		
		//Take the file input of the Skanda's file.
		read_S_file();
		get_normalization();
		//Take cuisine data input from file.
		read_Cuisine_file();
		read_feature_map();
		take_inputs();
		Scanner in = new Scanner(System.in);
		System.out.println("Enter restaurant IDs:");
		int restaurantID1 = in.nextInt();
		int restaurantID2 = in.nextInt();
		System.out.println("Similarity between restaurant "+restaurantID1+" and restaurant "+restaurantID2+" is "+disimilarity(restaurantID1,restaurantID2,0));
		System.out.println("Similarity between restaurant "+restaurantID1+ " and restaurant "+restaurantID2+ " is "+disimilarity(restaurantID1,restaurantID2,1));
	}*/

	public double[][]  getDsim(ArrayList<Integer> restId) throws IOException{
		
		double[][] disMat = new double[restId.size()][restId.size()];
		
		read_S_file();
		get_normalization();
		read_Cuisine_file();
		read_feature_map();
		
		for(int i = 0; i<restId.size(); i++){
			for(int j = 0; j<restId.size(); j++){
				disMat[i][j] = disimilarity(restId.get(i),restId.get(j),1);
			}
		}	
		return disMat;
		
	}
	
	private static void read_feature_map() throws IOException {
		
		BufferedReader reader = new BufferedReader(new FileReader("/home/panks/workspace/MDS/data/features.txt"));
		String line = null;
		while ((line = reader.readLine()) != null) {
			feature_map[Integer.parseInt(line.substring(0,line.indexOf('\t')))] = line.substring(line.indexOf('\t')+1);
		}
		
	}

	private static void get_normalization() {
		for(int k=0;k<6;k++){
			float normalized_term = (float)0.0;
			for(int i=1;i<676;i++){
				for(int j=0;j<i;j++){
					normalized_term+= Math.abs(S_data[i][k]-S_data[j][k]);
				}
			}
			numeric_normalization[k] = normalized_term;
		}
	}

	public static boolean isNumeric(String str)  
	{  
	  try  
	  {  
	    double d = Double.parseDouble(str);  
	  }  
	  catch(NumberFormatException nfe)  
	  {  
	    return false;  
	  }  
	  return true;  
	}
	
	public static void read_S_file() throws IOException{
		BufferedReader reader = new BufferedReader(new FileReader("/home/panks/workspace/MDS/data/S_data.txt"));
		String line = null;
		int counter = 0;
		while ((line = reader.readLine()) != null) {
			String[] splitStr = line.split("\\s+");
			S_data[counter][0] = Float.parseFloat(splitStr[0]);
			S_data[counter][1] = Float.parseFloat(splitStr[1]);
			S_data[counter][2] = Float.parseFloat(splitStr[2]);
			S_data[counter][3] = Float.parseFloat(splitStr[3]);
			S_data[counter][4] = Float.parseFloat(splitStr[4]);
			S_data[counter][5] = Float.parseFloat(splitStr[5]);
			counter++;
		}
	}
	public static void read_Cuisine_file() throws IOException{
		BufferedReader reader = new BufferedReader(new FileReader("/home/panks/workspace/MDS/data/chicago.txt"));
		String line = null;
		int counter = 0;
		while ((line = reader.readLine()) != null) {
			String[] splitStr = line.split("\\s+");
			for(int i=2;i<32;i++){
				if(i<splitStr.length){
					if(isNumeric(splitStr[i]))
						cuisine_data[counter][i-2] = Integer.parseInt(splitStr[i]);
				}
				else{
					cuisine_data[counter][i-2] = -1;
				}
			}
			counter++;
		}
	}
	//Take ideal restaurant attributes
	public static void take_inputs(){
		Scanner in = new Scanner(System.in);
		System.out.println("Input the ideal restaurant attributes:");
		System.out.print("Cheap: "); cheap = in.nextFloat();
		System.out.print("Nice: "); nice = in.nextFloat();
		System.out.print("Traditional: "); traditional = in.nextFloat();
		System.out.print("creative: "); creative = in.nextFloat();
		System.out.print("Lively: "); lively = in.nextFloat();
		System.out.print("Quiet: "); quiet = in.nextFloat();
		
		System.out.println("Input the attributes weights:");
		System.out.print("Weight for Cheap: "); wt_cheap = in.nextFloat();
		System.out.print("Weight for Nice: "); wt_nice = in.nextFloat();
		System.out.print("Weight for Traditional: "); wt_traditional = in.nextFloat();
		System.out.print("Weight for creative: "); wt_creative = in.nextFloat();
		System.out.print("Weight for Lively: "); wt_lively = in.nextFloat();
		System.out.print("Weight for Quiet: "); wt_quiet = in.nextFloat();
	}
	
	//Here, take only the six attribute values for measuring the similarity between rest1 and rest2.
	//If either of the rest1 or rest2 is -1, then check for the ideal restaurant values.
	public static float disimilarity(int rest1, int rest2, int flag)
	{
		if(rest1<-1||rest2<-1){
			System.out.println("Enter correct restaurant IDs. Exiting.");
			System.exit(1);
		}
		
		float cheap1,cheap2, nice1, nice2, traditional1, traditional2, creative1,creative2,lively1, lively2, quieter1, quieter2;
		float disSim_cheap,disSim_nice,disSim_trad,disSim_creative,disSim_lively,disSim_quieter;
		if(rest1==rest2)
			return 0;
		
		else if(rest1==-1||rest2==-1){
			if(rest1==-1){
				cheap1 = cheap; nice1 = nice; traditional1 = traditional;
				creative1 = creative; lively1 = lively; quieter1 = quiet;
				
				cheap2 = S_data[rest2][0];nice2 = S_data[rest2][1];traditional2 = S_data[rest2][2];
				creative2 = S_data[rest2][3];lively2 = S_data[rest2][4];quieter2 = S_data[rest2][5];
				
			}
			else{
				cheap2 = cheap; nice2 = nice; traditional2 = traditional; 
				creative2 = creative; lively2 = lively; quieter2 = quiet;
				
				cheap1 = S_data[rest1][0];nice1 = S_data[rest1][1];traditional1 = S_data[rest1][2];
				creative1 = S_data[rest1][3];lively1 = S_data[rest1][4];quieter1 = S_data[rest1][5];
			}
		}
		
		else{
			cheap1 = S_data[rest1][0];nice1 = S_data[rest1][1];traditional1 = S_data[rest1][2];
			creative1 = S_data[rest1][3];lively1 = S_data[rest1][4];quieter1 = S_data[rest1][5];
			
			cheap2 = S_data[rest2][0];nice2 = S_data[rest2][1];traditional2 = S_data[rest2][2];
			creative2 = S_data[rest2][3];lively2 = S_data[rest2][4];quieter2 = S_data[rest2][5];
		}
		disSim_cheap = Math.abs(cheap1 - cheap2)/(numeric_normalization[0]/(338*675));
		disSim_nice = Math.abs(nice1 - nice2)/(numeric_normalization[1]/(338*675));
		disSim_trad = Math.abs(traditional1 - traditional2)/(numeric_normalization[2]/(338*675));
		disSim_creative = Math.abs(creative1 - creative2)/(numeric_normalization[3]/(338*675));
		disSim_lively = Math.abs(lively1 - lively2)/(numeric_normalization[4]/(338*675));
		disSim_quieter = Math.abs(quieter1 - quieter2)/(numeric_normalization[5]/(338*675));
		
		float disSim_Numerator = (disSim_cheap*wt_cheap + disSim_nice*wt_nice + disSim_trad*wt_traditional+disSim_creative*wt_creative+disSim_lively*wt_lively+disSim_quieter*wt_quiet);
		if(flag==0||rest1==-1||rest2==-1){//Only numeric dissimilarity
			return disSim_Numerator/(wt_cheap+wt_nice+wt_traditional+wt_creative+wt_lively+wt_quiet);
		}
		else{
			return (disSim_Numerator+intersection_cuisine(rest1,rest2))/(wt_cheap+wt_nice+wt_traditional+wt_creative+wt_lively+wt_quiet+1);//extra 1 for categorical variable
		}
	}

	private static float intersection_cuisine(int rest1, int rest2) {
		int intersection_count = 0;
		HashMap<Integer, Integer> h = new HashMap<Integer,Integer>();
		for(int i=0;i<30;i++){
			h.put(cuisine_data[rest1][i],1);
		}
		for(int i=0;i<30;i++){
			if((cuisine_data[rest2][i]!=-1)&&h.containsKey(cuisine_data[rest2][i])){
//				System.out.println("Feature matched:"+cuisine_data[rest2][i]);
//				System.out.println("Feature is:"+feature_map[cuisine_data[rest2][i]]);
				intersection_count+=1;
			}
		}
		return intersection_count;
	}
}
