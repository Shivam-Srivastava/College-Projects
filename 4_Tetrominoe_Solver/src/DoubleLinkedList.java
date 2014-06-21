import java.util.ArrayList;
/*
 * To increase Stack: -Xss1m
 */
public class DoubleLinkedList {
	Node head;
	int[][] inputMatrix;
	ArrayList<Node> pointToFirstNodeInRow;
	public DoubleLinkedList(int[][] exactCoverMatrix) {
		pointToFirstNodeInRow = new ArrayList<Node>();
		inputMatrix = exactCoverMatrix;
		head = new Node();
	}
	public void makeWeb(){
		int i,j;
		int rows,columns;
		rows = inputMatrix.length;
		columns = 0;
		if(inputMatrix.length>0)
		columns = inputMatrix[0].length-7;
		Node temp = head;
		/*
		 * Making a double Linked List of all ColumnNodes
		 * Verified.
		 */
		for(i=0;i<columns;i++){
			Node n = new Node();
			n.columnHead = n;
			n.blockNo = i;
			temp.setRight(n);
			n.setLeft(temp);
			temp = n;
		}
		temp.setRight(head);
		head.setLeft(temp);
		temp = head.getRight();
		/*
		 * Making double Linked List of all elements,
		 * with value 1, row wise
		 * Verified
		 */
		temp = null;
		Node firstNode = null;
		boolean checkFirst=false;
		for(i=0;i<rows;i++){
			for(j=0;j<columns;j++){
				if(inputMatrix[i][j]==1&&!checkFirst){
					Node n = new Node();
					n.blockNo = j;
					n.columnHead = head.getMyColumnHead(j,head);
					n.typeOfTetrominoe = getMyTetrominoeType(i);
					firstNode = n;
					temp = n;
					checkFirst = true;
					pointToFirstNodeInRow.add(firstNode);
				}
				else if(inputMatrix[i][j]==1&&checkFirst){
					Node n = new Node();
					n.blockNo = j;
					n.columnHead = head.getMyColumnHead(j,head);
					n.typeOfTetrominoe = getMyTetrominoeType(i);
					temp.setRight(n);
					n.setLeft(temp);
					temp = n;
				}
			}
			checkFirst = false;
			temp.setRight(firstNode);
			firstNode.setLeft(temp);
		}
		temp = null;
		int count = 0;
		ArrayList<Node> columnIterator = pointToFirstNodeInRow;
		/*
		 * Making a double linked list of all nodes column wise
		 */
		for(i=0;i<columns;i++){
			count = 0;
			temp = head.getMyColumnHead(i, head);
			for(j=0;j<rows;j++){
				if(inputMatrix[j][i]==1){
					count++;
					Node n = columnIterator.get(j);
					n.setUp(temp);
					temp.setDown(n);
					temp = n;
					columnIterator.set(j, n.getRight());
				}
			}
			head.getMyColumnHead(i, head).noOfBlocks = count;
			temp.setDown(head.getMyColumnHead(i, head));
			head.getMyColumnHead(i, head).setUp(temp);
		}
	}
	private int getMyTetrominoeType(int i) {
		int j = 0;
		int tetrominoeNumber = 0;
		int noOfColumnsInMatrix = inputMatrix[0].length;
		for(j=noOfColumnsInMatrix-7;j<noOfColumnsInMatrix;j++){
			if(inputMatrix[i][j]==1){
				return tetrominoeNumber;
			}
			tetrominoeNumber++;
		}
		return -1;
	}
}
