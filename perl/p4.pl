#!/usr/bin/perl -w
use strict;
use warnings;
use DB_File;

my %hh = (
"a",1,
"b",2,
"c",3,
);


foreach my $k (keys (%hh)) {
	print "$k to 	$hh{$k}\n";
}


@hh{"a","b","c"} = (100,200,300);

while ((my $k,my $n)=each (%hh)) {
	print "$k to 	$n\n";
}

print "trying <STDIN>\n";
while (<STDIN>) {
	print ;
}

print "trying <>\n";
while (<>) {
	if(/3/) {
		print ;
	}
}

