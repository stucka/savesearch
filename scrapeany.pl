#!/usr/bin/perl

use LWP::Simple;

$root="/Stucka data/savesearch";
$year=$ARGV[0];
mkdir "$root/$year" unless (-e "$root/$year");
mkdir "$root/broken" unless (-e "$root/broken");
mkdir "$root/broken/$year" unless (-e "$root/broken/$year");

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
		print("File $file is empty. Deleting.\n");
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

