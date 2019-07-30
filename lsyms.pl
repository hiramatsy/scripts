#!/usr/bin/perl

use warnings;
use strict;
use feature 'say';

my ($bin, $fnc) = @ARGV;

my $nmcmd = $ENV{'NM'} || 'nm';

my @lines = split("\n", `$nmcmd -S $bin`);
my @mchs = grep {m/$fnc/} @lines;
if (!@mchs)
{
# nm --demangle --print-size $bin
	@lines = split("\n",`$nmcmd -CS $bin`); 
	@mchs = grep {m/$fnc/} @lines;
}

for my $f (@mchs)
{
	say $f;
}
