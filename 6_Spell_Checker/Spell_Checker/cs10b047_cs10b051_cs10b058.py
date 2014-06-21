#By Priya Prakash(CS10B047), Shivam Srivastava(CS10B051), Utkarsh Srivastava(CS10B058)
#This program does spell correction for three cases:
	# i) Single word spell check using brown dictionary and the dictionary available on  http://www.ngrams.info/ and the dictionary in nltk
	# ii) Phrase error correction - Depending on the context correct the word and display the ranked words
	# iii) Sentence error correction - Can handle one or two errors in the sentence.
	# In the above three cases if no error is found then the possibility of homophone is checked

import nltk as nlt
import collections as collec
import string
import operator
from nltk.corpus import words as wordDict
from nltk.corpus import brown as brownDict
from nltk.corpus import stopwords
from nltk.corpus import wordnet as wn


#Insertion/subsitution confusion matrix
	#Here the keyboard spacing is used to distinguish between the possible candidates of words as a parameter
	#Values which are relative are decided based on the distances of a letter from another on the keyboard
	#26x26 matrix for each alphabet pair entry
depMatrix =  [[1, 0.9995, 0.9997, 0.9998, 0.9998, 0.9997, 0.9996, 0.9995, 0.9993, 0.9994, 0.9993, 0.9992, 0.9993, 0.9994, 0.9992, 0.9991, 0.9999, 0.9997, 0.9999, 0.9996, 0.9994, 0.9996, 0.9999, 0.9998, 0.9995, 0.9999],

[0.9995, 1, 0.9998, 0.9997, 0.9996, 0.9998, 0.9999, 0.9999, 0.9997, 0.9998, 0.9997, 0.9996, 0.9998, 0.9999, 0.9996, 0.9995, 0.9994, 0.9997, 0.9996, 0.9998, 0.9998, 0.9999, 0.9995, 0.9997, 0.9998, 0.9996],

 [0.9997, 0.9998, 1, 0.9999, 0.9998, 0.9999, 0.9998, 0.9997, 0.9995, 0.9996, 0.9995, 0.9994, 0.9996, 0.9997, 0.9994, 0.9993, 0.9996, 0.9998, 0.9998, 0.9997, 0.9995, 0.9999, 0.9997, 0.9999, 0.9997, 0.9998], 

[0.9998, 0.9997, 0.9999, 1, 0.9999, 0.9999, 0.9998, 0.9997, 0.9995, 0.9996, 0.9995, 0.9994, 0.9995, 0.9996, 0.9993, 0.9992, 0.9997, 0.9999, 0.9999, 0.9998, 0.9996, 0.9998, 0.9998, 0.9999, 0.9997, 0.9998],

 [0.9998, 0.9996, 0.9998, 0.9999, 1, 0.9998, 0.9997, 0.9996, 0.9995, 0.9995, 0.9994, 0.9993, 0.9994, 0.9995, 0.9993, 0.9992, 0.9998, 0.9999, 0.9999, 0.9998, 0.9996, 0.9997, 0.9999, 0.9998, 0.9997, 0.9998],

 [0.9997, 0.9998, 0.9999, 0.9999, 0.9998, 1, 0.9999, 0.9998, 0.9996, 0.9997, 0.9996, 0.9995, 0.9996, 0.9997, 0.9995, 0.9994, 0.9996, 0.9999, 0.9998, 0.9999, 0.9997, 0.9999, 0.9997, 0.9998, 0.9998, 0.9997], 

[0.9996, 0.9999, 0.9998, 0.9998, 0.9997, 0.9999, 1, 0.9999, 0.9997, 0.9998, 0.9997, 0.9996, 0.9997, 0.9998, 0.9996, 0.9995, 0.9995, 0.9998, 0.9997, 0.9999, 0.9998, 0.9999, 0.9996, 0.9996, 0.9999, 0.9995],

 [0.9995, 0.9999, 0.9997, 0.9997, 0.9996, 0.9998, 0.9999, 1, 0.9998, 0.9999, 0.9998, 0.9997, 0.9998, 0.9999, 0.9996, 0.9995, 0.9994, 0.9997, 0.9996, 0.9998, 0.9999, 0.9998, 0.9995, 0.9996, 0.9999, 0.9994],

 [0.9993, 0.9997, 0.9995, 0.9995, 0.9995, 0.9996, 0.9997, 0.9998, 1, 0.9999, 0.9999, 0.9999, 0.9998, 0.9998, 0.9999, 0.9998, 0.9993, 0.9996, 0.9995, 0.9997, 0.9999, 0.9997, 0.9994, 0.9994, 0.9998, 0.9993], 

[0.9994, 0.9998, 0.9996, 0.9996, 0.9995, 0.9997, 0.9998, 0.9999, 0.9999, 1, 0.9999, 0.9998, 0.9999, 0.9999, 0.9998, 0.9997, 0.9993, 0.9996, 0.9995, 0.9997, 0.9999, 0.9997, 0.9994, 0.9995, 0.9998, 0.9994],

 [0.9993, 0.9997, 0.9995, 0.9995, 0.9994, 0.9996, 0.9997, 0.9998, 0.9999, 0.9999, 1, 0.9999, 0.9999, 0.9998, 0.9999, 0.9998, 0.9992, 0.9995, 0.9993, 0.9996, 0.9998, 0.9996, 0.9993, 0.9994, 0.9997, 0.9993],

 [0.9992, 0.9996, 0.9994, 0.9994, 0.9993, 0.9995, 0.9996, 0.9997, 0.9999, 0.9998, 0.9999, 1, 0.9998, 0.9997, 0.9999, 0.9999, 0.9991, 0.9994, 0.9993, 0.9995, 0.9997, 0.9995, 0.9992, 0.9993, 0.9996, 0.9992],

 [0.9993, 0.9998, 0.9996, 0.9995, 0.9994, 0.9996, 0.9997, 0.9998, 0.9998, 0.9999, 0.9999, 0.9998, 1, 0.9999, 0.9998, 0.9997, 0.9992, 0.9995, 0.9994, 0.9996, 0.9998, 0.9997, 0.9993, 0.9995, 0.9997, 0.9994],

 [0.9994, 0.9999, 0.9997, 0.9996, 0.9995, 0.9997, 0.9998, 0.9999, 0.9998, 0.9999, 0.9998, 0.9997, 0.9999, 1, 0.9996, 0.9995, 0.9993, 0.9996, 0.9995, 0.9997, 0.9999, 0.9998, 0.9994, 0.9995, 0.9998, 0.9995], 

[0.9992, 0.9996, 0.9994, 0.9993, 0.9993, 0.9995, 0.9996, 0.9996, 0.9999, 0.9998, 0.9999, 0.9999, 0.9998, 0.9996, 1, 0.9999, 0.9992, 0.9995, 0.9992, 0.9996, 0.9998, 0.9993, 0.9993, 0.9991, 0.9997, 0.999],

 [0.9991, 0.9995, 0.9993, 0.9992, 0.9992, 0.9994, 0.9995, 0.9995, 0.9998, 0.9997, 0.9998, 0.9999, 0.9997, 0.9995, 0.9999, 1, 0.9991, 0.9994, 0.9991, 0.9995, 0.9997, 0.9992, 0.9992, 0.999, 0.9996, 0.9989], 

[0.9999, 0.9994, 0.9996, 0.9997, 0.9998, 0.9996, 0.9995, 0.9994, 0.9993, 0.9993, 0.9992, 0.9991, 0.9992, 0.9993, 0.9992, 0.9991, 1, 0.9997, 0.9998, 0.9996, 0.9994, 0.9995, 0.9999, 0.9997, 0.9995, 0.9998], 

[0.9997, 0.9997, 0.9998, 0.9999, 0.9999, 0.9999, 0.9998, 0.9997, 0.9996, 0.9996, 0.9995, 0.9994, 0.9995, 0.9996, 0.9995, 0.9994, 0.9997, 1, 0.9998, 0.9999, 0.9997, 0.9998, 0.9998, 0.9998, 0.9998, 0.9997], 

[0.9999, 0.9996, 0.9998, 0.9999, 0.9999, 0.9998, 0.9997, 0.9996, 0.9995, 0.9995, 0.9993, 0.9993, 0.9994, 0.9995, 0.9992, 0.9991, 0.9998, 0.9998, 1, 0.9997, 0.9995, 0.9997, 0.9999, 0.9999, 0.9996, 0.9999], 

[0.9996, 0.9998, 0.9997, 0.9998, 0.9998, 0.9999, 0.9999, 0.9998, 0.9997, 0.9997, 0.9996, 0.9995, 0.9996, 0.9997, 0.9996, 0.9995, 0.9996, 0.9999, 0.9997, 1, 0.9998, 0.9998, 0.9997, 0.9996, 0.9999, 0.9995],

 [0.9994, 0.9998, 0.9995, 0.9996, 0.9996, 0.9997, 0.9998, 0.9999, 0.9999, 0.9999, 0.9998, 0.9997, 0.9998, 0.9999, 0.9998, 0.9997, 0.9994, 0.9997, 0.9995, 0.9998, 1, 0.9996, 0.9995, 0.9994, 0.9999, 0.9993], 

[0.9996, 0.9999, 0.9999, 0.9998, 0.9997, 0.9999, 0.9999, 0.9998, 0.9997, 0.9997, 0.9996, 0.9995, 0.9997, 0.9998, 0.9993, 0.9992, 0.9995, 0.9998, 0.9997, 0.9998, 0.9996, 1, 0.9996, 0.9998, 0.9998, 0.9997], 

[0.9999, 0.9995, 0.9997, 0.9998, 0.9999, 0.9997, 0.9996, 0.9995, 0.9994, 0.9994, 0.9993, 0.9992, 0.9993, 0.9994, 0.9993, 0.9992, 0.9999, 0.9998, 0.9999, 0.9997, 0.9995, 0.9996, 1, 0.9998, 0.9996, 0.9998], 

[0.9998, 0.9997, 0.9999, 0.9999, 0.9998, 0.9998, 0.9996, 0.9996, 0.9994, 0.9995, 0.9994, 0.9993, 0.9995, 0.9995, 0.9991, 0.999, 0.9997, 0.9998, 0.9999, 0.9996, 0.9994, 0.9998, 0.9998, 1, 0.9995, 0.9999], 

[0.9995, 0.9998, 0.9997, 0.9997, 0.9997, 0.9998, 0.9999, 0.9999, 0.9998, 0.9998, 0.9997, 0.9996, 0.9997, 0.9998, 0.9997, 0.9996, 0.9995, 0.9998, 0.9996, 0.9999, 0.9999, 0.9998, 0.9996, 0.9995, 1, 0.9994], 

[0.9999, 0.9996, 0.9998, 0.9998, 0.9998, 0.9997, 0.9995, 0.9994, 0.9993, 0.9994, 0.9993, 0.9992, 0.9994, 0.9995, 0.999, 0.9989, 0.9998, 0.9997, 0.9999, 0.9995, 0.9993, 0.9997, 0.9998, 0.9999, 0.9994, 1]]

engStopwords = stopwords.words('english')
contextSimilarity = []
noOfCandidatesToConsider = 7
sentencesInBrown = brownDict.sents()
print "Brown Sentences Read"
noOf2Grams = 0
noOf3Grams = 0
noOf4Grams = 0
noOf5Grams = 0
homophone_flag=0
wordProbMapping = {}
wordProbMapping2 = {}
sentenceOrderingDict = {}
ValUniGramDict = {}

#Refine sentence - remove special characters and change to lowercase for each split word
def refine(sentence):
	refinedWords = []
	for word in sentence:
		if word[0]==',' or word[0]== '?' or word[0] == '!' or word[0]== '.' or word[0] == ':' or word[0]== ';':
			word = word[1:len(word)]
		if(len(word)>=1):		
			wordLen = len(word)-1
			if word[wordLen]==',' or word[wordLen]=='?' or word[wordLen]=='!' or word[wordLen]=='.' or word[wordLen]==':' or word[wordLen]==';':
				word = word[0:len(word)-1]
		if(len(word)>0):
			refinedWords.append(word.lower())
	return refinedWords

#Read entry from the given file line by line and Map the Ngram phrase to it's occurance in a Dictionary ; flag = N
def makeNGramDict(flag):
	global noOf2Grams
	global noOf3Grams
	global noOf4Grams
	lines = nGram.readlines()
	for line in lines:
		tempLine = line.split('\t')
		keyValue = 0
		key = ''
		for item in range(len(tempLine)):
			if item==0:
				keyValue = tempLine[0]
			elif(item<len(tempLine)-1):
				key+=tempLine[item] + ' '
			else:
				key+=tempLine[item]
		key = key.strip()
		if flag==2:
			BiGramDict[key] = int(keyValue)
			noOf2Grams+=int(keyValue)
		elif flag==3:
			TriGramDict[key] = int(keyValue)
			noOf3Grams+=int(keyValue)
		elif flag==4:
			FourGramDict[key] = int(keyValue)
			noOf4Grams+=int(keyValue)

#Do for each NGram ; N=2,3,4
BiGramDict = {}
nGram = open("NGrams/w2_.txt","r")
makeNGramDict(2)
nGram.close()
print "2Gram Model Ready"

TriGramDict = {}
nGram = open("NGrams/w3_.txt","r")
makeNGramDict(3)
nGram.close()
print "3Gram Model Ready"

FourGramDict = {}
nGram = open("NGrams/w4_.txt","r")
makeNGramDict(4)
nGram.close()
print "4Gram Model Ready"



#Extracting 2,3,4-grams from brown corpus to increase information :
	#If an N-Gram already exists,increment the frequency by 1
	#Else add a new entry in the Mapping
for sentence in sentencesInBrown:
	sentence = refine(sentence)
	tempStr = ''
	for i in range(len(sentence)):
		if((len(sentence)-1-i)>=1):
			noOf2Grams+=1
			tempStr = sentence[i]+' '+ sentence[i+1]
			tempStr = tempStr.lower()
			if(tempStr in BiGramDict):
				BiGramDict[tempStr]+=1
			else:
				BiGramDict[tempStr]=1
		if((len(sentence)-1-i)>=2):
			noOf3Grams+=1
			tempStr = sentence[i]+' '+ sentence[i+1]+' '+sentence[i+2]
			tempStr = tempStr.lower()
			if(tempStr in TriGramDict):
				TriGramDict[tempStr]+=1
			else:
				TriGramDict[tempStr]=1
		if((len(sentence)-1-i)>=3):
			noOf4Grams+=1
			tempStr = sentence[i]+' '+ sentence[i+1]+' '+sentence[i+2]+' '+sentence[i+3]
			tempStr = tempStr.lower()
			if(tempStr in FourGramDict):
				FourGramDict[tempStr]+=1
			else:
				FourGramDict[tempStr]=1			
print "2-3-4Gram Model from Brown Corpus Ready"


#Once our Dictionary with all the required info is ready, find the Vocabulary Length.
Vocab =[]
for bigram in BiGramDict:
	vocabword = bigram.split()
	for wordv in vocabword:
		if(wordv in ValUniGramDict):
			ValUniGramDict[wordv]+=BiGramDict[bigram]
		else:
			ValUniGramDict[wordv]=BiGramDict[bigram]
		Vocab.append(wordv)
len_Vocab = len(set(Vocab))		


#To find possible candidates to correct the error word, get the corpora info
tempBrownWordList = brownDict.words()
brownWordList = []
wordsInInput = []
windowSize = 3
#Window of the context to check

storeIndex = 0	
#Stores the index of the misspelt word

for word in tempBrownWordList:
	brownWordList.append(word.lower())

inputWord = "dummyWord"
brownWordSet = set(brownWordList)
counter = collec.Counter(brownWordList)
len_total = len(brownWordList)+0.0


dictionaryUsed = brownWordSet
wordDictionarySet = set(wordDict.words())
#Calculates the total number of words in the brown dictionary
sizeOfDictionary = len(wordDictionarySet)+0.0


print "Dictionary read"
#Generate the list of words which can be generated from this word by insertion, deletion, substitution, transposition.
bagOfPossibleWords_level1 = []
bagOfPossibleWords_level2 = []
bagOfPossibleWords_level3 = []
filteredWords = []

#Generates all possible words from an input word which can be formed using (single) insertion, deletion, substitution, transposition.
def generateBagOfWords_level1():
	
	global bagOfPossibleWords_level1	
	#To indicate that the variable is the global variable and not a local variable
	allTheLetters = string.lowercase	
	#To get the list of all alphabets
	
	allTheLetters+='\'-'
	deleteOne = [ (inputWord[:i]+inputWord[(i+1):]) for i in range(len(inputWord))]
	insertOne = [ (inputWord[:i]+j+inputWord[i:]) for i in range(len(inputWord)+1) for j in allTheLetters]
	substituteOne = [ (inputWord[:i]+j+inputWord[(i+1):]) for i in range(len(inputWord)) for j in allTheLetters]
	transposeOne = [ (inputWord[:i]+inputWord[i+1]+inputWord[i]+inputWord[(i+2):]) for i in range(len(inputWord)-1)]
	
	bagOfPossibleWords_level1 = set(transposeOne+substituteOne+insertOne+deleteOne)
	print "\nLevel 1 bag of words generated for :",inputWord


#Generates all words using (single) insertion, deletion, substitution, transposition from the words formed in level 1.
#The result is stored in bagOfPossibleWords_level2 which includes the words generated at level 1.
def generateBagOfWords_level2():

	global bagOfPossibleWords_level2
	allTheLetters = string.lowercase
	allTheLetters+='\'-'
	deleteOne=[]
	insertOne=[]
	substituteOne=[]
	transposeOne=[]

	for word in bagOfPossibleWords_level1:
		deleteOne+= [ (word[:i]+word[(i+1):]) for i in range(len(word))]
		insertOne+= [ (word[:i]+j+word[i:]) for i in range(len(word)+1) for j in allTheLetters]
		substituteOne+= [ (word[:i]+j+word[(i+1):]) for i in range(len(word)) for j in allTheLetters]
		transposeOne+= [ (word[:i]+word[i+1]+word[i]+word[(i+2):]) for i in range(len(word)-1)]
	bagOfPossibleWords_level2 = set(transposeOne+substituteOne+insertOne+deleteOne+list(bagOfPossibleWords_level1))
	print "Level 2 bag of words generated for :",inputWord


#Not included in code. Can be uncommented to check deeper level words.
'''
def generateBagOfWords_level3():

	global bagOfPossibleWords_level3
	allTheLetters = string.lowercase
	allTheLetters+='\'-'
	deleteOne=[]
	insertOne=[]
	substituteOne=[]
	transposeOne=[]

	for word in bagOfPossibleWords_level2:
#		print "Starting level 3"
		deleteOne+= [ (word[:i]+word[(i+1):]) for i in range(len(word))]
#		print "Delete done"
#		insertOne+= [ (word[:i]+j+word[i:]) for i in range(len(word)+1) for j in allTheLetters]
#		print "Insert done"
#		substituteOne+= [ (word[:i]+j+word[(i+1):]) for i in range(len(word)) for j in allTheLetters]
#		print "Substitute done"
		transposeOne+= [ (word[:i]+word[i+1]+word[i]+word[(i+2):]) for i in range(len(word)-1)]
#		print "Transpose done"
	bagOfPossibleWords_level3 = set(transposeOne+substituteOne+insertOne+deleteOne+list(bagOfPossibleWords_level2))
	print "Level 3 words generated"
'''

#Filters the words formed in the above sets through the dictionary. Stores the words obtained in "filteredWords"
def filterWords():
	global filteredWords
	englishWords = dictionaryUsed
	for word in bagOfPossibleWords_level2:
		if word in englishWords:
			filteredWords.append(word)
	print "Possible Words Filtered Out"




dictt = brownWordSet
l = string.lowercase

def splitFromBetween(givenWord):
	finalList = []
	i = 0
	flagIfSplitIntoTwoExists = 0
	while(i<len(givenWord)):
		biggestPartOfWord_left = givenWord[0:(len(givenWord)-i)]
		biggestPartOfWord_right = givenWord[(len(givenWord)-i):len(givenWord)]

		if(biggestPartOfWord_left in dictt and biggestPartOfWord_right in dictt):
			finalList.append(biggestPartOfWord_left)
			finalList.append(biggestPartOfWord_right)
			flagIfSplitIntoTwoExists = 1
			break
#			givenWord = givenWord[(len(givenWord)-i):]
#			i = -1
		i+=1
	return finalList

def splitWordMax(givenWord):
	finalList = []
	i = 0
	while(i<len(givenWord)):
		if(givenWord in dictt):
			finalList.append(givenWord)
			break
		splitIntoTwo = splitFromBetween(givenWord)
		if len(splitIntoTwo)==0:
			biggestPartOfWord_left = givenWord[0:(len(givenWord)-i)]
			if(biggestPartOfWord_left in dictt):
				finalList.append(biggestPartOfWord_left)
				givenWord = givenWord[(len(givenWord)-i):]
				i = -1
		else:
			finalList.append(splitIntoTwo[0])
			finalList.append(splitIntoTwo[1])
			break
		i+=1
	return finalList









#Edit distance to rank the words which were obtained after getting filtered by the dictionary
#The edit distance is based on the DP technique famously called "Damerau-Levenshtien distance" which considers substitutions, insertions, 
#deletions and transpositions.
def weight_calc():
	global wordProbMapping
	global wordProbMapping2
	a = inputWord
	a = a.lower()
	edit_distance = []
	for b in filteredWords:

		b = b.lower() 
		str1 = "0"	#The first letter will never match the other string
		str2 = "0"	#The first letter will never match the other string
		str1 = str1 + a
		str2 = str2 + b


		len1 = len(str1)
		len2 = len(str2)

		#Weights for the four operations
		ci = 1.25	#Substitution and insertion are in general, equally probable.
		cd = 1.5	#Deletion is usually the least probable.
		cs = 0
		ct = 1		#Transposition is most probable in general

		i=0
		j=0
	
		cost = []
		for i in xrange(len1):
			cost.append([])
			for j in xrange(len2):
				cost[i].append(0)
	
		i=0
		j=0
		while i<len1:
			while j<len2:
				if i==0:
					cost[i][j] = j
				elif j==0:
					cost[i][j] = i
				else:
					if str1[i]==str2[j]:
						cs=0
					else:
						cs=1.25		
					cost[i][j] = min (cost[i-1][j]+cd,cost[i][j-1]+ci,cost[i-1][j-1]+ cs)
					if i-1>0 and j-1>0 and str1[i]==str2[j-1] and str1[i-1]==str2[j] and str1[i]!=str2[j]:
						cost[i][j] = min (cost[i][j], cost[i-2][j-2]+ct)                
				j=j+1
			j=0
			i=i+1
		edit_distance.append(cost[len1-1][len2-1])
	print "Edit distance Calculated for the current probable candidate"
	
	#word whose frequency has to be found
	wordProbMapping = {}
	count = []
	for word in filteredWords:	
	#Stores the frequency of each word in the array "count"
		count.append((counter[ word ]+0.5)/(len_total+0.5*sizeOfDictionary))

	#Append the approximate value(smoothened if needed) for each candidate from the corpora

	for i in range(len(edit_distance)):
	#Stores the final weight associated with each word by multiplying "distance" with "frequency of occurence" in the array "store_"
		confusionMatrixFactor = 1.0
		#If the word has been formed from the input word using an insertion or a substitution then use the confusion matrix factor
		#to influence the rankings
		#Check if the word is due to an insertion:


		if(not ('-' in filteredWords[i] or '\'' in filteredWords[i])):
			if(len(filteredWords[i])==len(inputWord)+1):	#If true then it is an insertion
				#Extract the inserted alphabet
				tempIndex = 0
				flag = 0
				while(tempIndex<len(inputWord)):
					if(filteredWords[i][tempIndex]!=inputWord[tempIndex]):
						flag = 1
						if(tempIndex==0):
							confusionMatrixFactor = depMatrix[ord(inputWord[0])-97][ord(filteredWords[i][0])-97]
						else:
							confusionMatrixFactor = max(depMatrix[ord(inputWord[tempIndex])-97][ord(filteredWords[i][tempIndex])-97],\
														depMatrix[ord(inputWord[tempIndex-1])-97][ord(filteredWords[i][tempIndex])-97])
					tempIndex+=1

				if flag==0:	#The last index of the longer word is the inserted alphabet
					confusionMatrixFactor = depMatrix[ord(inputWord[tempIndex-1])-97][ord(filteredWords[i][tempIndex])-97]



			#Check if the word is due to a substitution:
			elif(len(filteredWords[i])==len(inputWord)):
				tempIndex = 0
				flag = 0
				while(tempIndex<len(inputWord)-1):
					if(filteredWords[i][tempIndex]!=inputWord[tempIndex] and filteredWords[i][tempIndex+1]==inputWord[tempIndex+1]):
						flag = 1
						confusionMatrixFactor = depMatrix[ord(inputWord[tempIndex])-97][ord(filteredWords[i][tempIndex])-97]
					tempIndex+=1
				if flag==0:
					confusionMatrixFactor = depMatrix[ord(inputWord[tempIndex])-97][ord(filteredWords[i][tempIndex])-97]


		#Assuming single letter errors are highly probable than two letter errors; and higher the edit distance, lesser is the chance of 			#selecting that word.		
		if(filteredWords[i] in bagOfPossibleWords_level1):
			wordProbMapping[filteredWords[i]] = (count[i]*0.9995*confusionMatrixFactor)/edit_distance[i]
		else:
			wordProbMapping[filteredWords[i]] = (count[i]*0.0005)/edit_distance[i]
		#The variable "wordProbMapping" contains the mapping of each word with its weight.

	print "Weights calculated for Each Candidate"
	
	print "\nPrinting top 7 results with the weights(Context Not Applied on Rank):"
	i=0
	possibleCandidates = []
	wordProbMapping2.update(wordProbMapping)
	for w in sorted(wordProbMapping, key=wordProbMapping.get, reverse=True):
		if i==noOfCandidatesToConsider:
			break
		possibleCandidates.append(w)
		print w, wordProbMapping[w]
		i+=1
	if(i==0):
		print "No probable words found.\n"
	return possibleCandidates

#Count the no. of unigrams from the given BiGram Info for each word passed as argument
def countUnigram(word):
	count_uni=0
	for entry in BiGramDict:
		if(word in entry):
			count_uni+=BiGramDict[entry]
	return count_uni 

#Measure1: Language Model Info
	#We take into account UniGram,BiGram,TriGram,4Gram Models around the error word Index based on the history of +/- windowsSize words.
	#eg: C-3 C-2 C-1 K C1 C2 C3 = P(K|C-3C-2C-1).P(K|C-2C-1).P(K|C-1).P(C1|K).P(C1/C-1K).P(C1|C-2C-1K).P(C2|C1K).P(C2|C-1KC1).P(C3|C2C1K)
	#Given whatever term out of these 9 terms exist (for window size =3) , use them to evaluate the language model (context dependent)
def countProb(startIndex,endIndex,correctWord,storeIndex):
	#extract out the corressponding numerator and denominator Ngram and find the Probability of the requested term.	
	global ValUniGramDict
	tempStrNum = ''
	tempStrDen = ''
	numcount=0
	dencount=0
	for i in range(startIndex,endIndex+1):		#endIndex needs to be inclusive
		if(i!=storeIndex):
			if(i!=endIndex):
				tempStrNum+=wordsInInput[i]+' '
			else:
				tempStrDen = tempStrNum
				tempStrDen = tempStrDen.strip()
				tempStrNum+=wordsInInput[i]
		elif(i==storeIndex):
			if(storeIndex!=endIndex):
				tempStrNum+=correctWord+' '
			else:
				tempStrDen = tempStrNum
				tempStrDen = tempStrDen.strip()
				tempStrNum+=correctWord
	if(endIndex-startIndex==1):		#Bigram
		if(tempStrDen in ValUniGramDict):
			val=ValUniGramDict[tempStrDen]
		else:
			val=countUnigram(tempStrDen)
			ValUniGramDict[tempStrDen]=val
		if(val>0):
			if(tempStrNum in BiGramDict):
				numcount = BiGramDict[tempStrNum]
			if(numcount>0):			#exists
				return (numcount/(val+0.0))
			else:					#smoothen unseen Bigram over a seen UniGram : Explanation for Choosing the given Laplace Smoothing measure in the report.
				return (0.025/(val+(0.025*len_Vocab)))
		else:
			return 10e-15		#return a very small smoothened value if both num and denominato are not seen

	elif(endIndex-startIndex==2):	#Trigram
		if(tempStrNum in TriGramDict):
			numcount = TriGramDict[tempStrNum]
		if(tempStrDen in BiGramDict):
			dencount = BiGramDict[tempStrDen]
		if(dencount>0):
			if(numcount>0):
				return (numcount/(dencount+0.0))
			else:
				return (0.025/(dencount+(0.025*len_Vocab)))
		else:
			return 10e-15


	elif(endIndex-startIndex==3):	#Fourgram
		if(tempStrNum in FourGramDict):
			numcount = FourGramDict[tempStrNum]
		if(tempStrDen in TriGramDict):
			dencount = TriGramDict[tempStrDen]
		if(dencount>0):
			if(numcount>0):
				return (numcount/(dencount+0.0))
			else:
				return (0.025/(dencount+(0.025*len_Vocab)))
		else:
			return 10e-15
	
#stores a 0 value for semantic realtedness not found -> need to be smoothened
#stores a 1 value for some valid value found ->used to scale down other unknown values
indicatorMatrix = []
#Final matrix with zero/non-zero entries
semanticRelatedMatrix = []

def add_semantic_rel_measure(candidateWord,nonStopwordSent,flag):
	measure_lst = []
	tempIndicatorRow = []
	candW = wn.synsets(candidateWord)
	max_rel = 0

	#find greatest similarity value accross all the possible synsets 
	for k in nonStopwordSent:
		syn = wn.synsets(k)
		max_rel = 0
		for i in range(len(syn)):
			for j in range(len(candW)):
				val = syn[i].wup_similarity(candW[j])
				if val==None:
					val=0
				if( val > max_rel):
					max_rel = val
		if max_rel==0:
			max_rel = 0
		if(max_rel==0 and flag==0):
			tempIndicatorRow.append(0)
		elif (max_rel!=0 and flag==0):
			tempIndicatorRow.append(1)
		measure_lst.append(max_rel)
	if flag==0:
		semanticRelatedMatrix.append(measure_lst)
		indicatorMatrix.append(tempIndicatorRow)
	if flag==1:
		return max_rel

	
#apply tranisitivty to overcome 0 values.
#Say SemRl(A,B) is unknown - choose the minimum of the values given by the multiplication of SemRl(A,C)*SemRl(C,B) ; for all C 
def fillValueInMatrix(rowIndex,columnIndex):
	tempArray = []
	minValue = 1
	for i in range(len(indicatorMatrix[rowIndex])):
		if(indicatorMatrix[rowIndex][i]==1 and i!=columnIndex):
			tempVar = semanticMapForKnown[columnIndex][i]*semanticRelatedMatrix[rowIndex][i]
			if(tempVar>0 and tempVar<minValue):
				minValue = tempVar
	return minValue

#get the  non-zero minimum value in the column for a given stop-word
def minValInCol(columnIndex,possibleCandidates):
	minVal = 1
	for i in range(len(possibleCandidates)):
		if indicatorMatrix[i][columnIndex]==1 and minVal>semanticRelatedMatrix[i][columnIndex]:
			minVal = semanticRelatedMatrix[i][columnIndex]
	return minVal

#remove 0 values and fill with non-zero minimal approximate values
def refineMatrixValues(possibleCandidates,nonStopwordSent):
	scalingFactor = 0.1
	for i in range(len(possibleCandidates)):
		for j in range(len(nonStopwordSent)):
			if(indicatorMatrix[i][j]==0):
				tempVar = fillValueInMatrix(i,j)
				if tempVar == 1:			#even tranistivity measure didn't help us - give some very low value 
					semanticRelatedMatrix[i][j] = 10**(-3)
				else:						#else sclae it down by 90% of the minimum value in that column to get a relative low value
					semanticRelatedMatrix[i][j] = tempVar*minValInCol(j,possibleCandidates)*scalingFactor


#the SemRel is a measure = multiplication of all the SemRel with all the other maximum non-stop words values.
def getProductOfRowValues(row):
	#Now every entry is non-zero
	valToReturn = 1
	for entry in row:
		valToReturn*=entry
	return valToReturn


#To magnify better results than worse ones.
#Calculate and decide the parameter estimation/approximation based on the values seen.
	#this measure is solely based on the idea of mean,variance of the distribution of powers across results.
	#extract the log of all the values to get the appoximate power.
	#find the mean and the devaition.
	#based on the same, divide the range into sub-ranges or slots expanding left and right of the mean as : mean +/- 0.25*deviation
	#increase of slot size = 0.25,0.50,0.75.....
	#now if a value if high (higher negative value OR lesser absolute value) then it will lie in some sub-range.
	#Measure3 = (1/start_of_sub_range)**6
	#as the base is of value < 1 ; hence lower the base , lesser it gets with higher power. Hence values with high value get de-magnified to a much lesser extent than values with lesser value.Hence the Rank order remaining same but the power relatively magnified.

distanceDict = {}
semanticMapForKnown = []
import math
def magnify(rankedSentences,possibleCandidates):
	dict_map_word_power={}	
	if(len(possibleCandidates)==0):
		return
	values = []
	mean = 0.0
	sqrMean = 0.0
	deviation = 0.0
	for i in possibleCandidates:
		value = math.fabs(math.log(rankedSentences[i],10))
		values.append(value)
		dict_map_word_power[i]=value
		mean+=value
		sqrMean+=value*value
	if(len(possibleCandidates)>0):
		mean/=len(possibleCandidates)
		sqrMean/=len(possibleCandidates)
	#find mean and standard deviation	
	tempVal = sqrMean - mean*mean
	if (tempVal<0):
		deviation = 0
	else:
		deviation = (tempVal)**(0.5)
	values2 = sorted(values)
	boundaries = []
	bracket = 0.25
	bLeft = mean - bracket*deviation
	bRight = mean + bracket*deviation
	flag = 0
	counter = 0
	print "Relative Magnifaction Begins (if applicable)\n"

	#Make Boundaries left and right of the mean to assign each value a sub-range
	while(bLeft>values2[0] or bRight<values2[len(values2)-1]):
		flag=1
		tempBracket = bracket
		if(tempBracket==0.25 and counter==0):
			boundaries.append([bLeft,mean])
			boundaries.append([mean,bRight])
			counter=1
		else:
			bracket+=0.25
			bLeft = mean - bracket*deviation
			bRight = mean + bracket*deviation
			tempbLeft = mean - tempBracket*deviation
			tempbRight = mean + tempBracket*deviation
			boundaries.append([bLeft,tempbLeft])
			boundaries.append([tempbRight,bRight])
	if flag==0:
		boundaries.append([bLeft,mean])
		boundaries.append([mean,bRight])
	weightArray = []
	
	#for stopwords as better candidates
	min_v=1000
	store_word=""
	for i in range(len(values)):
		if(values[i]<min_v):
			min_v = values[i]
			store_word = possibleCandidates[i]

	wordSeen=[]
	valueSeen=[]
	finalWords = []
	#if stopwords are top contendors
	if(store_word in engStopwords):
		finalWords.append(store_word)		
		for w in sorted(dict_map_word_power, key=dict_map_word_power.get, reverse=False):
			wordSeen.append(w)
			valueSeen.append(dict_map_word_power[w])
		
		#find if any non-stop word lies within the same sub-range,then discard the stopword and carry on with normal magnification;
		#else; decalre the stop word to be the final answer and store the result.
	
		for bound in boundaries:
			if(valueSeen[0]>=bound[0] and valueSeen[0]<=bound[1]):
				avg = (bound[0]+bound[1])/2.0
				break
		next_val = avg + 0.75*deviation
		get_bound=[]
		for bound in boundaries:
			if(next_val>=bound[0] and next_val<=bound[1]):
				get_bound.append(bound)
				break
		for j in range(len(wordSeen)):
			if( j!=0):
				for bound in boundaries:
					if(valueSeen[j]>=bound[0] and valueSeen[j]<=bound[1]):
						if(bound == get_bound[0]):
							finalWords.append(wordSeen[j])			#all the words seen within acceptable range : 0.75*deviation
		flagchk=1		
		for word in finalWords:
			if word not in engStopwords:
				flagchk=0
				break
		if(flagchk==1):
			return {1:rankedSentences}
		else:
			for bound in boundaries:
				for i in range(len(values)):
					if(values[i]>=bound[0] and values[i]<=bound[1]):
						rankedSentences[possibleCandidates[i]]*=(1/bound[0])**(6)	#Relative Maginification done on each upon condn match
			print "After Magnification!"
			sort_result(rankedSentences)

			return rankedSentences
			
	#if max is not a stop word
	else:
		for bound in boundaries:
			for i in range(len(values)):
				if(values[i]>=bound[0] and values[i]<=bound[1]):
					rankedSentences[possibleCandidates[i]]*=(1/bound[0])**(6)		#Magnification Relative
		print "After Magnification!"
		sort_result(rankedSentences)

		return rankedSentences


#Tries to suggest corrections based on 4 Measures:
	#Measure 1:Language Model based on context and History
	#Measure 2:Semantic Relatedness between rare words in the sentence to detremine close associativity (smoothing and approximation needed)
	#Measure 3:De-Magnification of the Language Model Value obtained relative to each other to give higher weight to Measure1 so that Measure2 acts as a deciding factor at times of discrepancies.
	#Measure 4:Probabilty of Rank occurance of the candidate from the list based on sorted descending rank.

	#pivotalWord is defined only for 2 word errors: where this pivotalWord is fixed and the other error word in changed and evaluted.
def getContextOfEachWord(possibleCandidates,storeIndex,pivotalWord):
	global distanceDict
	global semanticMapForKnown
	print "Measures Being Evaluated"
	rankedSentences = {}
	rankedSentences2 = {}
	nonStopwordSent = [i for i in wordsInInput if (i not in engStopwords and i!=wordsInInput[storeIndex])]
	print "Non stop words in the sentence include:",nonStopwordSent
	semanticMapForKnown = [[0 for x in range(len(nonStopwordSent))] for y in range(len(nonStopwordSent))]
	rel_mes=[]

	#given windowsize=3 ; hence 9 components per candidate to be calculted for C-3 C-2 C-1 K C1 C2 C3.
	#uniquely storing each in a dictionary mapping for each word
	for word in possibleCandidates:
		nGramInputDict = {}
		if(storeIndex>=1):
			nGramInputDict[(storeIndex-1)*10+storeIndex] = countProb(storeIndex-1,storeIndex,word,storeIndex)	#P(K|C-1)
			if(storeIndex>=2):
				nGramInputDict[(storeIndex-2)*10+storeIndex] = countProb(storeIndex-2,storeIndex,word,storeIndex)	#P(K|C-2C-1)
				if(storeIndex>=3):
					nGramInputDict[(storeIndex-3)*10+storeIndex] = countProb(storeIndex-3,storeIndex,word,storeIndex)	#P(K|C-3C-2C-1)
				if(len(wordsInInput)>storeIndex+1):
					nGramInputDict[(storeIndex-2)*10+storeIndex+1] = countProb(storeIndex-2,storeIndex+1,word,storeIndex)	#P(C1|C-2C-1K)
			if(len(wordsInInput)>storeIndex+1):
					nGramInputDict[(storeIndex-1)*10+storeIndex+1] = countProb(storeIndex-1,storeIndex+1,word,storeIndex)	#P(C1/C-1K)
			if(len(wordsInInput)>storeIndex+2):
					nGramInputDict[(storeIndex-1)*10+storeIndex+2] = countProb(storeIndex-1,storeIndex+2,word,storeIndex)	#P(C2|C-1KC1)
		if(len(wordsInInput)>storeIndex+2):
					nGramInputDict[(storeIndex)*10+storeIndex+2] = countProb(storeIndex,storeIndex+2,word,storeIndex)	#P(C2|C1K)
		if(len(wordsInInput)>storeIndex+1):
					nGramInputDict[(storeIndex)*10+storeIndex+1] = countProb(storeIndex,storeIndex+1,word,storeIndex)	#P(C1|K)
		if(len(wordsInInput)>storeIndex+3):
			nGramInputDict[(storeIndex)*10+storeIndex+3] = countProb(storeIndex,storeIndex+3,word,storeIndex)	#P(C3|C2C1K)

		var=1
		for key in nGramInputDict:
			var*=nGramInputDict[key]
		
		#Store Measure1
		rankedSentences[word]=var
	print "Before Magnification"
	sort_result(rankedSentences)
	
	#Apply Measure3 : To relatively magnify the better results with respect to the worse results,i.e.another segregating measure		
	rankedSentences2 = magnify(rankedSentences,possibleCandidates)

	#if Measure 3 was of no help, i.e. stopword is the most probable replacment; declare it as correct and do not do semantic analysis.
	#else find semantic relatednss among all the possbile non-stop words.
	#Initially,find semantic measure for non-stop words in the sentence not in error; to be used as a transitive realtion measure to
	#fill in the unknown values later to relate these words with the possible candidate words.
	#Later,find one matrix measure for relatedness between each non-stop word (non-zero enties)

	if(1 in rankedSentences2):			#stop-word probable
		rankedSentences2 = rankedSentences2[1]
	else:
		for i in range(len(nonStopwordSent)):
			for j in range(len(nonStopwordSent)):
				if i==j:
					semanticMapForKnown[i][j] = 1
				else:
					mid_list=[]
					mid_list.append(nonStopwordSent[j])
					tempVal = add_semantic_rel_measure(nonStopwordSent[i],mid_list,1)		#initially for correct non-stop words.
					semanticMapForKnown[i][j] = tempVal
		rel_measure = 1
		for word in possibleCandidates:
			if word not in engStopwords:
				add_semantic_rel_measure(word,nonStopwordSent,0)

		#Measure 2 calculation - Semantic Relatedness (SemRel)

		tempPossibleCandidates = [k for k in possibleCandidates if k not in engStopwords]
		#smoothen the 0 values by applying transitivity and scaling.			
		refineMatrixValues(tempPossibleCandidates,nonStopwordSent)

		#raise the value of SemRel to again relative segregate values for their Rank Measure
		minValueForStopWords = 100000000
		for word in tempPossibleCandidates:
			tempVal = (getProductOfRowValues(semanticRelatedMatrix[tempPossibleCandidates.index(word)]))**4.28
			rankedSentences2[word]*= tempVal
			if minValueForStopWords>tempVal:
				minValueForStopWords = tempVal

		#Because SemRel is not defined for stopwords and we have seen that though it has a high probability of occurance,
		#the stopword lies way below in rank due to context measure, it will have a low rank anyhow. Hence giving it a minimal
		#value of SemRel = 0.9*min(all SemRel values)
		for word in possibleCandidates:
			if( word not in tempPossibleCandidates):
				rankedSentences2[word]*=0.9*minValueForStopWords

		#Measure 4 - Adding Probability of Rank Occurance
		if(homophone_flag==0):
			minVal = min(wordProbMapping2.values())
		else:
			minVal=1	
		for word in possibleCandidates:
			if word not in engStopwords:
				if(homophone_flag==0):
					k = wordProbMapping2[word]
				else:
					k=1
			else:
				k = 0.1*minVal
			rankedSentences2[word]*=k

	#to find the best possible pair for 2 word error - store all in a dictionary	
	if(pivotalWord!=""):
		for w in rankedSentences2:
			sentenceOrderingDict[pivotalWord][w] = rankedSentences2[w]

	
	print "Rank After Adding All Valid Measures"
	return sort_result(rankedSentences2)


#sort the result in the dictionary based on descending value
def sort_result(rankedSentences):
#	global sentenceOrderingDict
	orderedWords = []
	print "\n"	
	i = 0
	for w in sorted(rankedSentences, key=rankedSentences.get, reverse=True):
		orderedWords.append(w)
		if i==noOfCandidatesToConsider:
			break
		print w, rankedSentences[w]
		i+=1
	if(i==0):
		print "No probable words found. Enter better words!\n"
		return
	return orderedWords

#read line by line to make a list of possible homophone candidates
def readHomophones():
	homophonesFile = open("homophones.txt")
	homophoneList = []
	allHomophones = homophonesFile.readlines()
	for line in allHomophones:
		tempWords = line.split(', ')
		words = [w.strip() for w in tempWords]
		tempList = []
		for word in words:
			if(word.lower() not in engStopwords):
				tempList.append(word.lower())
		if(len(tempList)>1):
			homophoneList.append(tempList)
	return homophoneList

#read the homophones from a file
homophoneList = readHomophones()
homophoneList.append(['there','their'])
#append a missing generic case

#return the needed homophone from list
def homophoneWords(word):
	for homophone in homophoneList:
		if word in homophone:
			return homophone
	return []

#generate all homophone possibilities for the word from the corpora and check for relevance in context
def checkHomophones(wordsInInput,wordsInCorrectSentence):
	global expectedHomophoneWord
	flagIfHomophoneExists = 0
	tempInputSentence = ''
	print "Checking homophones for: ",wordsInInput
	for word in wordsInInput:
		tempInputSentence+=word
		homophonesOfWord = homophoneWords(word)
		if(len(homophonesOfWord)>0):
			flagIfHomophoneExists = 1
			storeIndex = wordsInInput.index(word)
			expectedHomophoneWord = wordsInCorrectSentence[storeIndex]
			return {1:getContextOfEachWord(homophonesOfWord,storeIndex,"")}
	if (flagIfHomophoneExists==0):
		print "Sentence was correct but sentence format may be:\n"
		combinedWords = splitWordMax(tempInputSentence)
		print combinedWords
		return {-1:combinedWords}	#No need of ranking. Everything was correct without any ambiguity.

#for all the sentences with 2 word errors: print the first 5 most probable answers
def printSentencesInOrder():
	Dict2 = {}
	DictTemp ={}
	for i in sentenceOrderingDict:
		DictTemp[i] = {}
		for j in sentenceOrderingDict[i]:
			if j in DictTemp and j!=i:
				DictTemp[j][i]*=sentenceOrderingDict[i][j]
				Dict2[j+' '+i] = DictTemp[j][i]
			else:
				DictTemp[i][j]=sentenceOrderingDict[i][j]
				Dict2[i+' '+j] = DictTemp[i][j]
	return sort_result(Dict2)



def getRank(givenWord,sortedCandidates):
	positionOfWordInOutput = 0
	if givenWord in incorrectToCorrectMap:
		expectedCorrectWords = incorrectToCorrectMap[givenWord]
	else:
		return 1.0	#The input word was not in the file. Assuming that the output was optimal. Hence returning 1.
	for candidate in sortedCandidates:
		if candidate in expectedCorrectWords:
			return 1.0/(positionOfWordInOutput+1.0)
		positionOfWordInOutput+=1
		if positionOfWordInOutput>=3:
			return 0.0


def rankPositionWise(expectedOutput,rankedHomophoneCandidates):
	for i in range(len(rankedHomophoneCandidates)):
		if i>=3:
			return 0
		if expectedOutput == rankedHomophoneCandidates[i]:
			return 1.0/(i+1.0)
	return 0


def checkWithInputAndCombination(inputWords,wordsInCorrectSentence,combinedWords):
	flagInputMatchOutput = 1
	for i in range(len(inputWords)):
		if(inputWords[i]!=wordsInCorrectSentence[i]):
			flagInputMatchOutput = 0
			break
	if(flagInputMatchOutput==1):
		return 1
	else:
		if len(wordsInCorrectSentence)!=len(combinedWords):
			return 0
		for i in range(len(combinedWords)):
			if(wordsInCorrectSentence[i]!=combinedWords[i]):
				return 0
	return 1
def compareWordToWord(wordsInSplit,wordsInCorrectSentence):
	indexOfJoinedWord = []	#Several possible places where word can occur
	if(len(wordsInSplit)==0):
		return 0
	for word in wordsInCorrectSentence:
		if(word==wordsInSplit[0]):
			indexOfJoinedWord.append(wordsInCorrectSentence.index(word))
	if len(indexOfJoinedWord)==0:
		return 0
	for j in indexOfJoinedWord:
		count=0
		for i in range(len(wordsInSplit)):
			if(wordsInSplit[i]==wordsInCorrectSentence[j+i]):
				count+=1
				pass
			else:
				break#Try next value of j
		if(count==len(wordsInSplit)):
			return 1
	return 0
#Read the input files and store the incorrect word with the possible candidates

import csv
incorrectToCorrectMap = {}
wordCandidates = []
phraseCandidates = []
sentenceCandidates = []
#wordFileMapping = {}
#phraseFileMapping = {}
#sentenceFileMapping = {}
for i in [1,2,3]:
	if(i==1):
		csvreader = csv.reader(open('../TrainData/words.tsv','r'), delimiter='\t')
		wordAndCandidatesMap = {}
		for row in csvreader:
			incorrectWord = row[0]
			wordCandidates.append(incorrectWord)
			row.remove(row[0])#Removes the first element in the list of words in 'row'
			wordAndCandidatesMap[incorrectWord] = row
		incorrectToCorrectMap.update(wordAndCandidatesMap)
	elif(i==2):
		csvreader = csv.reader(open('../TrainData/phrases.tsv','r'), delimiter='\t')
		wordAndCandidatesMap = {}
		for row in csvreader:
			incorrectWord = row[0]
			phraseCandidates.append(incorrectWord)
			row.remove(row[0])#Removes the first element in the list of words in 'row'
			wordAndCandidatesMap[incorrectWord] = row
		incorrectToCorrectMap.update(wordAndCandidatesMap)
	elif(i==3):
		csvreader = csv.reader(open('../TrainData/sentences.tsv','r'), delimiter='\t')
		wordAndCandidatesMap = {}
		for row in csvreader:
			incorrectWord = row[0]
			sentenceCandidates.append(incorrectWord)
			row.remove(row[0])#Removes the first element in the list of words in 'row'
			wordAndCandidatesMap[incorrectWord] = row
		incorrectToCorrectMap.update(wordAndCandidatesMap)

#Program execution starts from here:
#If the word is already a word in the dictionary, then no need to correct it.

#Sentence input in a loop
	#Extract individual words and remove the punctuations
	#For each word in the refined sentence, check if it is in the dictionary.
	#If it is not then extract its index and store it in "storeIndex" and find the possible candidates
	#using filterwords() after generating possible bag of words (using Levenshtein-Daramachau edit distance)
	#"possibleCandidates" stores the words in a descending rank order of probablities occurence in corpus obtained from calling "weight_calc"
	# For one/two word errors call appropriate functions to check spelling. If all words in the sentence are correct generate homophones for
	# any possible candidate whose homophone exists. If still no candidates are generated then the sentence is correct.
	# If no possible candidates are found the sentence cannot be corrected.
expectedHomophoneWord = ''
totalMRROfWords = 0.0
totalMRROfPhrases = 0.0
totalMRROfSentences = 0.0
for inputSentence in incorrectToCorrectMap:
	sentenceOrderingDict = {}
	possibleCandidatesOfIncorrect = {}
	incorrectWordIndex = {}
	homophone_flag=0
	index = 0
	rank = 0
	flag = 0
	noOfPossibleSplittings = 0
	splittingsMatched = 0
	wordsInCorrectSentence = []
	wordsInInput = inputSentence.split()
	wordsInInput = refine(wordsInInput)
	#Punctuations removed and converted to lower case after splitting
	if len(wordsInInput)>1:
		wordsInCorrectSentence = incorrectToCorrectMap[inputSentence][0].split()
		wordsInCorrectSentence = refine(wordsInCorrectSentence)
	for inputWord in wordsInInput:
		print "Word = ",inputWord
		filteredWords = []
		inputWord = inputWord.lower()
		print "Input word:", inputWord
		if(inputWord in dictionaryUsed):
			print "Correct word\n"
		#Else, Call the function to calculate the set of possible words which the user meant to enter.
		else:
			flag = 1
			storeIndex = index
			generateBagOfWords_level1()
			generateBagOfWords_level2()
			filterWords()
			possibleCandidates = weight_calc()
			if(len(possibleCandidates)==0):
				noOfPossibleSplittings+=1
				wordsInCorrectSentence = incorrectToCorrectMap[inputSentence][0].split()
				wordsInCorrectSentence = refine(wordsInCorrectSentence)
				wordsInSplit = splitWordMax(inputWord)
				print "Did you forget spaces? In that case you probably meant: ",wordsInSplit
				if(compareWordToWord(wordsInSplit,wordsInCorrectSentence)==0):#Did not match
					print "Incorrect word entered: ",inputWord
				else:#The splitting matched
					splittingsMatched+=1
			else:
				possibleCandidatesOfIncorrect[inputWord] = possibleCandidates
				print "Possible Corrections of ",inputWord, " : ", possibleCandidates
				incorrectWordIndex[inputWord] = storeIndex
				#store the possible word list with their respective indices.
		index+=1
	#Loop ends to check each word in input
	
	#All correct words - check for homophone ; else declare to be Correct
	if(noOfPossibleSplittings>0):#There was no candidate for at least one of the words. Hence, there was a splitting
		if(noOfPossibleSplittings==splittingsMatched):
			rank = 1	#All splits were correct
		else:
			rank = 0	#At least one of the splits was not as expected

	elif(flag==0):
		homophone_flag=1
		if(len(wordsInInput)<=1):
			pass
		else:
			wordsInCorrectSentence = incorrectToCorrectMap[inputSentence][0].split()
			wordsInCorrectSentence = refine(wordsInCorrectSentence)
			rankedHomophoneCandidates = checkHomophones(wordsInInput,wordsInCorrectSentence)
			if(-1 in rankedHomophoneCandidates):
				combinedWords = rankedHomophoneCandidates[-1]
				rank = checkWithInputAndCombination(wordsInInput,wordsInCorrectSentence,combinedWords)
				#Everything was correct
			else:
				print "Possible homophones:", rankedHomophoneCandidates[1]
				rank = rankPositionWise(expectedHomophoneWord,rankedHomophoneCandidates[1])
	elif(flag==1 and len(wordsInInput)==1):
		rank = getRank(inputWord,possibleCandidates)
	elif(flag==1 and len(wordsInInput)>1):
		if(len(incorrectWordIndex)==1):
		#single word in error
			expectedInOutput = wordsInCorrectSentence[incorrectWordIndex.values()[0]]
			for i in possibleCandidatesOfIncorrect:
				rankedCandidates = getContextOfEachWord(possibleCandidatesOfIncorrect[i],incorrectWordIndex[i],"")
			rank = rankPositionWise(expectedInOutput,rankedCandidates)
		elif(len(incorrectWordIndex)==2):
			expectedPairOfWords1 = wordsInCorrectSentence[incorrectWordIndex.values()[0]] +' '+ wordsInCorrectSentence[incorrectWordIndex.values()[1]]
			expectedPairOfWords2 = wordsInCorrectSentence[incorrectWordIndex.values()[1]] +' '+ wordsInCorrectSentence[incorrectWordIndex.values()[0]]
		#for 2 errors in a sentence
			print "Possible Corrections of error words are: ",possibleCandidatesOfIncorrect
			to_chk=""
			include_word=""
			count=1
			for word in possibleCandidatesOfIncorrect:
				if(count==1):
					to_chk = word
				if(count==2):
					include_word = word
				count+=1

			#form all sentences with one word in error and one in the probablecandidate list
			SentencesAll = []
			wordsAll=[]
			for i in range(len(possibleCandidatesOfIncorrect[include_word])):
				wordsAll=[]
				for j in wordsInInput:
					if( j == include_word):
						wordsAll.append((possibleCandidatesOfIncorrect[j])[i])
					else:
						wordsAll.append(j)
				SentencesAll.append(wordsAll)
			print "ALL probable sentences to be checked: ", SentencesAll			

			#call the function to get rank order for the given fixed word in a sentence
			for i in range(len(possibleCandidatesOfIncorrect[include_word])):
				indicatorMatrix = []
				semanticRelatedMatrix = []
				wordsInInput = SentencesAll[i]
				if possibleCandidatesOfIncorrect[include_word][i] in sentenceOrderingDict:
					pass
				else:
					sentenceOrderingDict[possibleCandidatesOfIncorrect[include_word][i]] = {}	
				getContextOfEachWord(possibleCandidatesOfIncorrect[to_chk],incorrectWordIndex[to_chk],possibleCandidatesOfIncorrect[include_word][i])
				

			#do the same for the other word
			SentencesAll = []
			wordsAll=[]
			for i in range(len(possibleCandidatesOfIncorrect[to_chk])):
				wordsAll=[]
				for j in wordsInInput:
					if( j == to_chk):
						wordsAll.append((possibleCandidatesOfIncorrect[j])[i])
					else:
						wordsAll.append(j)
				SentencesAll.append(wordsAll)
			print "ALL probable sentences to be checked: ", SentencesAll			

			#call the function to get rank order for the given fixed word in a sentence
			for i in range(len(possibleCandidatesOfIncorrect[to_chk])):
				indicatorMatrix = []
				semanticRelatedMatrix = []
				wordsInInput = SentencesAll[i]
				if possibleCandidatesOfIncorrect[to_chk][i] in sentenceOrderingDict:
					pass
				else:
					sentenceOrderingDict[possibleCandidatesOfIncorrect[to_chk][i]] = {}	
				getContextOfEachWord(possibleCandidatesOfIncorrect[include_word],incorrectWordIndex[include_word],possibleCandidatesOfIncorrect[to_chk][i])

	if(len(sentenceOrderingDict)>0):
		print "Final Answer Ordering is as follows:"
		sortedPairs = printSentencesInOrder()
		rank = 0	#Expecting it not to be in the list. If it exists then the number is accordingly updated.
		for entry in sortedPairs:
			if((expectedPairOfWords1 == entry) or (expectedPairOfWords2 == entry)):
				if(sortedPairs.index(entry)>=3):
					rank = 0
				else:
					rank = 1.0/(sortedPairs.index(entry)+1)
				break
	#Now a rank is available for the sentence in variable "rank"
	print "MRR for :",inputSentence," = ",rank
	if(inputSentence in wordCandidates):
		totalMRROfWords+=rank
	elif(inputSentence in phraseCandidates):
		totalMRROfPhrases+=rank
	if(inputSentence in sentenceCandidates):
		totalMRROfSentences+=rank
	#reinitialise
	indicatorMatrix = []
	semanticRelatedMatrix = []

if(len(wordCandidates)==0):
	print "No word candidates"
else:
	print "Total MRR of Words = ",totalMRROfWords/(len(wordCandidates))

if(len(phraseCandidates)==0):
	print "No phrase candidates"
else:
	print "Total MRR of phrases = ",totalMRROfPhrases/(len(phraseCandidates))

if(len(wordCandidates)==0):
	print "No sentence candidates"
else:
	print "Total MRR of sentences = ",totalMRROfSentences/(len(sentenceCandidates))
