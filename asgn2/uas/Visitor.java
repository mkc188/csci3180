// CSCI3180 Principles of Programming Languages

// --- Declaration ---

// I declare that the assignment here submitted is original except for source
// material explicitly acknowledged. I also acknowledge that I am aware of
// University policy and regulations on honesty in academic work, and of the
// disciplinary guidelines and procedures applicable to breaches of such policy
// and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/

// Assignment 2

public class Visitor implements FoodBuying {
	public String visitorID;
	public int money;

	Visitor(String visitorID) {
		this.visitorID = visitorID;
		this.money = 1000;
	}
	public String toString() {
		return "Visitor " + this.visitorID;
	}
	public void pay(int amount) {
		this.money -= amount;
		System.out.println(this.toString() + " has got HK$" + this.money + " left.");
	}
	// need to implement buyFood in every class which use it
	public void buyFood(String foodName, int payment) {
		System.out.println("Buy " + foodName + " and pay $" + payment + ".");
		pay(payment);
	}
}
