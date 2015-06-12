// CSCI3180 Principles of Programming Languages

// --- Declaration ---

// I declare that the assignment here submitted is original except for source
// material explicitly acknowledged. I also acknowledge that I am aware of
// University policy and regulations on honesty in academic work, and of the
// disciplinary guidelines and procedures applicable to breaches of such policy
// and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/

// Assignment 2

public abstract class UnivMember {
    public String name;
    public int nbBooksBorrowed;

    UnivMember(String name, int nbBooksBorrowed) {
        this.name = name;
        this.nbBooksBorrowed = nbBooksBorrowed;
    }
    UnivMember(String name) {
        this.name = name;
        this.nbBooksBorrowed = 0;
    }
    public abstract void borrowBook(int num);

    public void returnBook(int num) {
        int nbBooksReturn;
        if (this.nbBooksBorrowed < num) {
            nbBooksReturn = this.nbBooksBorrowed;
            this.nbBooksBorrowed = 0;
        }
        else {
            nbBooksReturn = num;
            this.nbBooksBorrowed -= num;
        }
        System.out.println("Return " + nbBooksReturn + " books, " + this.nbBooksBorrowed + " books still borrowed.");
    }
}
