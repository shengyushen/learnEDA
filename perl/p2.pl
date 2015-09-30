#!/usr/bin/perl -w
use strict;
use warnings;
use DB_File;

my $name = "   xXsdf";
$name =~ s/\W*//;
print "$name\n";

$name =~ 	tr/A-Z/a-z/;
print "min $name\n";

my %mapping = ();

init_word();


my $key = <>;
chomp ($key);
my $name1 = <>;
chomp ($name1);

while (!good($key, $name1)) {
	print "not good $key and $name1\n";

 $key = <>;
chomp ($key);
 $name1 = <>;
chomp ($name1);
};

sub init_word {
	my $nn = "";
	my $kk = "";
	my $fn = "";
	dbmopen (%mapping,"lastdb",0666) || die "can not open lastdb\n";
	while ( defined($fn = glob("secret*")) ) {
		open(my $iff,"<",$fn) || die "can not open secret\n";
		while(defined ($kk = <$iff>)) 	{
			chomp($kk);
			$nn = <$iff>;
			chomp($nn);
			$mapping{$kk} = $nn;
			write;
			#print "$kk $nn\n";
		};
		close($iff) || die "can not close secret\n";
	};
	dbmclose(%mapping) || die "can not close lastdb\n";
format STDOUT =
@<<<<<<<<<<<<<  @<<<<<<<<<<<<
$kk, $nn
.
format STDOUT_TOP = 
Page @<<
$%

Key    nn
=====	=====
.

};

sub good {
	my ($key,$result) = @_;
	print "$key mapping to ",$mapping{$key}," and nn $result\n";
	if ($key eq "ww") {
		return 1;
	} elsif ( ($mapping{$key}|| "ZZ") eq "YY") {
		return 1;
	} else {
		return 0;
	}
};
