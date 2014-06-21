package iitm.apl.player.ui;

import iitm.apl.player.Song;
import iitm.apl.player.ThreadedPlayer;
import iitm.apl.player.ThreadedPlayer.State;

import java.awt.*;
import java.awt.event.*;
import java.io.File;
import java.io.FilenameFilter;
import java.util.Vector;

import javax.swing.*;
import javax.swing.GroupLayout.Alignment;
import javax.swing.table.JTableHeader;
/*
 * Project By: Shivam Srivastava (CS10B051) & Dhanvin Mehta (CS10B035)
 */
/**
 * The JamPlayer Main Class Sets up the UI, and stores a reference to a threaded
 * player that actually plays a song.
 * Please Read the README file attached with this project for explanations!
 */
public class JamPlayer {

	// UI Items
	private JFrame mainFrame;
	private PlayerPanel pPanel;

	private JTable libraryTable;
	private LibraryTableModel libraryModel;

	private Thread playerThread = null;
	private ThreadedPlayer player = null;

	public JamPlayer() {
		// Create the player
		player = new ThreadedPlayer();
		playerThread = new Thread(player);
		playerThread.start();
	}

	/**
	 * Create a file dialog to choose MP3 files to add
	 */
	private Vector<Song> addFileDialog() {
		JFileChooser chooser = new JFileChooser();
		chooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
		int returnVal = chooser.showOpenDialog(null);
		if (returnVal != JFileChooser.APPROVE_OPTION)
			return null;

		File selectedFile = chooser.getSelectedFile();
		// Read files as songs
		Vector<Song> songs = new Vector<Song>();
		if (selectedFile.isFile()
				&& selectedFile.getName().toLowerCase().endsWith(".mp3")) {
			songs.add(new Song(selectedFile));
			return songs;
		} else if (selectedFile.isDirectory()) {
			for (File file : selectedFile.listFiles(new FilenameFilter() {
				@Override
				public boolean accept(File dir, String name) {
					return name.toLowerCase().endsWith(".mp3");
				}
			}))
				songs.add(new Song(file));
		}

		return songs;
	}

	/**
	 * Creates the GUI and shows it. For thread safety, this method has been
	 * invoked from the event-dispatching thread.
	 */
	private void createAndShowGUI() {
		// Create and set up the window.
		mainFrame = new JFrame("JamPlayer");
		mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		mainFrame.setMinimumSize(new Dimension(300, 400));

		// Create and set up the content pane.
		Container pane = mainFrame.getContentPane();
		pane.add(createMenuBar(), BorderLayout.NORTH);
		pane.add(Box.createHorizontalStrut(30), BorderLayout.EAST);
		pane.add(Box.createHorizontalStrut(30), BorderLayout.WEST);
		pane.add(Box.createVerticalStrut(30), BorderLayout.SOUTH);
		JPanel mainestPanel = new JPanel();
		// Set mainestPanel Layout
		mainestPanel.setLayout(new FlowLayout(FlowLayout.CENTER));
		// ///////////////////////////
		JPanel mainPanel = new JPanel();
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());
		buttonPanel.setPreferredSize(new Dimension(100, 200));
		// ///////////////////////////
		JButton delete = new JButton("Delete");
		delete.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				Song song = libraryModel.get(libraryTable.getSelectedRow());
				if (song != null) {
					libraryModel.remove(song);
				}
			}
		});
		buttonPanel.add(delete);
		// ///////////////////////////
		// ///////////////////////////
		JButton optimize = new JButton("Optimize");

		optimize.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				libraryModel.optimize();
			}
		});
		buttonPanel.add(optimize);
		// //////////////////////////
		JButton previous = new JButton("<<");
		previous.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				Song current = pPanel.getCurrentSong();
				Song previousSong = libraryModel.getPreviousSong(current);
				player.queuedSongs.add(previousSong);
				player.setState(State.STOP);
				pPanel.setSong(previousSong);
				int in = libraryModel.songListing.indexOf(previousSong);
				libraryTable.setRowSelectionInterval(in, in);
			}
		});
		buttonPanel.add(previous);
		// //////////////////////////
		// //////////////////////////
		JButton nextSong = new JButton(">>");
		nextSong.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				Song current = pPanel.getCurrentSong();
				Song nextSong = libraryModel.getNextSong(current);
				player.queuedSongs.add(nextSong);
				player.setState(State.STOP);
				pPanel.setSong(nextSong);
				int in = libraryModel.songListing.indexOf(nextSong);
				libraryTable.setRowSelectionInterval(in, in);
			}
		});
		buttonPanel.add(nextSong);
		// /////////////////////////
		GroupLayout layout = new GroupLayout(mainPanel);
		mainPanel.setLayout(layout);

		pPanel = new PlayerPanel(player);
		JLabel searchLabel = new JLabel("Search: ");
		final JTextField searchText = new JTextField(200);
		searchText.setMaximumSize(new Dimension(200, 20));
		searchText.addKeyListener(new KeyListener() {
			@Override
			public void keyTyped(KeyEvent arg0) {
				//Dynamic search function...takes in keys everytime there is a change in the searchText
				Character c = arg0.getKeyChar();
				if (c != 8) {

					//System.out.println(searchText.getText()
							//.concat(c.toString()));
					libraryModel.filter(searchText.getText().concat(
							c.toString()).toLowerCase());
				} else {
					//System.out.println(searchText.getText().trim());
					libraryModel.filter(searchText.getText().trim()
							.toLowerCase());
				}//the additional if-else conditions have been added to append the last character typed
				//this appending makes it more dynamic otherwise it searches on the typed String minus the last character
			}

			@Override
			public void keyReleased(KeyEvent arg0) {
			}

			@Override
			public void keyPressed(KeyEvent arg0) {
			}
		});

		libraryModel = new LibraryTableModel();
		libraryTable = new JTable(libraryModel);
		libraryTable.setAutoCreateRowSorter(true);
		JTableHeader header = libraryTable.getTableHeader();
		header.addMouseListener(new MouseListener() {

			@Override
			public void mouseClicked(MouseEvent arg0) {
				// TODO Auto-generated method stub
				//System.out.println("Foo Foo");
				Vector<Song> newList = new Vector<Song>();
				Vector<Song> temp = libraryModel.getSongList();
				for (int i = 0; i < temp.size(); i++) {
					String sTitle = (String) libraryTable.getValueAt(i, 0);
					newList.add(libraryModel.titleHash.get(sTitle));
				}
				libraryModel.songListing = newList;
				libraryModel.resetIdx();
				libraryModel.fireTableDataChanged();
			}

			@Override
			public void mouseEntered(MouseEvent arg0) {
				// TODO Auto-generated method stub

			}

			@Override
			public void mouseExited(MouseEvent arg0) {
				// TODO Auto-generated method stub

			}

			@Override
			public void mousePressed(MouseEvent arg0) {
				// TODO Auto-generated method stub

			}

			@Override
			public void mouseReleased(MouseEvent arg0) {
				// TODO Auto-generated method stub

			}

		});
		header.setBackground(Color.lightGray);
		libraryTable.addMouseListener(new MouseListener() {

			@Override
			public void mouseReleased(MouseEvent arg0) {
			}

			@Override
			public void mousePressed(MouseEvent arg0) {
			}

			@Override
			public void mouseExited(MouseEvent arg0) {
			}

			@Override
			public void mouseEntered(MouseEvent arg0) {
			}

			@Override
			public void mouseClicked(MouseEvent arg0) {
				int i = libraryTable.getSelectedRow();
				System.out.println(libraryTable.getValueAt(i, 0));

				if (arg0.getClickCount() > 1) {
					Song song = libraryModel.get(libraryTable.getSelectedRow());
					if (song != null) {
						player.setSong(song);
						pPanel.setSong(song);
					}
				}

			}
		});

		libraryTable
				.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
		JScrollPane libraryPane = new JScrollPane(libraryTable);

		layout.setHorizontalGroup(layout.createParallelGroup(Alignment.CENTER)
				.addComponent(pPanel).addGroup(
						layout.createSequentialGroup().addContainerGap()
								.addComponent(searchLabel).addComponent(
										searchText).addContainerGap())
				.addComponent(libraryPane));

		layout.setVerticalGroup(layout.createSequentialGroup().addComponent(
				pPanel).addContainerGap().addGroup(
				layout.createParallelGroup(Alignment.CENTER).addComponent(
						searchLabel).addComponent(searchText)).addComponent(
				libraryPane));

		mainestPanel.add(mainPanel);
		mainestPanel.add(buttonPanel);
		pane.add(mainestPanel, BorderLayout.CENTER);

		// Display the window.
		mainFrame.pack();
		mainFrame.setVisible(true);
	}

	private JMenuBar createMenuBar() {
		JMenuBar mbar = new JMenuBar();
		JMenu file = new JMenu("File");
		JMenuItem addSongs = new JMenuItem("Add new files to library");
		addSongs.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				Vector<Song> songs = addFileDialog();
				if (songs != null)
					libraryModel.add(songs);
			}
		});
		file.add(addSongs);

		JMenuItem createPlaylist = new JMenuItem("Create playlist");
		createPlaylist.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				createPlayListHandler();
			}
		});
		file.add(createPlaylist);

		JMenuItem quitItem = new JMenuItem("Quit");
		quitItem.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				mainFrame.dispose();
			}
		});
		file.add(quitItem);

		mbar.add(file);

		return mbar;
	}

	protected void createPlayListHandler() {
		PlayListMakerDialog dialog = new PlayListMakerDialog(this);
		dialog.setVisible(true);
	}

	public Vector<Song> getSongList() {
		Vector<Song> songs = new Vector<Song>();
		for (int i = 0; i < libraryModel.getRowCount(); i++)
			songs.add(libraryModel.get(i));
		return songs;
	}

	public static void main(String[] args) {
		// Schedule a job for the event-dispatching thread:
		// creating and showing this application's GUI.
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			@Override
			public void run() {
				JamPlayer player = new JamPlayer();
				player.createAndShowGUI();
			}
		});
	}
}
