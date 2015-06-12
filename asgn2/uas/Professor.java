// CSCI3180 Principles of Programming Languages

// --- Declaration ---

// I declare that the assignment here submitted is original except for source
// material explicitly acknowledged. I also acknowledge that I am aware of
// University policy and regulations on honesty in academic work, and of the
// disciplinary guidelines and procedures applicable to breaches of such policy
// and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/

// Assignment 2

public class Professor extends UnivMember implements FoodBuying {
	public String staffID;
	public String name;
	public int salary;

	Professor(String staffID, String name) {
		super(name);
		this.staffID = staffID;
		this.name = name;
		this.salary = 100000;
	}

	public String toString() {
		return "Professor " + this.name + " (" + this.staffID + ")";
	}
	public void borrowBook(int num) {
		this.nbBooksBorrowed += num;
		System.out.println("Totally " + this.nbBooksBorrowed + " books borrowed.");
	}
	public void getSalary(int amount) {
		this.salary += amount;
		System.out.println(this.toString() + " has got HK$" + this.salary + " salary left.");
	}
	public void pay(int amount) {
		this.salary -= amount;
		System.out.println(this.toString() + " has got HK$" + this.salary + " salary left.");
	}
	public void attendClub() {
		System.out.println("Eat and drink in the Club.");
	}
	// need to implement buyFood in every class which use it
	public void buyFood(String foodName, int payment) {
		System.out.println("Buy " + foodName + " and pay $" + payment + ".");
		pay(payment);
	}
}
