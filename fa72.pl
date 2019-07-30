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
for my $r (@mchs)
{
	say $r;
	$r =~ m/$rfmt/;
	my $start_addr_str = "0x$1";
	my $stop_addr_str = sprintf("0x%08x", hex($1) + hex($2));
# objdump --wide --disassemble --start-address=0x --stop-address=0x $bin
	my $cmdstr = "$objdump -wd --start-address=$start_addr_str --stop-address=$stop_addr_str $bin";
	say $cmdstr;
	my $list = `$cmdstr`;
	my @callings = grep {/b\S*\s+[[:xdigit:]]+\s+<[^>+]+>/} split('\n', $list);
	say $list;
	say "CallLists:";
	for my $call (@callings)
	{
		say $call;
	}
}
