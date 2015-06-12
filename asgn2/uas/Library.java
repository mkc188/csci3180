// CSCI3180 Principles of Programming Languages

// --- Declaration ---

// I declare that the assignment here submitted is original except for source
// material explicitly acknowledged. I also acknowledge that I am aware of
// University policy and regulations on honesty in academic work, and of the
// disciplinary guidelines and procedures applicable to breaches of such policy
// and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/

// Assignment 2

public class Library {
	public String libName;

	Library(String name) {
		this.libName = name;
	}
	public String toString() {
		return this.libName + " Library";
	}
	public void lendBook(Object person, int numOfBooks) {
		// duck typing: check what type of person it is
		if (person instanceof UnivMember)
			((UnivMember) person).borrowBook(numOfBooks);
		else
			System.out.println(person.toString() + " is not a library user!");
	}
	public void returnBook(Object person, int numOfBooks) {
		// duck typing: check what type of person it is
		if (person instanceof UnivMember)
			((UnivMember) person).returnBook(numOfBooks);
		else
			System.out.println(person.toString() + " is not a library user!");
	}
}
