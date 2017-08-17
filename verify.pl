#!/usr/bin/perl -w

use strict;
use Test::More tests => 1;
use FileHandle;
use Digest::MD5;
use File::Slurp;

my $md5 = "";

my $size = shift || 1024*100;    # default to 100k if size not given

my @f = <DATA>;
chomp @f;
close DATA;

my $data = join "", @f;
my $fsize = length( $data );
print "Data size is " . $fsize . "\n";

if ($fsize < $size) {
    my $fh = FileHandle->new( ">>$0" );
    # add on to end
    for (my $i = 0; $i < $size - $fsize; $i++) {
        my $chr = chr( 0x21 + int(rand(0x7f-0x21)));
        print $fh $chr;
        push @f, $chr;
        if (($i+1) % 40 == 0) {
            print $fh "\n";
        }
    }    
    undef $fh;
    print "Now data size is " . length(join "", @f) . "\n";
}

my $ctx = Digest::MD5->new;
$ctx->add(join "", @f);
my $digest = $ctx->hexdigest;
print "MD5 checksum is " . $digest . "\n";

if ($md5 eq "") { # first time, need to store
    print "Storing checksum in file $0\n";
    my @lines = read_file($0);
    foreach my $line (@lines) {
        if ($line =~ /^my \$md5 = /) {
            $line = "my \$md5 = \"$digest\";";
        }
    }
    write_file($0, @lines);
    print "File written, run again for test\n";
}

is( $digest, $md5, "Checksums match");

__DATA__
