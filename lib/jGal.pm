#!/usr/bin/perl

use strict;

package jGal;

our $VERSION = 1.0;

sub new {
	my $class = shift;
	my $self  = {
		pages			=> [],
		page_param		=> {
			class => 'jGal::Page'
		},
		slides_param	=> {
			class => 'jGal::Slides'
		}
	};

	unless ($jGal::__page_loaded) {
		eval "require $self->{page_param}{class}";
		$jGal::__page_loaded = 1;
	}

	bless $self => $class;
}

sub add_image {
	my ($self, $image) = @_;
	
	die "invalid image passed to add_image"
		unless UNIVERSAL::isa($image,'jGal::Image');

	$self->add_page unless $self->current_page;

	$self->set_group($image->group)
		unless ($self->current_group eq $image->group);

	$self->add_page if $self->current_page->is_full;

	$self->current_page->add_image($image);
}

sub add_page {
	my $self = shift;
	my $page = $self->{page_param}{class}->new;
	push @{$self->{pages}}, $page;

	return $page;
}

sub current_group {
	my $self = shift;
	$self->current_page->current_group;
}

sub current_page {
	my $self = shift;

	return unless @{$self->{pages}};
	return $self->{pages}[-1];
}

sub pages {
	my $self = shift;
	return @{$self->{pages}};
}

sub images {
	my $self = shift;
	return map { $_->images } @{$self->{pages}};
}

sub to_html {
	my $self = shift;
	my $html = '';

	$html .= "<gallery>\n";
	foreach ($self->pages) {
		$html .= $_->to_html;
	}
	$html .= "</gallery>\n";
}

sub slides {
	my $self = shift;

	unless ($jGal::__slides_loaded) {
		eval "require $self->{slides_param}{class}";
		$jGal::__slides_loaded = 1;
	}
	
	if ($self->images) {
		return jGal::Slides->new(gallery => $self)->slides
	}
}

"cetec astronomy";
