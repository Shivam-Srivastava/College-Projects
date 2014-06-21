
public class DisplayBoard {
	int m,n;
	int[][] board;
	public DisplayBoard(int rows, int columns, int[][] inputBoard){
		m = rows;
		n = columns;
		board = inputBoard;
	}
	public void drawBoard(){
		int i,j;
		for(i = 0;i<n;i++){
			if(board[0][i]>=0)
				System.out.print(" _");
			else
				System.out.print("  ");
		}
		System.out.println();
		for(i = 0;i<m;i++){
			for(j = 0;j<n;j++){
				if(board[i][j]>=0)
					System.out.print("|_");
				else{
					if(j>0){
						if(board[i][j-1]>=0){
							if(i<m-1){
							if(board[i+1][j]>=0)
								System.out.print("|_");
							else
								System.out.print("| ");
							}
							else
								System.out.print("| ");
						
						}
						else{
							if(i<m-1){
							if(board[i+1][j]>=0)
								System.out.print(" _");
							else
								System.out.print("  ");
							}
							else
								System.out.print("  ");
						
					}
					}
					
					else{
						if(i<m-1){
							if(board[i+1][j]>=0)
							System.out.print(" _");
							else
								System.out.print("  ");
						}
						else
							System.out.print("  ");
					}
						
						
				}
				if(j==n-1&&board[i][j]>=0)
					System.out.print("|");
			}
			System.out.println();
		}
	}
}