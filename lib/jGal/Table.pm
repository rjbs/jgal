#!/usr/bin/perl

use strict;

package jGal::Table;

sub new {
	my $class = shift;
	my %args  = @_;

	my $self  = {
		group	=> ($args{group} || undef),
		rows	=> [ ],
		row_param	=> {
			class => 'jGal::Row'
		}
	};

	unless ($jGal::__row_loaded) {
		eval "require $self->{row_param}{class}";
		$jGal::__row_loaded = 1;
	}

	bless $self => $class;
}

##############################################################################

sub add_image {
	my ($self, $image) = @_;

	die "invalid image passed to add_image"
		unless UNIVERSAL::isa($image,'jGal::Image');

	$self->add_row unless $self->current_row;

	$self->add_row if $self->current_row->is_full;

	$self->current_row->add_image($image);
}

sub add_row {
	my $self = shift;
	my $row = $self->{row_param}{class}->new;
	push @{$self->{rows}}, $row;

	return $row;
}

sub finish_up {
	my $self = shift;
	$self->current_row->finish_up;
}

sub group {
	my $self = shift;
	return $self->{group};
}

sub is_full {
	my $self = shift;
	return 0;
}

sub current_row {
	my $self = shift;

	return unless @{$self->{rows}};
	return $self->{rows}[-1];
}

sub images {
	my $self = shift;
	return map { $_->images } @{$self->{rows}};
}

sub rows {
	my $self = shift;
	return @{$self->{rows}};
}

sub to_html {
	my $self = shift;
	my $html = '';

	$html .= "\t<table>\n";
	foreach ($self->rows) {
		$html .= $_->to_html;
	}
	$html .= "\t</table>\n";
}

"cetec astronomy";
