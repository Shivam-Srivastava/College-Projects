public class TetrominoeMove {
int tetrominoe = -1;
int[] blocksCovered = new int[4];
public TetrominoeMove(int t, int[] coveredBlocks){
	tetrominoe = t;
	blocksCovered = coveredBlocks;
	
}
public void print(){
	System.out.print("Tetrominoe : "+this.tetrominoe);
	for(int i =0;i<4;i++){
		System.out.print(" "+this.blocksCovered[i]+" ");
	}
	System.out.println();
}
}
