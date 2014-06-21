package iitm.apl.player.ui;
public class Node {
	public static final int MAX_LENGTH = 15;
	String data;
	Node[] children;

	Node() {
		data = null;
		children = new Node[MAX_LENGTH];
	}

	Node(String str) {
		
		data = str;
		children = new Node[MAX_LENGTH];
	}

	public void printData() {
		System.out.println(data);
	}
	
}
