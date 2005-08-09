#!/usr/bin/perl

use strict;

package jGal::Image;

sub new {
	my $class		= shift;
	my $filename	= shift;

	bless {
		filename => $filename
	} => $class;
}

##############################################################################

sub group {
	my $self = shift;
	return $self->{group};
}

##############################################################################

sub get_info {
	my $self = shift;
	my $file = $self->filename;

	my $result = `identify -ping \"$file\"`;
	$result =~ /\s(\d+)x(\d+).*?((\d+(?:\.\d+)?)(?:k|k?b))/;
	my ($x, $y) = ($1, $2);
	my $size = $3;

	# if size is written as 500k, change it to 500kb
	$size .= 'b' if $size =~ /k$/;
	# if size is in bytes (such as 500b), strip off the b and change it to kb
	$size = sprintf("%.0fkb", $size/1000) if ($size =~ s/(\d+)b$/$1/);
	
	$self->{x} = $x;
	$self->{y} = $y;
	$self->{size} = $size;
	return $self;
}

sub resize_image {
	my $self = shift;
	my ($x, $y) = @_;
	my $file; # this gets populated with file-to-write-to later
	my $command;

	$command =
		'mogrify -geometry ' .
		($x ? $x : '') .
		($y ? "x$y" : '') .
		" \"$file\""
	;

	if (system($command)) {
		unlink $file;
		die "mogrify died!\n";
	}
}

sub to_html {
	my $self = shift;
	my $html = '';

	$html .= "\t\t\t<td><a href='$self->{filename}.html'><img height='75' src='$self->{filename}'/></a></td>\n";
}

"cetec astronomy";
