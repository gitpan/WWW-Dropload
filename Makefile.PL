use 5.006000;
use ExtUtils::MakeMaker;

print "To run the tests you must enter a valid dropload.com username and password\n";
my $skip_tests = prompt('Do you want to skip the tests? (y/N)');
if ($skip_tests =~ m/^y/i) {
    open(CFG, "> dropload.cfg");
    close CFG;
} else {
    my $username = prompt('Username:');
    my $password = prompt('Password:');
    
    open(CFG, "> dropload.cfg");
    print CFG "$username\n$password\n";
    close CFG;
}

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile('NAME'		=> 'WWW::Dropload',
              'VERSION_FROM'	=> 'Dropload.pm', # finds $VERSION
              'PREREQ_PM'	=> {Carp => 0, WWW::Mechanize => 0.40}, 
              clean             => {FILES => "dropload.cfg"}, 
              realclean         => {FILES => "dropload.cfg"}, 
              );
