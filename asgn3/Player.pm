#!/usr/bin/perl

# CSCI3180 Principles of Programming Languages

# --- Declaration ---

# I declare that the assignment here submitted is original except for source
# material explicitly acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in academic work, and of the
# disciplinary guidelines and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/

# Assignment 3

package Player;
use strict;
use warnings;

use Carp;

sub new
{
    my $class = shift;
    my ($playerSymbol) = @_;

    my $self = bless {
        playerSymbol => $playerSymbol,
    }, $class;

    return $self;
}

sub getPlayerSymbol
{
    my $self = shift;

    return $self->{playerSymbol};
}

sub nextColumn
{
    croak 'You must override nextColumn() in a subclass';
}

1;
