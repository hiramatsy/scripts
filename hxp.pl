#!/usr/bin/perl

use warnings;
use strict;
use feature qw/say/;

die "Usage: (this script) (input file name) (template string) (offset) (size) [delimiter]\n" if @ARGV < 4;

my ($fname, $temp_str, $ofs_str, $siz_str, $delim) = @ARGV;
$delim //= "\n";

open my $fh, '<', $fname or die "Can not open $fname: $!";

my $buf;
my $ofs = hex($ofs_str);
my $siz = hex($siz_str);

say 'File name: ', $fname;
say 'Template string: ', $temp_str;
say 'Offset: ', (sprintf "%d %x", $ofs, $ofs);
say 'Size: ', (sprintf "%d %x", $siz, $siz);
say 'Delimiter: ', $delim;

seek($fh, $ofs, 0);
read($fh, $buf, $siz);
close($fh);

say join $delim, map {sprintf "%x", $_} unpack($temp_str, $buf);

