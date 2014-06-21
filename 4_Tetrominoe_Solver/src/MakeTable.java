import java.util.Scanner;

public class MakeTable {
	static int[][] board;
	static int[] coordinateMapping;
	static int rowsFilledInTable = 0;
	static int rows,columns;
	public MakeTable(int m,int n){
		rows = m;
		columns = n;
		board = new int[m][n];
	}
	public int[][] makeTable() {
		Scanner in = new Scanner(System.in);
		int x, y;
		int noOfBlocksRemoved = 0;
		System.out.println("Which blocks should be removed? Give the 0-based (x,y) coordinates. End with -1");
		x = in.nextInt();
		while (x >= 0) {
			y = in.nextInt();
			if(board[x][y]==-1){
				System.out.println("Already removed "+x+", "+y);
				x = in.nextInt();
				continue;
			}
			System.out.println("Block Removed: "+x+", "+y);
			board[x][y] = -1;
			noOfBlocksRemoved++;
			x = in.nextInt();
		}
		int extraTiles=0;
		//extraTiles = (rows*columns - noOfBlocksRemoved)%4;
		if(extraTiles%4>0){
			//Choose some tiles to be removed
			//Choose wisely. Currently choosing the first most "extraTiles" number of tiles
			int temp = 0;
				
				for(x = 0;x<rows;x++){
					for(y = 0;y<columns;y++){
						if(temp==extraTiles)
							break;
						else if(board[x][y]>=0){
							board[x][y] = -3;//-2 is being used in some function below
							temp++;
						}
					}
				}
				
				
				
			
		}
		
		
		coordinateMapping = new int[rows*columns - noOfBlocksRemoved-extraTiles];//extraTiles are removed if there are any
		System.out.println("Number of tiles left: "+coordinateMapping.length);
		int assignedCellNumber = 0;
		int counter = 0;
		for(x = 0;x<rows;x++){
			for(y = 0;y<columns;y++){
				
				if(board[x][y]>=0){
					board[x][y] = assignedCellNumber;
					coordinateMapping[assignedCellNumber] = counter;
					assignedCellNumber++;
				}
				counter ++;
			}
		}
		int m = getNoRows();
		int n = rows*columns + 7 - noOfBlocksRemoved-extraTiles;
		int[][] exactCoverMatrix = new int[m][n];
		System.out.println("Dimensions of the generated exactCoverMatrix: "+m + " x " + n);
		exactCoverMatrix = fillCoverMatrix(exactCoverMatrix);
		int i,j;
		/*
		 * Enable the following commented part to see the exactCoverMatrix
		 */
/*		for(i=0;i<m;i++){
			for(j=0;j<n;j++){
				System.out.print(exactCoverMatrix[i][j]+" ");
			}
			System.out.println();
		}*/
		return exactCoverMatrix;
	}

	private static int[][] fillCoverMatrix(int[][] exactCoverMatrix) {

		rowsFilledInTable = 0;
		// Iterate over all blocks
		// For each block fill the rows as long as there are unique ways in
		// which it can be placed
		// For the above use the getRows function's logic
		int i = 0, j, k;
		for (i = 0; i < 7; i++) {

			for (j = 0; j < rows; j++) {
				for (k = 0; k < columns; k++) {
					if(board[j][k]>=0){//Evaluate only for a valid cell
						exactCoverMatrix = placeBlockInAllWays(i,j,k,exactCoverMatrix);
					}
				}

			}
		}

		return exactCoverMatrix;
	}

	private static int[][] placeBlockInAllWays(int i, int j, int k, int[][] exactCoverMatrix) {
		int noOfLiveCellsInBoard = 0;
		if(exactCoverMatrix.length>0)
		noOfLiveCellsInBoard = exactCoverMatrix[0].length-7;
		if (i == 0) {// Block - O
			if (j + 1 <= rows-1 && (k + 1) <= columns-1) {
				if (board[j][k + 1] < 0 || board[j + 1][k] < 0
						|| board[j + 1][k + 1] < 0)
					return exactCoverMatrix;
				else{
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 1]] = 1;
					rowsFilledInTable++;
					//return exactCoverMatrix;
				}
			} 
		} else if (i == 1) {// Block I
			if (k + 3 <= columns-1) {
				if (board[j][k + 1] < 0 || board[j][k + 2] < 0
						|| board[j][k + 3] < 0){
					//return exactCoverMatrix;
				}
				else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 2]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 3]] = 1;
					rowsFilledInTable++;
				}
			}
			if (j + 3 <= rows-1) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j + 3][k] < 0){
					//return exactCoverMatrix;
				}
				else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j+1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 3][k]] = 1;
					rowsFilledInTable++;
				}
			}
		} else if (i == 2) {// Block T
			// Checking the 1st orientation
			if (j + 2 <= rows-1 && k + 1 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j + 1][k + 1] < 0) {
				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 1]] = 1;
					rowsFilledInTable++;
				}
			}
			// Checking the 2nd orientation
			if (j + 1 <= rows-1 && k + 2 <= columns-1) {
				if (board[j][k + 1] < 0 || board[j][k + 2] < 0
						|| board[j + 1][k + 1] < 0) {
				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 2]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 1]] = 1;
					rowsFilledInTable++;
				}
			}
			// Checking the 3rd orientation
			if (j + 2 <= rows-1 && k - 1 >= 0) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j + 1][k - 1] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k - 1]] = 1;
					rowsFilledInTable++;
				}
			}
			// Checking the 4th orientation
			if (j + 1 <= rows-1 && k - 1 >= 0 && k + 1 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 1][k + 1] < 0
						|| board[j + 1][k - 1] < 0) {
				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k - 1]] = 1;
					rowsFilledInTable++;
				}
			}
		} else if (i == 3) {// Block J
			// Checking the 1st orientation
			
			if (j + 2 <= rows-1 && k - 1 >= 0) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j + 2][k - 1] < 0) {
				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k - 1]] = 1;
					rowsFilledInTable++;
				}
			}
			// Checking the 2nd orientation
			if (j + 1 <= rows-1 && k + 2 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 1][k + 1] < 0
						|| board[j + 1][k + 2] < 0) {
				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 2]] = 1;
					rowsFilledInTable++;
				}
			}
			// Checking the 3rd orientation
			if (j + 2 <= rows-1 && k + 1 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j][k + 1] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 1]] = 1;
					rowsFilledInTable++;
				}
			}
			// Checking the 4th orientation
			if (j + 1 <= rows-1 && k + 2 <= columns-1) {
				if (board[j + 1][k + 2] < 0 || board[j][k + 1] < 0
						|| board[j][k + 2] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 2]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 2]] = 1;
					rowsFilledInTable++;
				}
			}

		} else if (i == 4) {// Block L
			// Checking the 1st orientation
			if (j + 2 <= rows-1 && k + 1 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j + 2][k + 1] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k + 1]] = 1;
					rowsFilledInTable++;
				}
			}
			// Checking the 2nd orientation
			if (j + 1 <= rows-1 && k + 2 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j][k + 1] < 0
						|| board[j][k + 2] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 2]] = 1;
					rowsFilledInTable++;
				}
			}
			// Checking the 3rd orientation
			if (j + 2 <= rows-1 && k + 1 <= columns-1) {
				if (board[j + 1][k + 1] < 0 || board[j + 2][k + 1] < 0
						|| board[j][k + 1] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 1]] = 1;
					rowsFilledInTable++;
				}
			}
			// Checking the 4th orientation
			if (j + 1 <= rows-1 && k - 2 >= 0) {
				if (board[j + 1][k - 1] < 0 || board[j + 1][k - 2] < 0
						|| board[j + 1][k] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k - 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k - 2]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					rowsFilledInTable++;
				}
			}

		} else if (i == 5) {// Block S
			if (j + 1 <= rows-1 && k - 1 >= 0 && k + 1 <= columns-1) {
				if (board[j + 1][k - 1] < 0 || board[j + 1][k] < 0
						|| board[j][k + 1] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k - 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 1]] = 1;
					rowsFilledInTable++;
				}
			}
			if (j + 2 <= rows-1 && k + 1 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 1][k + 1] < 0
						|| board[j + 2][k + 1] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k + 1]] = 1;
					rowsFilledInTable++;
				}
			}

		} else if (i == 6) {// Block Z
			
			if (j + 1 <= rows-1 && k + 2 <= columns-1) {
				if (board[j + 1][k + 2] < 0 || board[j + 1][k + 1] < 0
						|| board[j][k + 1] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 2]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k + 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k + 1]] = 1;
					rowsFilledInTable++;
				}
			}
			if (j + 2 <= rows-1 && k - 1 >= 0) {
				if (board[j + 1][k] < 0 || board[j + 1][k - 1] < 0
						|| board[j + 2][k - 1] < 0) {

				} else {
					exactCoverMatrix[rowsFilledInTable][noOfLiveCellsInBoard+i] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 1][k - 1]] = 1;
					exactCoverMatrix[rowsFilledInTable][board[j + 2][k - 1]] = 1;
					rowsFilledInTable++;
				}
			}
		}	
		
		return exactCoverMatrix;
	}

	private static int getNoRows() {
		// Iterate over all the 7 blocks
		// For each block, iterate over the board
		// iterate row wise
		// For each cell try the block in all orientations
		// Mark that cell as a Taboo cell
		int countRows = 0, temp;
		int i = 0, j, k;
		for (i = 0; i < 7; i++) {

			for (j = 0; j < rows; j++) {
				for (k = 0; k < columns; k++) {
					if ((temp = canBlockBePlaced(i, j, k)) > 0) {
						countRows += temp;
					}
				}

			}
		}

		return countRows;
	}

	private static int canBlockBePlaced(int i, int j, int k) {
		int count = 0;
		if (board[j][k] <0 )
			return 0;
		if (i == 0) {// Block - O
			if (j + 1 <= rows-1 && (k + 1) <= columns-1) {
				if (board[j][k + 1] < 0 || board[j + 1][k] < 0
						|| board[j + 1][k + 1] < 0)
					return 0;
				else
					return 1;
			} else
				return 0;

		} else if (i == 1) {// Block I
			count = 0;
			if (k + 3 <= columns-1) {
				if (board[j][k + 1] < 0 || board[j][k + 2] < 0
						|| board[j][k + 3] < 0){
					//return 0;
				}
				else {
					count++;
				}
			}
			if (j + 3 <= rows-1) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j + 3][k] < 0)
					return count;
				else {
					count++;
				}
			}
			return count;

		} else if (i == 2) {// Block T
			// Checking the 1st orientation
			count = 0;
			if (j + 2 <= rows-1 && k + 1 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j + 1][k + 1] < 0) {
					count = 0;
				} else {
					count++;
				}
			}
			// Checking the 2nd orientation
			if (j + 1 <= rows-1 && k + 2 <= columns-1) {
				if (board[j][k + 1] < 0 || board[j][k + 2] < 0
						|| board[j + 1][k + 1] < 0) {

				} else {
					count++;
				}
			}
			// Checking the 3rd orientation
			if (j + 2 <= rows-1 && k - 1 >= 0) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j + 1][k - 1] < 0) {

				} else {
					count++;
				}
			}
			// Checking the 4th orientation
			if (j + 1 <= rows-1 && k - 1 >= 0 && k + 1 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 1][k + 1] < 0
						|| board[j + 1][k - 1] < 0) {

				} else {
					count++;
				}
			}
		} else if (i == 3) {// Block J
			// Checking the 1st orientation
			count = 0;
			if (j + 2 <= rows-1 && k - 1 >= 0) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j + 2][k - 1] < 0) {

				} else {
					count++;
				}
			}
			// Checking the 2nd orientation
			if (j + 1 <= rows-1 && k + 2 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 1][k + 1] < 0
						|| board[j + 1][k + 2] < 0) {

				} else {
					count++;
				}
			}
			// Checking the 3rd orientation
			if (j + 2 <= rows-1 && k + 1 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j][k + 1] < 0) {

				} else {
					count++;
				}
			}
			// Checking the 4th orientation
			if (j + 1 <= rows-1 && k + 2 <= columns-1) {
				if (board[j + 1][k + 2] < 0 || board[j][k + 1] < 0
						|| board[j][k + 2] < 0) {

				} else {
					count++;
				}
			}

		} else if (i == 4) {// Block L
			// Checking the 1st orientation
			count = 0;
			if (j + 2 <= rows-1 && k + 1 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 2][k] < 0
						|| board[j + 2][k + 1] < 0) {

				} else {
					count++;
				}
			}
			// Checking the 2nd orientation
			if (j + 1 <= rows-1 && k + 2 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j][k + 1] < 0
						|| board[j][k + 2] < 0) {

				} else {
					count++;
				}
			}
			// Checking the 3rd orientation
			if (j + 2 <= rows-1 && k + 1 <= columns-1) {
				if (board[j + 1][k + 1] < 0 || board[j + 2][k + 1] < 0
						|| board[j][k + 1] < 0) {

				} else {
					count++;
				}
			}
			// Checking the 4th orientation
			if (j + 1 <= rows-1 && k - 2 >= 0) {
				if (board[j + 1][k - 1] < 0 || board[j + 1][k - 2] < 0
						|| board[j + 1][k] < 0) {

				} else {
					count++;
				}
			}

		} else if (i == 5) {// Block S
			count = 0;
			if (j + 1 <= rows-1 && k - 1 >= 0 && k + 1 <= columns-1) {
				if (board[j + 1][k - 1] < 0 || board[j + 1][k] < 0
						|| board[j][k + 1] < 0) {

				} else {
					count++;
				}
			}
			if (j + 2 <= rows-1 && k + 1 <= columns-1) {
				if (board[j + 1][k] < 0 || board[j + 1][k + 1] < 0
						|| board[j + 2][k + 1] < 0) {

				} else {
					count++;
				}
			}

		} else if (i == 6) {// Block Z
			count = 0;
			if (j + 1 <= rows-1 && k + 2 <= columns-1) {
				if (board[j + 1][k + 2] < 0 || board[j + 1][k + 1] < 0
						|| board[j][k + 1] < 0) {

				} else {
					count++;
				}
			}
			if (j + 2 <= rows-1 && k - 1 >= 0) {
				if (board[j + 1][k] < 0 || board[j + 1][k - 1] < 0
						|| board[j + 2][k - 1] < 0) {

				} else {
					count++;
				}
			}
		}
		return count;
	}
}
