package iitm.apl.player.ui;

import iitm.apl.player.Song;

import java.awt.BorderLayout;
import java.awt.Container;
import java.util.Vector;

import javax.swing.Box;
import javax.swing.GroupLayout;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JScrollPane;
import javax.swing.JSlider;
import javax.swing.JTable;
import javax.swing.GroupLayout.Alignment;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

public class PlayListMakerDialog extends JDialog {
	private static final long serialVersionUID = -2891581224281215999L;
	private Vector<Song> songList;
	private PlaylistTableModel playlistModel;

	public PlayListMakerDialog(JamPlayer parent) {
		super();
		songList = parent.getSongList();
		
		Container pane = getContentPane();
		pane.add(Box.createVerticalStrut(20), BorderLayout.NORTH);
		pane.add(Box.createVerticalStrut(20), BorderLayout.SOUTH);
		pane.add(Box.createHorizontalStrut(20), BorderLayout.EAST);
		pane.add(Box.createHorizontalStrut(20), BorderLayout.WEST);
		// Create the dialog window
		GroupLayout layout = new GroupLayout(getContentPane());
		getContentPane().setLayout( layout );
		
		// Create the slider
		JLabel label0 = new JLabel("Play List Length: ");
		int totalTime = getTotalLength(songList);
		JSlider contentSlider = new JSlider(0, totalTime, totalTime );
		final JLabel timeLabel = new JLabel();
		timeLabel.setText( String.format("%d:%02d:%02d", (totalTime/3600), (totalTime/60)%60, totalTime%60) );
		contentSlider.addChangeListener( new ChangeListener() {
			@Override
			public void stateChanged(ChangeEvent arg0) {
				JSlider contentSlider = (JSlider) arg0.getSource();
				int time = contentSlider.getValue();
				timeLabel.setText( String.format( "%d:%02d:%02d",(time/3600), (time/60)%60, time%60) );			
			}
		});
		// TODO: Connect to handler that will populate PlaylistTableModel appropriately.
		JButton makeButton = new JButton("Make!");
		
		playlistModel = new PlaylistTableModel();
		playlistModel.set(songList);
		JTable playlistTable = new JTable(playlistModel);
		JScrollPane playlistPane = new JScrollPane(playlistTable);
		
		layout.setVerticalGroup(
				layout.createSequentialGroup()
				.addGroup( layout.createParallelGroup(Alignment.LEADING)
						.addComponent(label0)
						.addComponent(contentSlider)
						.addComponent(timeLabel)
						.addComponent(makeButton))
				.addContainerGap()
				.addComponent(playlistPane));
		
		layout.setHorizontalGroup(
				layout.createParallelGroup()
				.addGroup( layout.createSequentialGroup()
						.addComponent(label0)
						.addComponent(contentSlider)
						.addComponent(timeLabel)
						.addComponent(makeButton))
				.addComponent(playlistPane));
		this.pack();
	}
	
	public static int getTotalLength(Vector<Song> songs)
	{
		int time = 0;
		for(Song song : songs)
			time += song.getDuration();
		return time;
	}

}
