#!/usr/bin/perl

use warnings;
use strict;
use feature 'say';

my ($bin, $fnc) = @ARGV;

my $nmcmd = $ENV{'NM'} || 'nm';
my $objdump = $ENV{'OBJDUMP'} || 'objdump';

my @lines = split("\n", `$nmcmd -S $bin`);
my @mchs = grep {m/\b$fnc\b/} @lines;

my $rfmt = qr/^([0-9a-fA-F]+) ([0-9a-fA-F]+) T (.*)/;
my $disas_pat = qr/^(\s*)([[:xdigit:]]+)(:\s+[[:xdigit:]].*)/;
for my $r (@mchs)
{
	say $r;
	$r =~ m/$rfmt/;
	my $start_addr_str = "0x$1";
	my $start_addr = hex($1);
	my $stop_addr = $start_addr + hex($2);
	my $digit = length sprintf("%x", hex($2));
	my $stop_addr_str = sprintf("0x%08x", $stop_addr);

# objdump --wide --disassemble --start-address=0x --stop-address=0x $bin
	my $cmdstr = "$objdump -wd --start-address=$start_addr_str --stop-address=$stop_addr_str $bin";
	say $cmdstr;
	my @ls = split("\n", `$cmdstr`);
	for my $dl (@ls)
	{
		if ($dl =~ m/$disas_pat/)
		{
			my $addr = hex($2) - $start_addr;
			say $1, $2, (sprintf " (%0${digit}x)", $addr), $3;
		}
		else
		{
			say $dl;
		}
	}
}
