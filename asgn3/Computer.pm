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

package Player::Computer;
use parent 'Player';

use strict;
use warnings;

our $BOARD_W = 7;
our $BOARD_H = 6;

sub new
{
    my $class = shift;
    my ($playerSymbol) = @_;

    return $class->SUPER::new(@_);
}

sub nextColumn
{
    my $self = shift;

    while (1) {
        print "\nThis is ${\$self->getPlayerSymbol()}\'s turn. Computing... ";
        my $next_col = int(rand($BOARD_W));
        print "Finished\n\n";
        return $next_col;
    }
}

1;
