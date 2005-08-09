#!/usr/bin/perl

use strict;

use jGal;
use jGal::Image;

use Test::More 'no_plan';

my $gal = jGal->new;
isa_ok($gal, 'jGal');

my $img = jGal::Image->new($0);
isa_ok($img, 'jGal::Image');

$gal->add_image( $img );

is($gal->images, 1, 'one image in gallery');

# is($gal->to_html, "", "gallery html");
# is($gal->slides, "", "slides html");
