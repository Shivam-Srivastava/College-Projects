import java.util.List;
import java.util.Scanner;


public class Main {
	/**
	 * The program solves any input with or without voids inside.
	 * For certain cases it takes a long time as every heuristic has a worst case
	 * If a solution exists it fills the board and gets it.
	 * If a solution does not exist, it fills the board as much as possible.
	 * The tiles to be removed should be 0-based (positive) coordinates.
	 */

	//public static DoubleLinkedList web;
	public static InvokeGUI boardGUI;
	public static int[][] exactCoverMatrix;
	public static void main(String[] args){
		Scanner in = new Scanner(System.in);
		int rows, columns;
		System.out.println("Enter Dimensions of the board:");
		rows = in.nextInt();
		columns = in.nextInt();
		MakeTable table = new MakeTable(rows,columns);
		exactCoverMatrix = table.makeTable();
		
		
		//DisplayBoard theFinalBoard = new DisplayBoard(rows,columns,table.board);
		//System.out.println("The board looks like this: ");
		//theFinalBoard.drawBoard();
		//web = new DoubleLinkedList(exactCoverMatrix);
		//web.makeWeb();
		
		boardGUI = new InvokeGUI();
		boardGUI.invoke();
		

	}

}
