package WWW::Dropload;

$WWW::Dropload::VERSION = '0.1';

use strict;
use warnings;
use File::Spec::Functions qw(catdir);
use WWW::Mechanize;
use Carp qw(croak);

my $_LOGIN_PAGE = 'http://dropload.com/';
my $_LOGIN_FORM = 'loginForm';
my $_EMAIL_FIELD = 'email';
my $_PASSWORD_FIELD = 'password';

my $_UPLOAD_FORM = 'sendForm';
my $_RECIPIENT_FIELD = 'recipient';
my $_FILENAME_FIELD = 'filename1';

=head1 NAME

WWW::Dropload - Handles uploading of files to dropload.com

=head1 SYNOPSIS

    use WWW::Dropload;

    WWW::Dropload::upload($username, $password, $recipient, $file);

=head1 DESCRIPTION

WWW::Dropload provides an API to upload files to dropload.com.

PLEASE NOTE: dropload.com is not responsible for this script! 
             Please do not send them email about it!

=head1 INTERFACE

=head2 METHODS

=over

=item upload()

Uploads a file to dropload.com. 
Takes username, password, recipient, and path to the file to upload.

=cut

sub upload {
    
    # Required parameters
    my ($username, $password, $recipient, $path) = @_;
    croak("The upload() method needs a username, password, " . 
          "the recipient, and the path to a file") 
        unless ((defined $username) and (defined $password) and 
                (defined $recipient) and (defined $path));
    
    # Check specified file exists
    croak("The file '$path' cannot be read") unless (-r $path);
    
    # Fail if we cannot get dropload.com
    my $mech = WWW::Mechanize->new();
    $mech->get( $_LOGIN_PAGE ); 
    croak("Cannot open page '$_LOGIN_PAGE'") unless ( $mech->status == '200');
    
    # Fill in & submit the login form
    $mech->form_name($_LOGIN_FORM);
    $mech->field($_EMAIL_FIELD, $username);
    $mech->field($_PASSWORD_FIELD, $password);
    $mech->submit();
    
    # Check the login succeeded
    croak("Login failed") unless ( $mech->status == '200' and 
                                   $mech->response()->content =~ m/.*Send A File.*/);
    
    # Fill in & submit the upload form
    $mech->form_name($_UPLOAD_FORM);
    $mech->field($_RECIPIENT_FIELD, $recipient);
    $mech->field($_FILENAME_FIELD, $path);
    $mech->submit();
    
    # Check the upload succeeded
    croak("Upload failed") unless ( $mech->status == '200' and 
                                    $mech->response()->content =~ m/.*Been Received.*/ );
}

=back

=head1 BUGS

Bound to be.
Error handling could certainly be better.
 
=head1 AUTHOR

Duane P. Griffin (duaneg@dghda.com)

=head1 LICENSE
                                                                      
  WWW::Dropload - Module providing API to upload files to dropload.com.
  Copyright (C) 2004 Duane P. Griffin (duaneg@dghda.com) and 
                     Process Systems Enterprise Ltd (www.psenterprise.com).
                                                                      
  This module is free software; you can redistribute it and/or modify it
  under the terms of either:
                                                                      
  a) the GNU General Public License as published by the Free Software
  Foundation; either version 1, or (at your option) any later version,                                                                      
  or
                                                                      
  b) the "Artistic License" which comes with this module.
                                                                      
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either
  the GNU General Public License or the Artistic License for more details.
                                                                      
  You should have received a copy of the Artistic License with this
  module, in the file ARTISTIC.  If not, I'll be glad to provide one.
                                                                      
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  USA

=cut

1;
