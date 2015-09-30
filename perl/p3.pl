#!/usr/bin/perl -w
use strict;
use warnings;
use DB_File;

print "\Ufred\n";
print "\ufred\n";
print "\LFRED\n";
print "\lFRED\n";

my $sdf = 1;
my @arr = ($sdf,2);
foreach (@arr) {
 print "$_\n";
}

$arr[1] = 3;
foreach (@arr) {
 print "$_\n";
};
foreach my $i (@arr) {
	print "$i\n";
}
