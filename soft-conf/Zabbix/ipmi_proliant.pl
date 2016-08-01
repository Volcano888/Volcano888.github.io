#!/usr/bin/perl
#
#HP iLO data collector script for Zabbix
#Written by Vladislav Vodopyan, 2013-2014
#Contact: ra1aie@ra1aie.ru
#

use strict;
no warnings 'all';
use Fcntl ':flock';

my $sensor = $ARGV[0];
my $class = $ARGV[1];
my $server = $ARGV[2];
my $user = $ARGV[3];
my $pass = $ARGV[4];
my $type = $ARGV[5];
our $debug = 0;

exit(1) if not defined $server or not defined $sensor or not defined $class;

#sleep random 1 seconds
#use Time::HiRes qw(usleep nanosleep);
#usleep (int(1000000 * rand(1)));

$type = 'numeric' if not defined $type;

$sensor =~ s/\'//g;
$server =~ tr/"//d;
$server =~ tr/'//d;

my $expires = 60;

#my $user = 'Administrator';
#my $pass = 'AD8T9AFQ';

my $ipmi_cmd = '';
my $cache_file = '';

sub debugMsg {
	if($debug == 1) {
		print("DEBUG: " . $_[0] . "\n");
	}
}

if($class eq 'sensor') {
        $cache_file = '/var/tmp/ipmi_sensors_'.$server;
        $ipmi_cmd = '/usr/sbin/ipmi-sensors -D LAN2_0 -h '.$server.' -u '.$user.' -p '.$pass.' -l USER -W discretereading --no-header-output --quiet-cache --sdr-cache-recreate --comma-separated-output --entity-sensor-names 2>/dev/null';
} elsif($class eq 'chassis') {
        $cache_file = '/var/tmp/ipmi_chassis_'.$server;
        $ipmi_cmd = '/usr/sbin/ipmi-chassis -D LAN2_0 -h '.$server.' -u '.$user.' -p '.$pass.' -l USER -W discretereading --get-status 2>/dev/null';
} elsif($class eq 'fru') {
        $cache_file = '/var/tmp/ipmi_fru_'.$server;
        $ipmi_cmd = '/usr/sbin/ipmi-fru -D LAN2_0 -h '.$server.' -u '.$user.' -p '.$pass.' -l USER -W discretereading 2>/dev/null';
} elsif($class eq 'bmc') {
        $cache_file = '/var/tmp/ipmi_bmc_'.$server;
        $ipmi_cmd = '/usr/sbin/bmc-info -D LAN2_0 -h '.$server.' -u '.$user.' -p '.$pass.' -l USER -W discretereading 2>/dev/null';
} else {
	debugMsg("Exiting, invalid second cmd line parameter.");
        exit(1);
}
debugMsg("IPMI CMD: " . $ipmi_cmd);
debugMsg("Cache file: " . $cache_file);

my @rows = ();
my @stat = ();
my $delta = 0;
my $size = 0;

#Get cache file age in seconds if it exists
if(-e $cache_file) {
        @stat = stat($cache_file);
        $delta = time() - $stat[9];
        $size = $stat[7];
	debugMsg("Cache file exists, size: " . $size . "b, age: " . $delta . "s");
	
} else {
	debugMsg("Cache file does not exist yet");
}

#Refresh cache file if it does not exist or is outdated
if($delta > $expires or $delta < 0 or not -e $cache_file) {
	debugMsg("Opening cache file for writing");
	open(CACHE, '>>', $cache_file);
	debugMsg("Acquiring exclusive lock on cache file");
	if(flock(CACHE, LOCK_EX)) {
		debugMsg("Exclusive write lock acquired, refreshing file stat");
		#Check again if the cache needs refreshing, only after now that we've acquired a write lock.
		#(makes sure this thread is the only thread refreshing at the same time, -and- that another thread hasn't refreshed the cache file while we were waiting for an exclusive lock)
		@stat = stat($cache_file);
		$delta = time() - $stat[9];
                $size = $stat[7];
		debugMsg("Cache file size: " . $size . "b, age: " . $delta . "s");
		if($delta > $expires or $delta < 0 or $size == 0 or not -e $cache_file) {
			debugMsg("Cache file expired or cache file size = 0");
			#Only now that we've got an exclusive lock -and- a verified outdated cache file, we want to issue the $ipmi_cmd
			#Again the locking makes sure no other threads are running the $ipmi_cmd at the same time
			my $results = results(); 
			if(defined $results) {
				debugMsg("Got valid results from ipmi_cmd, truncating cache file and writing new results.");
				truncate(CACHE, 0);
				print CACHE $results;
        		} else {
				debugMsg("Didn't get any valid results from ipmi_cmd, keeping current cache file intact");
			}
		} else {
			debugMsg("Not refreshing cache file, current cache file seems OK. Another racing thread probably just refreshed it.");
		}
		debugMsg("Closing write handle");
		close(CACHE);
	} else {
		debugMsg("Couldn't acquire exclusive lock on cache file");
	}
} else {
	debugMsg("Not refreshing cache file, current cache file seems OK");
}

#Cache reading now that we know we have a proper cache file
debugMsg("Opening cache file for read mode");
open(CACHE, '<' . $cache_file);
debugMsg("Acquriing shared lock");
flock(CACHE, LOCK_SH); #Read only operations should apply a shared lock.
debugMsg("Reading cache file to variable");
@rows = <CACHE>;
debugMsg("Closing cache file handle"); 
close(CACHE);


foreach my $row (@rows) {
    if($class eq 'sensor') {
        my @cols = split(',', $row);
        if($cols[1] eq $sensor) {
                if($type eq 'discrete') {
                    my $r = $cols[5];
                    $r =~ s/\'//g;
                    chop($r);
                    print $r;
                } elsif($type eq 'numeric') {
                    if($cols[3] eq '' or $cols[3] eq 'N/A') {
                        print "0";
                    } else {
                        print $cols[3];
                    }
                }
        }
    } elsif(($class eq 'chassis') or ($class eq 'bmc')) {
            my @cols = split(':', $row);
            my $name=$cols[0];
            $name=~ s/(\s+)/ /gi;
            $name=substr($name, 0, -1);
            if($name eq $sensor) {
                    my $r = $cols[1];
                    $r =~ s/\'//g;
                    $r =~ s/^.//s;
                    chop($r);
                    print $r;
            }
    } elsif($class eq 'fru') {
            my @cols = split(':', $row);
            my $name=$cols[0];
            substr($name, 0, 2) = '';
            if($name eq $sensor) {
                    my $r = $cols[1];
                    $r =~ s/\'//g;
                    $r =~ s/^.//s;
                    chop($r);
                    print $r;
            }
    }
}

sub results {
    my $results = `$ipmi_cmd`;
    if((defined $results) and (length $results > 0)) {
        return $results;
    } else {
        return undef;
    }
}

