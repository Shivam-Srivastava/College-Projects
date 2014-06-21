public class Node {
	Node up;
	boolean isCovered = false;
	Node down;
	Node left;
	Node right;
	Node columnHead;
	int typeOfTetrominoe = -1;
	int blockNo = -1;//Number of the block in the board
	int noOfBlocks = 0;//in case this node is a columnHead
	Node getRight() {
		return right;
	}

	Node getLeft() {
		return left;
	}

	Node getUp() {
		return up;
	}

	Node getDown() {
		return down;
	}

	void setLeft(Node n) {
		left = n;
	}

	void setRight( Node n) {
		right = n;
	}

	void setUp(Node n) {
		up = n;
	}

	void setDown(Node n) {
		down = n;
	}
	Node getColumnHead(){
		return columnHead;
	}
	void setColumnHead(Node n){
		columnHead = n;
	}

	public Node getMyColumnHead(int j, Node head) {
		int i = 0;
		Node temp = head;
		for(i=0;i<=j;i++){
			temp = temp.getRight();
		}
		return temp;
	}
}
