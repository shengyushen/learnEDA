#!/usr/bin/perl -w
use strict;
use warnings;

# difference between <> and <STDIN>
# <> will open all files specified in cmd line and read all their contents
# while <STDIN> only handle key board input
#while (<STDIN>) {
#while (<>) {
#	print $_
#}

foreach $a (@ARGV) {
	print "$a\n";
}
