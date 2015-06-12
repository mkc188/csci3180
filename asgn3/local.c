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

/* enum to index elements in varList */
enum {BORROWLIMIT, NAME, ID, HOLDNUM, RETURNNUM, BORROWNUM, CURRENTLIMIT};

/* struct of element in the mixed type array varList */
typedef struct {
    union {
        int i;
        char *s;
    } val;
} Var;

int borrowLimit = 5;
char* name;
char* id;
int holdNum;
int returnNum;
int borrowNum;
int currentLimit;

/* save all the variables to a array of Var when entering new scope */
Var *pushVar()
{
    Var *varList = malloc(sizeof(Var)*7);
    varList[BORROWLIMIT].val.i = borrowLimit;
    varList[NAME].val.s = malloc(strlen(name)+1);
    strncpy(varList[NAME].val.s, name, strlen(name)+1);
    varList[ID].val.s = malloc(strlen(id)+1);
    strncpy(varList[ID].val.s, id, strlen(id)+1);
    varList[HOLDNUM].val.i = holdNum;
    varList[RETURNNUM].val.i = returnNum;
    varList[BORROWNUM].val.i = borrowNum;
    varList[CURRENTLIMIT].val.i = currentLimit;
    return varList;
}

/* restore all the variables from the array of var when leaving current scope */
void popVar(Var *varList)
{
    borrowLimit = varList[BORROWLIMIT].val.i;
    strncpy(name, varList[NAME].val.s, strlen(varList[NAME].val.s)+1);
    strncpy(id, varList[ID].val.s, strlen(varList[ID].val.s)+1);
    holdNum = varList[HOLDNUM].val.i;
    returnNum = varList[RETURNNUM].val.i;
    borrowNum = varList[BORROWNUM].val.i;
    currentLimit = varList[CURRENTLIMIT].val.i;
    free(varList[NAME].val.s);
    free(varList[ID].val.s);
    free(varList);
}

int returnBook()
{
    Var *varList = pushVar();

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

    /* set the value for return */
    varList[HOLDNUM].val.i = holdNum;
    popVar(varList);
    return holdNum;
}

int borrowBook()
{
    Var *varList = pushVar();

    printf("\n... Borrowing Books ...\n");

    currentLimit = borrowLimit - holdNum;

    if (0 > currentLimit - borrowNum) {
        printf("You have exceeded your borrowing limit!\n");
        popVar(varList);
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

    /* set the value for return */
    varList[HOLDNUM].val.i = holdNum;
    popVar(varList);
    return holdNum;
}

void staff()
{
    Var *varList = pushVar();

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

    popVar(varList);
}

void professor()
{
    Var *varList = pushVar();

    borrowLimit = 10;

    printf("Dear Professor %s, you can borrow [%d] books in total!  Enjoy the books!\n", name, borrowLimit);

    staff();

    popVar(varList);
}

void library(char *_name, char *_id, int _holdNum, int _returnNum, int _borrowNum)
{
    /* initialize all global variables */
    name = realloc(name, strlen(_name)+1);
    strncpy(name, _name, strlen(_name)+1);
    id = realloc(id, strlen(_id)+1);
    strncpy(id, _id, strlen(_id)+1);
    holdNum = _holdNum;
    returnNum = _returnNum;
    borrowNum = _borrowNum;

    Var *varList = pushVar();

    printf("\n** Dear %s, welcome to the CUHK Library **\n", name);
    printf("[Number of books borrowed: %d]\n", holdNum);

    if (id[0] == 'p')
        professor();
    else
        staff();

    popVar(varList);
}

int main(int argc, char *argv[])
{
    printf("\t\t### Welcome to the CUHK Library Administration System ###\n");

    library("Olivia Su", "s123", 2, 1, 3);
    library("Jimmy Lee", "p123", 5, 2, 7);
    library("Weixin Si","s234", 5, 2, 7);

    return 0;
}
