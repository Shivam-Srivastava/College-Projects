package iitm.apl.player.ui;

import iitm.apl.player.Song;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;
import javax.swing.table.AbstractTableModel;

/**
 * Table model for a library
 * 
 */
public class LibraryTableModel extends AbstractTableModel {
	private static final long serialVersionUID = 8230354699902953693L;

	//the following is our implementation of the BKTree search along with the Hashtable DataStructure
	public Vector<Song> songListing;
	public Vector<Song> nextWordList;
	private Vector<Song> all_songs;
	private int songIteratorIdx;
	public Hashtable<String,Song> titleHash = new Hashtable<String, Song>();
	private Song currentSong;
	private Iterator<Song> songIterator;
	BKTree tree = new BKTree();
	table_ tbl = new table_();
	LibraryTableModel() {
		nextWordList = new Vector<Song>();
		songListing = new Vector<Song>();
		all_songs = new Vector<Song>();
		songIterator = songListing.iterator();
	}

	public void add(Song song) {
		tbl.insert(song);
		String[] temp;
		String title = song.getTitle();
		System.out.println(title);
		temp = getWords(title.toLowerCase());
		//Only add to BKT if length >=2
		for(int j=0;j<temp.length;j++){
			tree.insert(temp[j]);
		}
		songListing.add(song);
		titleHash.put(song.getTitle(), song);
		all_songs.add(song);
		resetIdx();
		fireTableDataChanged();
	}

	
	public void add(Vector<Song> songs) {
		String[] temp;
		String title;
		for(int i=0;i<songs.size();i++){
			tbl.insert(songs.get(i));
			titleHash.put(songs.get(i).getTitle(), songs.get(i));
		}
		for(int i=0;i<songs.size();i++){
			title = songs.get(i).getTitle();
//			System.out.println(title);
			temp = getWords(title.toLowerCase());
			for(int j=0;j<temp.length;j++){
				//System.out.println("Inserting in tree:"+temp[j]);
				tree.insert(temp[j]);
			}
		}
		songListing.addAll(songs);
		all_songs.addAll(songs);
		resetIdx();
		fireTableDataChanged();
	}

	public void filter(String searchString) {
		// Connected the searchText keyPressed handler to update the filter
		// here.
		String[] temp;
		temp = getWords(searchString.toLowerCase());
		
		
		for(int i=0;i<temp.length;i++){
			if(i==0&&temp[0].length()!=0){
				tree.search(temp[0]);
				songListing = tbl.search(tree.str_list);
				tree.str_list.clear();
			}
			else if(i==0&&temp[0].length()==0)
				songListing = all_songs;
			else if(i>=1&&temp[i].length()!=0)
			{
				tree.search(temp[i]);
				nextWordList = tbl.search(tree.str_list);
				tree.str_list.clear();
				Vector<Song> temp_list = new Vector<Song>();
					for(int j=0;j<songListing.size();j++){
						
							if(nextWordList.contains(songListing.get(j)))
								temp_list.add(songListing.get(j));
					}
					songListing = temp_list;
			}
		}
		/*System.out.println("===================================");
		Song tempSong;
		for(int i=0;i<songListing.size();i++){
			tempSong= songListing.get(i);
			System.out.println(tempSong.getTitle());
		}
		System.out.println("===================================");*/
		resetIdx();
		fireTableDataChanged();
	}
	
	public void resetIdx()
	{
		songIteratorIdx = -1;
		currentSong = null;
		songIterator = songListing.iterator();
	}
	// Gets the song at the currently visible index
	public Song get(int idx) {
		if( songIteratorIdx == idx )
			return currentSong;
		
		if(songIteratorIdx > idx)
		{
			resetIdx();
		}
		while( songIteratorIdx < idx && songIterator.hasNext() )
		{
			currentSong = songIterator.next();
			songIteratorIdx++;
		}
		return currentSong;
	}

	@Override
	public int getColumnCount() {
		// Title, Album, Artist, Duration.
		return 4;
	}

	@Override
	public int getRowCount() {
		return songListing.size();
	}

	@Override
	public Object getValueAt(int row, int col) {
		Song song = get(row);
		if(song == null) return null;

		switch (col) {
		case 0: // Title
			return song.getTitle();
		case 1: // Album
			return song.getAlbum();
		case 2: // Artist
			return song.getArtist();
		case 3: // Duration
			int duration = song.getDuration();
			int mins = duration / 60;
			int secs = duration % 60;
			return String.format("%d:%2d", mins, secs);
		default:
			return null;
		}
	}

	@Override
	public String getColumnName(int column) {
		switch (column) {
		case 0: // Title
			return "Title";
		case 1: // Album
			return "Album";
		case 2: // Artist
			return "Artist";
		case 3: // Duration
			return "Duration";
		default:
			return super.getColumnName(column);
		}
	}
	
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
		System.out.println(title_f);
		return temp;
	}
	
	public void sortSongListByTitle(){
		
	}
	public void remove(Song s){
		titleHash.remove(s.getTitle());
		tbl.delete(s);
		songListing.remove(s);
		all_songs.remove(s);
		resetIdx();
		fireTableDataChanged();
	}
	public void optimize(){
		tbl.optimize();
		Set<String> set = tbl.table.keySet();
		tree = new BKTree();
		for(String str:set){
			tree.insert(str);
		}
	}

	public Song getPreviousSong(Song current) {
		int idx = songListing.indexOf(current);
		if(idx>0)
			return songListing.get(idx-1);
		else
			return songListing.get(songListing.size()-1);
		// TODO Auto-generated method stub
		
		
	}
	public Song getNextSong(Song current) {
		int idx = songListing.indexOf(current);
		if(idx<songListing.size()-1)
			return songListing.get(idx+1);
		else
			return songListing.get(0);
		// TODO Auto-generated method stub
		
		
	}
	
	public Vector<Song> getSongList(){
		return songListing;
	}
}