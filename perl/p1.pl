#!/usr/bin/perl -w
use strict;
use warnings;

print "Hello world\n";
my $ssy = "haha";
my $num = 12;
)
print $ssy;
print "the num is $num\n";
print "num*num is ", $num*$num, "\n";


my @arr = (4,2,3);
print $arr[0], "\n";
print $arr[$#arr], "\n";
my $size_arr = @arr;
print $size_arr,"\n";
print @arr[1,2],"\n";
print @arr[0..2],"\n";
print @arr[1..$#arr],"\n";

my @sorted = sort @arr;
my @rev = reverse @arr;
print @sorted,"\n";
print @rev , "\n";

my %hh = ("apple","red","banana","yellow");
print $hh{"apple"},"\n";

foreach (@arr) {
  print "this eliment is $_\n";
}
foreach my $key (keys %hh) {
	print "the value of $key is $hh{$key}\n";
}


print "ssy"."qy\n";
print "22"x"11","\n";

open(my $in,"<", "ssy" );
open(my $out,">", "ssyo" );
my $line = <$in>;
print "$line";
my @lines = <$in>;
foreach (@lines) {
	print $out $_;
}
close $in;
close $out;

if ($ssy =~ /haha/) {
	print "haha\n";
}

my $ssyb = "haha";
$ssyb =~ s/ha/bb/;
print "$ssyb\n";

my $ssyc = "haha";
$ssyc =~ s/ha/cc/g;
print "$ssyc\n";

#while (<>) {
#  if(/a*b/) {
#		print $_;
#	}
#}


my $ssss = "Sdf";
if ($ssss =~ /sdf/i) {
	print "$ssss\n";
}

print "input your name\n";
my $name = <>;

chomp ($name);
if ($name eq "ssy") {
  print "your name is $name\n";
} else {
  print "haha $name\n";
}
my $sec = "xxxx";
print "sec is $sec\n";
my $got = <>;
chomp ($got);
while ($got ne $sec) {
	print "incorrect\n";
	$got = <>;
	chomp ($got);
}
