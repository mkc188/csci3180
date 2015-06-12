# CSCI3180 Principles of Programming Languages

# --- Declaration ---

# I declare that the assignment here submitted is original except for source
# material explicitly acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in academic work, and of the
# disciplinary guidelines and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/

# Assignment 3

use feature ':5.10';

use warnings;



local $borrowLimit = 5;



sub returnBook {

        my ($name, $holdNum, $returnNum) = @_;



        print "\n... Returning Books ...\n";

        print "Thank you, $name!  ";



        $holdNum -= $returnNum;



        if (1 == $returnNum) {

                print "You've just returned [$returnNum] book!\n";

        }

        else {

                print "You've just returned [$returnNum] books!\n";

        }



        my $currentLimit = $borrowLimit - $holdNum ;

        if (1 == $currentLimit) {

                print "Now you can borrow [$currentLimit] more book.\n";

        }

        else {

                print "Now you can borrow [$currentLimit] more books.\n";

        }



        return $holdNum;

}



sub borrowBook {

        my ($name, $holdNum, $borrowNum) = @_;



        print "\n... Borrowing Books ...\n";



        my $currentLimit = $borrowLimit - $holdNum;

        if (0 > ($currentLimit - $borrowNum)) {

                print "You have exceeded your borrowing limit!\n";

                return -1;

        }



        $currentLimit -= $borrowNum;



        $holdNum += $borrowNum;



        if (1 == $borrowNum) {

                print "You've just borrowed [$borrowNum] book!\n"

        }

        else {

                print "You've just borrowed [$borrowNum] books!\n"

        }



        if (1 == $currentLimit) {

                print "Now you can borrow [$currentLimit] more book.\n";

        }

        else {

                print "Now you can borrow [$currentLimit] more books.\n";

        }



        return $holdNum;

}



sub staff {

        my ($name, $holdNum, $returnNum, $borrowNum) = @_;



        # Returning books

        $holdNum = returnBook($name, $holdNum, $returnNum);



        if ( 0 <= $holdNum) {

            print "[Number of books borrowed: $holdNum]\n";

        }

        else {

            print "ERROR!  You are trying to return more books than you've borrowed!\n"

        }





        # Borrowing books

        $holdNum = borrowBook($name, $holdNum, $borrowNum);



        if (0 <= $holdNum) {

                print "[Number of books borrowed: $holdNum]\n";

        }

        else {

            print "ERROR!  You are trying to borrow more books than your borrowing limit!\n"

        }

}



sub professor {

        my ($name, $holdNum, $returnNum, $borrowNum) = @_;



        local $borrowLimit = 10;



        print "Dear Professor $name, you can borrow [$borrowLimit] books in total!  Enjoy the books!\n";



        staff($name, $holdNum, $returnNum, $borrowNum);

}



sub library {

        my ($name, $ID, $holdNum, $returnNum, $borrowNum) = @_;



        print "\n** Dear $name, welcome to the CUHK Library **\n";

        print "[Number of books borrowed: $holdNum]\n";



        if ($ID =~ /p/) {

                professor($name, $holdNum, $returnNum, $borrowNum);

        }

        else {

                staff($name, $holdNum, $returnNum, $borrowNum);

        }

}





print "\t\t### Welcome to the CUHK Library Administration System ###\n";



library("Olivia Su", "s123", 2, 1, 3);

library("Jimmy Lee", "p123", 5, 2, 7);

library("Weixin Si","s234", 5, 2, 7);

