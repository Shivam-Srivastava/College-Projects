import java.util.ArrayList;

public class WebSolver {
	boolean isPlay;
	boolean hasSolution = true;
	static ArrayList<TetrominoeMove> solutionMoves = new ArrayList<TetrominoeMove>();
	DoubleLinkedList inputWeb;
	ArrayList<Node> solutions;
	int nextIthMin = 0;
	boolean isSolved = false;
	InvokeGUI gui;

	public WebSolver(InvokeGUI g) {
		gui = g;
		inputWeb = new DoubleLinkedList(Main.exactCoverMatrix);
		inputWeb.makeWeb();
		solutions = new ArrayList<Node>();
	}

	public void search(int k) {
		if (!isSolved) {
			if (inputWeb.head.getRight() == inputWeb.head) {
				isSolved = true;
				//printSolution();
				return;
			} else {
				//System.out.println("2,3 position has: "+MakeTable.board[2][3]);
				Node column;
				if (hasSolution) {
					column = chooseNextColumn();// Gets Column with minimum no
												// Of Blocks possible
				} else {
					column = chooseNextColumn();
					if (column == null) {
						if (tilesLeftUncovered() > 4) {
							nextIthMin = 0;
							column = chooseNextColumn();
						} else {
							System.out
									.println("Has no solution and printing solution");
							isSolved = true;
							//printSolution();
							return;
						}
					}
//					System.out.println("Choosing next column"
//							+ column.blockNo);
				}
				cover(column);
				column.isCovered = true;
				for (Node row = column.getDown(); row != column && !isSolved; row = row
						.getDown()) {
					solutions.add(row);
					if (isPlay)
						gui.makeMove(printBlocksCoveredBy(row));
					for (Node rightNode = row.getRight(); rightNode != row
							&& !isSolved; rightNode = rightNode.getRight()) {
						cover(rightNode.columnHead);
						rightNode.columnHead.isCovered = true;
					}

					search(k + 1);
					if (!hasSolution && tilesLeftUncovered() <= 3) {
						isSolved = true;
						//printSolution();
						return;
					}
					if (!isSolved)
					{
						System.out
								.println("Backtracking at level : " + (k + 1));
						solutions.remove(row);
						if (isPlay)
							gui.undoMove();
						column = row.columnHead;

						for (Node leftNode = row.getLeft(); leftNode != row
								&& !isSolved; leftNode = leftNode.getLeft()) {
							uncover(leftNode.columnHead);
							leftNode.columnHead.isCovered = false;
						}
					}
				}
				if (k == 0&&!isSolved) {
					hasSolution = false;
					nextIthMin++;
					search(0);
				}
				uncover(column);
				column.isCovered = false;
				return;

			}
		}// outer If condition checking if "isSolved" or not
	}
	private int tilesLeftUncovered() {
		Node iter = inputWeb.head.getRight();
		int val = 0;
		while (iter != inputWeb.head) {
			val++;
			iter = iter.getRight();
		}

		return val;
	}

	private Node chooseNextMaxColumn() {
		Node iter = inputWeb.head.getRight();
		int val = 0;
		int countNumberOfColumnsUncovered = 0;
		Node max = iter;
		while (iter != inputWeb.head) {
			countNumberOfColumnsUncovered++;
			if (iter.noOfBlocks > val && !iter.isCovered) {
				max = iter;
				val = iter.noOfBlocks;
			}
			iter = iter.getRight();
		}
		if (countNumberOfColumnsUncovered <= 3 || val <= 0) {
			return null;
		}
		return max;
	}

	public void printSolution() {
		if(!hasSolution)
			System.out.println("Filling maximum possible. There is no solution.");
		else
			System.out.println("A solution has been found.");
		solutionMoves.clear();
		for (int i = 0; i < solutions.size(); i++) {
			// System.out.println(solutions.get(i).typeOfTetrominoe + " at ");
			solutionMoves.add(printBlocksCoveredBy(solutions.get(i)));
		}
		isSolved = true;
	}

	public TetrominoeMove printBlocksCoveredBy(Node node) {
		Node temp = node;
		TetrominoeMove newBlock;
		int i = 0;
		int[] tempArray = new int[4];
		while (temp.getRight() != node) {
			// System.out.print (temp.getColumnHead().blockNo+" ");
			tempArray[i++] = temp.getColumnHead().blockNo;
			temp = temp.getRight();
		}
		// System.out.println(temp.getColumnHead().blockNo);
		tempArray[i] = temp.getColumnHead().blockNo;
		newBlock = new TetrominoeMove(node.typeOfTetrominoe, tempArray);
		// solutionMoves.add(newBlock);
		return newBlock;
	}

	private Node chooseNextColumn() {

		Node iter = inputWeb.head.getRight();
		Node min = iter;
		int val = min.noOfBlocks;
		if (nextIthMin > 0) {
			ArrayList<Node> sortedList = new ArrayList<Node>();
			while (iter != inputWeb.head) {
				sortedList.add(iter);
				iter = iter.getRight();
			}

			int k, j, minIndex = 0;
			Node temp;
			int minNoBlocks = sortedList.get(0).noOfBlocks;
			for (j = 0; j < sortedList.size(); j++) {
				for (k = j + 1; k < sortedList.size(); k++) {
					if (sortedList.get(k).noOfBlocks < minNoBlocks) {
						minNoBlocks = sortedList.get(k).noOfBlocks;
						min = sortedList.get(k);
						minIndex = k;
					}

				}
				temp = sortedList.get(j);
				sortedList.set(j, min);
				sortedList.set(minIndex, temp);
			}
			if (sortedList.size() > nextIthMin)
				return sortedList.get(nextIthMin);
			else
				return null;// sortedList.get(0);
		} else {
			while (iter != inputWeb.head) {
				if (iter.noOfBlocks < val && !iter.isCovered)
				{
					//System.out.println("Block Chosen:" +iter.blockNo);
					min = iter;
					val = iter.noOfBlocks;
				}
				iter = iter.getRight();

			}
			iter = inputWeb.head.getRight();
			// Check if the moves with "min" value can be corner moves? If yes,
			// Move them first.
			while (iter != inputWeb.head) {
				if (iter.noOfBlocks == val)
				{
					if (isThisTileACorner(iter))
						min = iter;
				}
				iter = iter.getRight();

			}
			return min;
		}
	}

	private boolean isThisTileACorner(Node iter) {
		int rowNo = MakeTable.coordinateMapping[iter.blockNo] / MakeTable.rows;
		int colNo = MakeTable.coordinateMapping[iter.blockNo] % MakeTable.rows;
		if (IsNotFree(rowNo, colNo - 1) && IsNotFree(rowNo - 1, colNo)
				&& IsNotFree(rowNo - 1, colNo - 1)
				|| IsNotFree(rowNo, colNo - 1) && IsNotFree(rowNo + 1, colNo)
				&& IsNotFree(rowNo + 1, colNo - 1)
				||IsNotFree(rowNo,colNo+1)&&IsNotFree(rowNo-1,colNo)&&IsNotFree(rowNo-1,colNo+1)
				||IsNotFree(rowNo,colNo+1)&&IsNotFree(rowNo+1,colNo)&&IsNotFree(rowNo+1,colNo+1))
			return true;
		else
			return false;
	}

	private boolean IsNotFree(int row, int col) {
		if(isCovered(row,col))
			return true;
		else if(row<0||col<0||row>=MakeTable.rows||col>=MakeTable.columns)
			return true;
		else if(MakeTable.board[row][col]<0)
			return true;
		 
		else 
			return false;
	}

	private boolean isCovered(int row, int col) {
		int coordinate = row*MakeTable.rows+col;
		int i = 0;
		//Here we are sure that the "coordinate" exists in the coordinateMapping as other cases have been checked before in IsNotFree function
		if(row<0||row>=MakeTable.rows||col<0||col>=MakeTable.columns)
			return false;
		else if(MakeTable.board[row][col]<0)
			return false;
		for(i=0;i<MakeTable.coordinateMapping.length;i++){
			if(MakeTable.coordinateMapping[i]==coordinate)
				break;
		}
		
		Node iter = inputWeb.head.getRight();
		while (iter != inputWeb.head) {
			if (iter.blockNo==i)
				return false;
			iter = iter.getRight();

		}
		return true;
	}

	/*
	 * Decrease the number of uncovered nodes in "column"
	 */
	public void cover(Node column) {// Assume node n is a column head
		column.getRight().setLeft(column.getLeft());
		column.getLeft().setRight(column.getRight());
		// column.noOfBlocks-=1;
		for (Node row = column.getDown(); row != column; row = row.getDown())
			for (Node rightNode = row.getRight(); rightNode != row; rightNode = rightNode
					.getRight()) {
				rightNode.getUp().setDown(rightNode.getDown());
				rightNode.getDown().setUp(rightNode.getUp());
				rightNode.columnHead.noOfBlocks -= 1;
			}
	}

	/*
	 * Increase the number of uncovered nodes in "column"
	 */
	public void uncover(Node column) {
		for (Node row = column.getUp(); row != column; row = row.getUp())
			for (Node leftNode = row.getLeft(); leftNode != row; leftNode = leftNode
					.getLeft()) {
				leftNode.getUp().setDown(leftNode);
				leftNode.getDown().setUp(leftNode);
				leftNode.columnHead.noOfBlocks += 1;
			}
		column.getRight().setLeft(column);
		column.getLeft().setRight(column);
	}
}