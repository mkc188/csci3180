/**
 * CSCI3180 Principles of Programming Languages

 * --- Declaration ---

 * I declare that the assignment here submitted is original except for source
 * material explicitly acknowledged. I also acknowledge that I am aware of
 * University policy and regulations on honesty in academic work, and of the
 * disciplinary guidelines and procedures applicable to breaches of such policy
 * and regulations, as contained in the website
 * http://www.cuhk.edu.hk/policy/academichonesty/

 * Assignment 3
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int borrowLimit = 5;
char* name;
char* id;
int holdNum;
int returnNum;
int borrowNum;
int currentLimit;

int returnBook()
{
    printf("\n... Returning Books ...\n");
    printf("Thank you, %s!  ", name);

    holdNum -= returnNum;

    if (1 == returnNum)
        printf("You've just returned [%d] book!\n", returnNum);
    else
        printf("You've just returned [%d] books!\n", returnNum);

    currentLimit = borrowLimit - holdNum;

    if (1 == currentLimit)
        printf("Now you can borrow [%d] more book.\n", currentLimit);
    else
        printf("Now you can borrow [%d] more books.\n", currentLimit);

    return holdNum;
}

int borrowBook()
{
    printf("\n... Borrowing Books ...\n");

    currentLimit = borrowLimit - holdNum;

    if (0 > currentLimit - borrowNum) {
        printf("You have exceeded your borrowing limit!\n");
        return -1;
    }

    currentLimit -= borrowNum;
    holdNum += borrowNum;

    if (1 == borrowNum)
        printf("You've just borrowed [%d] book!\n", borrowNum);
    else
        printf("You've just borrowed [%d] books!\n", borrowNum);

    if (1 == currentLimit)
        printf("Now you can borrow [%d] more book.\n", currentLimit);
    else
        printf("Now you can borrow [%d] more books.\n", currentLimit);

    return holdNum;
}

void staff()
{
    holdNum = returnBook();

    if (0 <= holdNum)
        printf("[Number of books borrowed: %d]\n", holdNum);
    else
        printf("ERROR!  You are trying to return more books than you've borrowed!\n");

    holdNum = borrowBook();

    if (0 <= holdNum)
        printf("[Number of books borrowed: %d]\n", holdNum);
    else
        printf("ERROR!  You are trying to borrow more books than your borrowing limit!\n");
}

void professor()
{
    borrowLimit = 10;

    printf("Dear Professor %s, you can borrow [%d] books in total!  Enjoy the books!\n", name, borrowLimit);

    staff();
}

void library(char *_name, char *_id, int _holdNum, int _returnNum, int _borrowNum)
{
    /* initialize all global variables */
    name = realloc(name, strlen(_name)+1);
    memcpy(name, _name, strlen(_name)+1);
    id = realloc(id, strlen(_id)+1);
    memcpy(id, _id, strlen(_id)+1);
    holdNum = _holdNum;
    returnNum = _returnNum;
    borrowNum = _borrowNum;

    printf("\n** Dear %s, welcome to the CUHK Library **\n", name);
    printf("[Number of books borrowed: %d]\n", holdNum);

    if (id[0] == 'p')
        professor();
    else
        staff();
}

int main(int argc, char *argv[])
{
    printf("\t\t### Welcome to the CUHK Library Administration System ###\n");

    library("Olivia Su", "s123", 2, 1, 3);
    library("Jimmy Lee", "p123", 5, 2, 7);
    library("Weixin Si","s234", 5, 2, 7);

    return 0;
}
