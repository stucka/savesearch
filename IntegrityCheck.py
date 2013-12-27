import glob
import os

print "Searching for files ..."
counterprocessed = 0
counterdeleted = 0
countergood = 0
counterupdate = 10000
localfiles = glob.glob("./*/*.html")
print str(len(localfiles)) + " files will be checked. Status report every " + str(counterupdate) + " files ..."
for localfile in localfiles:
	counterprocessed += 1
	if ((counterprocessed%counterupdate)==1): print str(counterprocessed-1) + " files looked at. " + localfile + " is next."
	a = open(localfile, "r")
#	print localfile 
	lines = a.readlines()
	if (len(lines) < 10):
		print localfile + "\ttoo short\tdeleted"
		a.close()
		os.remove(localfile)
		counterdeleted += 1
	else:
		if (lines[0].strip() == "<HTML>"):
			if (lines[-2].strip() == "</HTML>"):
				#print localfile + " works."
				countergood += 1
				a.close()
				pass
			else:
				print localfile + "\tbroken tail\tdeleted"
				a.close()
				os.remove(localfile)
				counterdeleted += 1
		else:
			print localfile + "\tbroken top\tdeleted"
			a.close()
			os.remove(localfile)
			counterdeleted += 1
		
print "\n"
print "\n"
print str(counterprocessed) + "\tfiles processed."
print str(countergood) + "\tfiles are good."
print str(counterdeleted) + "\tfiles were deleted."
