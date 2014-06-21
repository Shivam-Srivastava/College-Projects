package iitm.apl.player.ui;
public class Metric {
	
	public static int calcLeviDist(String a,String b){
		int no_rows=a.length()+1;
		int no_cols=b.length()+1;
		int cost;
		int[][] arr = new int[no_rows][no_cols];
		for(int i=0;i<no_cols;i++){
			arr[0][i]=i;
		}
		for(int i=1;i<no_rows;i++){
			arr[i][0]=i;
		}
		for(int i=1;i<no_rows;i++){
			for(int j=1;j<no_cols;j++){
				if(a.charAt(i-1)==b.charAt(j-1)) cost=0;
				else cost =1;
				arr[i][j]=min(arr[i-1][j-1]+cost,arr[i-1][j]+1,arr[i][j-1]+1);				
			}
		}
		return arr[no_rows-1][no_cols-1];
	}
	
	private static int min(int i, int j, int k) {
		if(i<j){
			if(i<k)return i;
			else return k;
		}
		else{
			if(j<k)return j;
			else return k;
		}
	}
}
