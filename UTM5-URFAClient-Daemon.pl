#!/usr/bin/perl

use strict;
use warnings;

use lib 'UTM5-URFAClient-Daemon/lib';
use UTM5::URFAClient::Daemon;

use Proc::Daemon;

my $daemon = Proc::Daemon->new(
	work_dir		=> "/tmp",
	child_STDOUT	=> *STDOUT,
	child_STDERR	=> *STDERR,
	pid_file		=> 'urfadaemon.pid',
	exec_command	=> "perl -MUTM5::URFAClient::Daemon -e 'UTM5::URFAClient::Daemon->new({ config => \"/usr/local/etc/daemon.conf\" })'"
);

if(not $ARGV[0]) {
	print "Usage: $0 {start|status|stop}\n";
	exit 1;
}


# Get pid
my $pid = (-e '/tmp/urfadaemon.pid') ? `cat /tmp/urfadaemon.pid` : 0;

# Start daemon
if($ARGV[0] eq 'start') {
	# Check for PID
	if($pid) {
		print "Service already work (PID $pid)\n";
	} else {
		$pid = $daemon->Init;
		print "Service started. PID $pid\n";
	}
}

# Daemon status
if($ARGV[0] eq 'status') {
	if($pid) {
		print "Status: ".$daemon->Status($pid)."\n";
	} else {
		print "Service not started\n";
	}
}

# Stop daemon
if($ARGV[0] eq 'stop') {
	if($pid) {
		print "Trying to shudtown urfadaemon (PID $pid)...";

		if($daemon->Kill_Daemon($pid)) {
			unlink "/tmp/urfadaemon.pid";
			print "OK\n";
		} else {
			print "FAIL\n";
		}
	} else {
		print "Service not started\n";
	}
}
