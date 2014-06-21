package entree;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Scanner;

import mdsj.MDSJ;

public class MDS {
	public static void main(String[] args) throws IOException {
		
		double[][] input = {{4.728829042011413811e-03,1.779362762503662035e-03,1.325882823784876700e-03,3.686990244682524474e-03,6.583765555204131037e-04,9.426943253193375465e-04},
				{3.346507126795580304e-04,2.694441698696371595e-04,4.609198596827576082e-04,3.865922797192875016e-04,3.709942625376450856e-04,5.095645001726107964e-04}};//{{1,1,1,1,0,1},{1,1,0,1,1,0}};
		//PrintWriter out = new PrintWriter(new FileWriter("/home/panks/workspace/MDSJExample/bin/output2")); 
		
		double[][] output=MDSJ.classicalScaling(input); 

		for(int i=0; i<output[0].length; i++) {  // output all coordinates
			System.out.println(": " +output[0][i]+", "+output[1][i]);
		    //out.write(i + " " +output[0][i]+" "+output[1][i]);
		    //out.write("\n");
		}	
		
	}
}