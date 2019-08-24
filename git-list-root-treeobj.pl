#!/bin/perl

use warnings;
use strict;
use feature 'say';

my @allrevs = split "\n", `git rev-list --all`;

my %tree_commitlist;
my $re_tree_obj = qr/^tree ([[:xdigit:]]{40})$/;
for my $rev (@allrevs)
{
  my @treeobj = grep { m/$re_tree_obj/; } (split "\n", `git cat-file -p $rev`);
  if (@treeobj)
  {
    my $treeobj_hash = substr($treeobj[0], 5);
    if (exists $tree_commitlist{$treeobj_hash})
    {
      push @{$tree_commitlist{$treeobj_hash}}, ($rev);
    }
    else
    {
      $tree_commitlist{$treeobj_hash} = [$rev];
    }
  }
}

while (my ($tr, $commits) = each %tree_commitlist)
{
  say $tr, ":", (join ',', @{$commits});
}
