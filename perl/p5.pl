#!/usr/bin/perl -w
use strict;
use warnings;
use DB_File;

while (<>) {
	if(/ab*c/) {
		s/ab*c/def/;
		print ;
	}
}


sub add {
	my $sum = 0;
	foreach my $i (@_) {
		$sum += $i;
	}
	return $sum;
}

print ((add((0,1,2,3))),"\n");
