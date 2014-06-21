package iitm.apl.player.ui;

import java.util.ArrayList;
import java.util.List;

public class BKTree {
	Node root;
	List<String> str_list = new ArrayList<String>();
	private final int MAX_TOL = 1;//the maximum levenshtein distance within which it will accept the strings

	BKTree(){
		root=null;
	}
	
	BKTree(Node n){
		root = n;
	}
	
	public void insert(String str){
		if(str.length()>=2){
			if(root==null){
				root = new Node(str);
			}
			else{
				insert(str,root);
			}
		}
		/*else{
			System.out.println(str+" was not added to BKTree!");
		}*/
	}
	
	
	//changed, so that multiple strings which are same are not inserted again in the Tree
	private void insert(String str,Node rt){
		int dist = Metric.calcLeviDist(str, rt.data);
		if(dist == 0){}
		else if(rt.children[dist]==null){
			rt.children[dist]=new Node(str);
		}
		else{
			insert(str,rt.children[dist]);
		}
	}
	
	public void search(String str){
		if(root!=null)search(str,root);
	}
		
	private void search(String str,Node rt){
		int dist = Metric.calcLeviDist(str, rt.data);
		if(dist<=MAX_TOL)str_list.add(rt.data);
		int i = dist-MAX_TOL;
		if(i<0)i=0;
		for(;i<=dist+MAX_TOL&&i<Node.MAX_LENGTH;i++){
			if(rt.children[i]!=null)search(str,rt.children[i]);			
		}
	}
}
