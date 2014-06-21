On Clicking the tabs, Sort on that key.
Delete feature in LTM and optimize(build new BKT and call tbl.optimize()) --yet to test
At the end of the song go to the next song.
Implement next and previous


Documentation of JamPlayer

Authors: Shivam Srivastava (CS10B051) & Dhanvin Mehta (CS10B035)




The JamPlayer which is capable of playing mp3 format files is also capable of the following things:

-> Searching the songs in the Song Library and also suggesting songs in case you have mistyped some character/s.

-> Sorting the songs based on Title, Album, Artist, Duration just on the click of a button (Our way is unique!)

-> It supports the deleting feature. You can delete a song from the Library, even while its playing!

-> Supports the "next song" and "previous song" feature and highlights the current song being played.

-> There is an "optimize button" which is there to ensure no junk is stored in the hashtable or the BKTree.
   By "junk" we mean that words in the title of the songs who themselves aren't there in the Library.
   This button is useful as after a prolonged use of this player, suppose the user adds, deletes some songs many times
   then there are high chances that some words in the hastable and the BKTree are no longer needed. This button simply wipes
   them off.
