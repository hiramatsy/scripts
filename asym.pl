#!/usr/bin/perl

use warnings;
use strict;
use feature 'say';

my ($bin, $addr_str) = @ARGV;

my $nmcmd = $ENV{'NM'} || 'nm';

# nm --size-sort --numeric-sort --print-size $bin
my @lines = split("\n", `$nmcmd --size-sort -nS $bin`);
my $pat = qr/^([[:xdigit:]]+)\s+/;

my $addr = hex($addr_str);
my $prev_line;
my $prev_addr;

for my $l (@lines)
{
	unless ($l =~ m/$pat/)
	{
		next;
	}

	my $start = hex($1);
	if ($start > $addr)
	{
		say $prev_line, " # Displacement: ", (sprintf "%d", $addr - $prev_addr);
		last;
	}
	$prev_line = $l;
	$prev_addr = $start;
}

