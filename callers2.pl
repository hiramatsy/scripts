#!/usr/bin/perl

use warnings;
use strict;
use feature 'say';

my ($bin, $fnc) = @ARGV;

my $objdump = $ENV{'OBJDUMP'} || 'objdump';

my $fcall = qr/^\s+[[:xdigit:]]+:\s+[[:xdigit:]]+\s+b\S*\s+[[:xdigit:]]+\s+<$fnc>/;
my $fcall_dl = qr/^\s+[[:xdigit:]]+:\s+[[:xdigit:]]+\s+b\S*\s+[[:xdigit:]]+\s+<$fnc\@plt>/;
my $faddr = qr/^[[:xdigit:]]+\W+<(.*)>:/;

my @alldump;
if (-f ($bin . ".disas"))
{
	my $disas_txt_file = $bin . ".disas";
	if (open(my $fh, '<', $disas_txt_file))
	{
		say "Use: ", $disas_txt_file;
		@alldump = map {chomp; $_} <$fh>;
		close($fh);
	}
}

if (!@alldump)
{
	say "Use: ", $bin;
# objdump --wide --disassemble
	@alldump = split("\n", `$objdump -wd $bin`);
}

my $currfunc;
for my $l (@alldump)
{
	if ($l =~ $faddr)
	{
		$currfunc = $1;
		next;
	}
	elsif ($l =~ $fcall)
	{
		say $l, " # ", $currfunc;
	}
	elsif ($l =~ $fcall_dl)
	{
		say $l, " # ", $currfunc;
	}
	else
	{
		# say "NOTHING ", $l;
	}
}
