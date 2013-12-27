#!/usr/bin/perl

use LWP::Simple;

foreach my $year($ARGV[0]...$ARGV[0]){
    if (-d "/Stucka data/savesearch/$year"){
	print("Directory exists\n");
    }else{
	mkdir("/Stucka data/savesearch/$year");
    }
#	$shortyear=$year%100;
	$shortyear=substr($year, -2);
    $x = 0;
    foreach my $docnum('1'...'999999'){
	$url = "http://10.227.15.111/cgi-bin/documentv1?DBLIST=mt$shortyear&DOCNUM=$docnum";
	$file = "/Stucka data/savesearch/$year/$year-$docnum.html";
#### CONSIDER UNCOMMENTING THIS:
#	print("$url\n");
	if(-e $file){
#### CONSIDER UNCOMMENTING THIS:
#	print("File Exists, skipping.\n");
	$x=0;
	}else{
	    if(is_success(getstore($url,$file))){
#		print("File $shortyear $url downloaded\n");
		if((-s $file) == 0){
			$x++;
			print("File $file is crap. Deleting.\n");
			unlink($file);
			}else{
			$x=0;
			}
		if($x > 15){
		   print("Giving up on year $year after $docnum \n");
		   last;
		}
	    } 
	}
    }
}
