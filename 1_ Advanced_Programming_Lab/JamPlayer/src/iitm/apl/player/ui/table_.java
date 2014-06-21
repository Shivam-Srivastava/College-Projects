package iitm.apl.player.ui;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.Vector;

import iitm.apl.player.Song;

public class table_ {
	Hashtable<String, List<Song>> table;

	table_() {
		table = new Hashtable<String, List<Song>>();
	}

	
   /* Given a song, splits into words and if each word's song 
	* list in hash table doesnt contain song, it adds it.
	* If list is empty, creates new list.
	*/
	public void insert(Song s) {
		String str = s.getTitle();
		String[] temp = getWords(str.toLowerCase());
		int i;
		for (i = 0; i < temp.length; i++) {
			//System.out.println(temp[i]);
			if (table.get(temp[i]) != null&&!table.get(temp[i]).contains(s)) {
				table.get(temp[i]).add(s);
			} else if(temp[i].length()>=2){
				table.put(temp[i], new ArrayList<Song>());
				table.get(temp[i]).add(s);
			}
			else{
				//System.out.println(temp[i]+"was NOT added to HASHTABLE");				
			}
		}
	}
	
	
	public void delete(Song s) {
		String str = s.getTitle();
		System.out.println(str);
		String[] temp = getWords(str.toLowerCase());
		int i;
		for (i = 0; i < temp.length; i++) {
			if(temp[i].length()>=2){
				if (table.get(temp[i]).size() >= 1) {
					//System.out.println(temp[i]);
					table.get(temp[i]).remove(s);
				}
			}
		}
	}

	
	/* Search hash for multiword search.
	 * To avoid repetitions a flag is set if a song is added to list for a 
	 * particular word
	 * Before returning the list of songs, these flags must be set to 0 for 
	 * future searches.
	 */
	public Vector<Song> search(List<String> tree_word) {
		Vector<Song> l = new Vector<Song>();
		Song temp_song=null;
		int i, j = 0;
		for (i = 0; i < tree_word.size(); i++) {
			int len = table.get(tree_word.get(i)).size();
			for(j=0;j<len;j++){
				temp_song =table.get(tree_word.get(i)).get(j); 
				if (!temp_song.get_flag()) {
					l.add(temp_song);
					temp_song.set_flag(true);
				}
			}
		}
		for (i = 0; i < tree_word.size(); i++) {//this loop reinitialises all flags to false for the next iteration
			int len = table.get(tree_word.get(i)).size();
			for(j=0;j<len;j++){
				table.get(tree_word.get(i)).get(j).set_flag(false);
			}
		}
		return l;
	}

	/*
	 * Gets rid of all the empty strings in the table. (frees the hashes)
	 * The empty hashes might be formed due to deletion and no more insertions
	 */
	public void optimize() {
		Set<String> set = table.keySet();
		Iterator<String> itr = set.iterator();
		String str;
		while (itr.hasNext()) {
			str = itr.next();
			if (table.get(str).size() == 0) {
				table.remove(str);
			}
		}
	}
	/*
	 * the following functions are to filter the string to be hashed and only then inserts them into the hash table!
	 */
	private boolean checkAlpha(char a){
		if(a>=65&&a<=90){
			return true;
		}
		if(a>=97&&a<=122||a>=48&&a<=57){
			return true;
		}
		if(a=='\''||a==' ')	return true;
		return false;
	}
	
	private String[] getWords(String str){
		String[] temp;
		char a;
		String title_f="";
		for(int i=0;i<str.length();i++){
			a=str.charAt(i);
			if(a=='-' || a=='_'|| a=='.'|| a=='/'|| a=='\\'||a=='#'||a==','||a==':'||a=='&'||a=='~'||a=='!'||a=='@') title_f+=' ';
			else if(checkAlpha(a)) title_f += a;
		}
		temp = title_f.split(" ");
		return temp;
	}
}
