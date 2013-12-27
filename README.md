A delightful muddle for ancient systems
===================

I recently got to experience the moving of a newspaper archive called SAVE Search, built by NewsBank Media Services. The archive dated to 1994, but most of the hardware seemed to come from 1998. You remember 1998 -- that's the year Bill Clinton faced sexual harassment charges from Paula Jones. That 1998.

We had no institutional knowledge of the machine, and had even temporarily misplaced the root password. It was running AIX 4.3, which, even after some settings had been fixed, still liked to crash after a few megabytes of FTP transfer.

Rather than trying to pull the non-relational database information from the server, I decided to scrape the thing instead. This is the result.



scrapeany.pl
---------

I had an existing scraper laying around from another project and repurposed it. This is in Perl. It's looking for you to feed it a year as a variable on the command line, e.g.:
*scrapeany.pl 1998*

Your base URL will be different, and presumably the naming system. Our system has URLs like this:
*http://10.227.15.111/cgi-bin/documentv1?DBLIST=mt00&DOCNUM=2776*

Which retrieves the 2776th story from the year 2000 ("mt00"). Edit the file as needed.

Note the server doesn't meet standards. If you call for a nonexistent file, you get a blank result (0 bytes) rather than a 404 error message. The scraper will download that file, save it, then purge it if it's empty. The scraper itself does no other checks; there's another process for that.

This basically looks for every file it can. If it hits 16 sequential none-existent files, it shuts down for that year.

Our server took several seconds for each request. By running multiple scrapeany.pl requests in parallel, we were able to dramatically speed up the process. That led to:

z.bat
---------

This simply calls up a stack of parallel requests in Windows. In Unix, you'd want something like
*scrapeany.pl 1994 & scrapeany.pl 1995 & scrapeany.pl & 1996*


IntegrityCheck.py
---------

Wait, did I just package a Perl scraper with a Python validity checker? Yes, yes I did.

This is reasonably fast, compared to the scraping process, because it's only using your own post-Clinton-era hardware.

0-byte files should already be purged. Our files seemed to have a fairly consistent format with headlines. If the file is too short for all of the metadata kinda stuff, it gets removed. If the file doesn't open with *&lt;HEAD&gt;*, it gets removed. If the penultimate -- second-to-last -- line isn't *&lt;/HEAD&gt;*, it gets removed. In my files, the final line was always a blank.

Removed files go to the /broken folder, named for the year.

It also reports back in a nice format that's easily imported into a spreadsheet so you can try to figure out later what's going wrong, with periodic updates that would then have to be deleted from your spreadsheet.

Basic usage
------------

So, in short:

- Tweak the scraper to fit your URL and directory structure

- Roll your own batch execution script, similar to z.bat

- Scrape away. Scrape away! Our server took about 10 hours for 190,000 files. Your mileage may vary.

- Run the integrity check. Swear at the results. This will be considerably faster than the scraping process, but will still take a while.

- Scrape again.

- Integrity check again, perhaps with a redirection to a text file. From here, you may want to individually see what's going wrong, or perhaps just run one or more scrape-integrity check cycles again.

