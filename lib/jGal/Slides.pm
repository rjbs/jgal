#!/usr/bin/perl

use strict;

package jGal::Slides;

sub new {
	my $class = shift;
	my %args  = @_;

	my $self  = {
		gallery => $args{gallery} || undef,
	};

	die "no gallery given" unless $self->{gallery};

	bless $self => $class;
}

sub gallery {
	my $self = shift;
	return $self->{gallery};
}

sub slides {
	my $self = shift;
	my @images = $self->gallery->images;
	my @slides;
	
	foreach my $i (0 .. $#images) {
		push @slides, 
			jGal::Slide->new(
				image	=> $images[$i],
				prev	=> ($i == 0        ? undef : $images[$i-1]),
				next	=> ($i == $#images ? undef : $images[$i+1]),
				index	=> undef
			)
		;
	}
	return @slides;
}

package jGal::Slide;

sub new {
	my $class = shift;
	my %args  = @_;

	my $self  = {
		image	=> scalar $args{image},
		next	=> scalar $args{next},
		prev	=> scalar $args{prev},
		index	=> scalar $args{index},
	};

	die "no image given" unless $self->{image};

	bless $self => $class;
}

sub to_html {
	my $self = shift;

	my $html = "";
	
	$html .= "<html>\n<head>\n\t<title>slide</title>\n</head>\n<body>\n";
	$html .= "<img height='525' src='$self->{image}->{filename}' />\n";
	$html .= "<a href='$self->{prev}->{filename}.html'>prev</a>\n";
	$html .= "<a href='$self->{next}->{filename}.html'>next</a>\n";
	$html .= "</body>\n</html>\n";

	return $html;
}

"cetec astronomy";
