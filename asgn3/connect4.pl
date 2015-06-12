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

package Connect_Four;
use strict;
use warnings;

use Computer;
use Human;

our $BOARD_W = 7;
our $BOARD_H = 6;

# use bit mask to set the board
our $MASK =    [1<<0,  1<<1,  1<<2,  1<<3,  1<<4,  1<<5,  1<<6,  1<<7,
                1<<8,  1<<9,  1<<10, 1<<11, 1<<12, 1<<13, 1<<14, 1<<15,
                1<<16, 1<<17, 1<<18, 1<<19, 1<<20, 1<<21, 1<<22, 1<<23,
                1<<24, 1<<25, 1<<26, 1<<27, 1<<28, 1<<29, 1<<30, 1<<31,
                1<<32, 1<<33, 1<<34, 1<<35, 1<<36, 1<<37, 1<<38, 1<<39,
                1<<40, 1<<41, 1<<42, 1<<43, 1<<44, 1<<45, 1<<46, 1<<47];

sub new
{
    my $class = shift;

    my @gameBoard;
    for my $i (0..$BOARD_H-1) {
        for my $j (0..$BOARD_W-1) {
            $gameBoard[$i][$j] = ' ';
        }
    }

    my $self = bless {
        gameBoard => \@gameBoard,
        playerList => [],
        bitboard => [0x0, 0x0],
        turn => 1,
    }, $class;

    return $self;
}

# main function
sub startGame
{
    my $self = shift;

    my $player = {'1' => 'Computer', '2' => 'Human'};
    my $sym = ['O', 'X'];
    my $ordinal_no = ['first', 'second'];

    # print menu for choosing player
    for (my $i=0; $i < 2; $i++) {
        my $choice = '-1';
        while ($choice ne '1' && $choice ne '2') {
            print "\nPlease choose the $$ordinal_no[$i] player:\n";
            print "1.Computer\n";
            print "2.Human\n";
            print "Your choice is: ";
            chomp($choice = <STDIN>);
            print "\n" if $choice eq "";
        }

        $self->{playerList}[$i] = ($choice eq '1') ? Player::Computer->new($$sym[$i]) : Player::Human->new($$sym[$i]);
        print "\nPlayer $self->{playerList}[$i]->{playerSymbol} is $$player{$choice}.\n";
    }

    print "\nGAME START!\n\n";

    # randomly choose which player first
    $self->{turn} = int(rand(2));

    # main loop
    while (1) {
        $self->printGameBoard([]);
        while ($self->move($self->{playerList}[$self->{turn}]->nextColumn()) == -1) {
            print "\nInvalid move, please try again";
        }
        last if ($self->gameOver() == 1);
        $self->{turn} ^= 1;
    }
}

# print game board every time player moved,
# indices indicate which position need highlight when someone won
sub printGameBoard
{
    my $self = shift;
    my ($indice) =  @_;

    my $h_rule = '';
    for (0..$BOARD_W*4) {
        $h_rule .= '-';
    }
    for my $i (1..$BOARD_W) {
        print "| $i ";
    }
    print "|\n$h_rule\n";

    for my $i (0..$BOARD_H-1) {
        my $n = $BOARD_H - $i;
        for my $j (0..$BOARD_W-1) {
            if (grep $n == $_, @$indice) {
                # make the position inverse video
                print "|\033[7m $self->{gameBoard}[$i][$j] \033[0m";
            }
            else {
                print "| $self->{gameBoard}[$i][$j] ";
            }
            $n += $BOARD_W;
        }
        print "|\n$h_rule\n";
    }
}

# make move by indicating which column(1-7), return -1 if illegal move
sub move
{
    my $self = shift;
    my ($col) = @_;

    my $legal = 0;
    foreach my $row (reverse 0..($BOARD_H-1)) {
        if ($self->{gameBoard}[$row][$col] eq ' ') {
            $self->{gameBoard}[$row][$col] = $self->{playerList}[$self->{turn}]->{playerSymbol};
            $self->{bitboard}[$self->{turn}] |= $$MASK[$BOARD_W*$col+($BOARD_H-1-$row)];
            $legal = 1;
            last;
        }
    }
    return $legal == 1 ? 0 : -1;
}

# check winning state by using bitboard algorithm
sub haswon
{
    my $self = shift;

    my $test = $self->{bitboard}[$self->{turn}];
    my $diag1 = $test & ($test >> $BOARD_H);
    my $hori = $test & ($test >> $BOARD_H+1);
    my $diag2 = $test & ($test >> $BOARD_H+2);
    my $vert = $test & ($test >> 1);

    my @truetable;
    push(@truetable, ($diag1 & ($diag1 >> 2*$BOARD_H)));
    push(@truetable, ($hori & ($hori >> 2*($BOARD_H+1))));
    push(@truetable, ($diag2 & ($diag2 >> 2*($BOARD_H+2))));
    push(@truetable, ($vert & ($vert >> 2)));

    foreach my $i (0..($#truetable-1)) {
        if ($truetable[$i] > 0) {
            $self->highlight($truetable[$i], $i);
            return 1;
        }
    }
    return 0;
}

# check whether it is a draw game
sub isdraw
{
    my $self = shift;

    for (my $i=0; $i < $BOARD_H; $i++) {
        for (my $j=0; $j < $BOARD_W; $j++) {
            return 0 if ($self->{gameBoard}[$i][$j] eq ' ');
        }
    }
    $self->printGameBoard([]);
    return 1;
}

# check whether it is game over
sub gameOver
{
    my $self = shift;

    if ($self->haswon() == 1) {
        print "\nGAME OVER. '$self->{playerList}[$self->{turn}]->{playerSymbol}' is the winner\n";
        return 1;
    }
    if ($self->isdraw() == 1) {
        print "\nDRAW.\n";
        return 1;
    }
    return 0;
}

# calculate where to highlight the winner from the winning bitboard config
sub highlight
{
    my $self = shift;
    my ($bitboard, $dir) = @_;

    my $increment = [$BOARD_H, $BOARD_H+1, $BOARD_H+2, 1];
    my $bits = sprintf("%0b", $bitboard);
    $bits = reverse $bits;
    my $indices = [];
    for my $i (0..(length($bits)-1)) {
        if (substr($bits, $i, 1) eq '1') {
            push(@$indices, $i+1);
        }
    }

    my $last_idx = $$indices[-1];
    for (0..2) {
        push(@$indices, $last_idx += $$increment[$dir]);
    }

    $self->printGameBoard($indices);
}

# program entry
my $c4 = Connect_Four->new();
$c4->startGame();
