// CSCI3180 Principles of Programming Languages

// --- Declaration ---

// I declare that the assignment here submitted is original except for source
// material explicitly acknowledged. I also acknowledge that I am aware of
// University policy and regulations on honesty in academic work, and of the
// disciplinary guidelines and procedures applicable to breaches of such policy
// and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/

// Assignment 2

public class Student extends UnivMember implements FoodBuying {
	public String stuID;
	public String name;
	public int scholarship;

	Student(String stuID, String name) {
		super(name);
		this.stuID = stuID;
		this.name = name;
		this.scholarship = 10000;
	}

	public String toString() {
		return "Student " + this.name + " (" + this.stuID + ")";
	}
	public void borrowBook(int num) {
		int max = 30;

		if (num < max-this.nbBooksBorrowed)
			this.nbBooksBorrowed += num;
		else
			this.nbBooksBorrowed = max;
		System.out.println("Totally " + this.nbBooksBorrowed + " books borrowed.");
	}
	public void getScholarship(int amount) {
		this.scholarship += amount;
		System.out.println(this.toString() + " has got HK$" + this.scholarship + " scholarship left.");
	}
	public void pay(int amount) {
		this.scholarship -= amount;
		System.out.println(this.toString() + " has got HK$" + this.scholarship + " scholarship left.");
	}
	// need to implement buyFood in every class which use it
	public void buyFood(String foodName, int payment) {
		System.out.println("Buy " + foodName + " and pay $" + payment + ".");
		pay(payment);
	}
}
