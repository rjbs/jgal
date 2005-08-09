#!/usr/bin/perl

use strict;

package jGal::Page;

sub new {
	my $class = shift;
	my $self  = {
		max_images	=> 20,
		tables		=> [ ],
		table_param	=> {
			class => 'jGal::Table'
		}
	};

	unless ($jGal::__table_loaded) {
		eval "require $self->{table_param}{class}";
		$jGal::__table_loaded = 1;
	}
	
	bless $self => $class;
}

##############################################################################

sub add_image {
	my ($self, $image) = @_;

	die "invalid image passed to add_image"
		unless UNIVERSAL::isa($image,'jGal::Image');

	$self->add_table unless $self->current_table;

	$self->add_table if $self->current_table->is_full;

	$self->current_table->add_image($image);
}

sub add_table {
	my $self = shift;
	my $table = $self->{table_param}{class}->new;
	push @{$self->{tables}}, $table;

	return $table;
}

sub current_group {
	my $self = shift;

	return unless $self->current_table;
	$self->current_table->group;
}

sub current_table { 
	my $self = shift;

	return unless @{$self->{tables}};
	return $self->{tables}[-1];
}

sub images {
	my $self = shift;
	return map { $_->images } @{$self->{tables}};
}

sub is_full {
	my $self = shift;

	return 0 unless $self->{max_images};
	return 1 if ($self->images >= $self->{max_images});
}

sub set_group {
	my $self  = shift;
	my $group = shift;

	$self->current_table->finish_up;
	$self->add_table(group => $group);
}

sub tables {
	my $self = shift;
	return @{$self->{tables}};
}

sub to_html {
	my $self = shift;
	my $html = '';

	$html .= "<html>\n<head>\n\t<title>page</title>\n</head>\n<body>\n";
	foreach ($self->tables) {
		$html .= $_->to_html;
	}
	$html .= "</body>\n</html>\n";
}

"cetec astronomy";
