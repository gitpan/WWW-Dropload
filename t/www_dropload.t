use strict;
use warnings;
use WWW::Dropload;
use Test::More tests => 1;

open(CFG, 'dropload.cfg');
my $username = <CFG>;
my $password = <CFG>;
close(CFG);

SKIP: {
    skip ('Dropload account not configured', 1) 
        unless ((defined $username) and (defined $password));
    my $recipient = $username;
    my $file = 't/file';
    print "Testing file upload...\n";
    ok (WWW::Dropload::upload($username, $password, $recipient, $file), 
        'Upload succeeded');
}
