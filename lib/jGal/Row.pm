#!/usr/bin/perl

use strict;

package jGal::Row;

sub new {
	my $class = shift;
	my $self  = {
		images		=> [ ],
		max_images	=> 3
	};

	bless $self => $class;
}

##############################################################################

sub add_image {
	my ($self, $image) = @_;

	die "invalid image passed to add_image"
		unless UNIVERSAL::isa($image,'jGal::Image');

	push @{$self->{images}}, $image;
}

sub finish_up {
	my $self = shift;

	while ($self->images < $self->{max_images}) {
		push @{$self->{images}}, undef;
	}
}

sub images {
	my $self = shift;
	return @{$self->{images}};
}

sub is_full {
	my $self = shift;
	return 0 unless $self->{max_images};
	return ($self->images >= $self->{max_images});
}

sub to_html {
	my $self = shift;
	my $html = '';

	$html .= "\t\t<tr>\n";
	foreach ($self->images) {
		$html .= $_->to_html;
	}
	$html .= "\t\t</tr>\n";
}

"cetec astronomy";
