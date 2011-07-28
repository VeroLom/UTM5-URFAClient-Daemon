#!/usr/bin/perl

use strict;
use warnings;

use lib 'UTM5-URFAClient-Daemon/lib';
use UTM5::URFAClient::Daemon;

my $daemon = UTM5::URFAClient::Daemon->new({ config => 'daemon.conf' })
	or die "Error when starting server: $!\n";
