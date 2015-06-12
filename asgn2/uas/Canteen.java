// CSCI3180 Principles of Programming Languages

// --- Declaration ---

// I declare that the assignment here submitted is original except for source
// material explicitly acknowledged. I also acknowledge that I am aware of
// University policy and regulations on honesty in academic work, and of the
// disciplinary guidelines and procedures applicable to breaches of such policy
// and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/

// Assignment 2

public class Canteen {
	public String ctnName;

	Canteen(String name) {
		this.ctnName = name;
	}
	public String toString() {
		return this.ctnName + " Canteen";
	}
	public void sellNoodle(Object person) {
		int price = 30;
		// duck typing: check what type of person it is
		if (person instanceof Professor)
			((Professor) person).buyFood("Noodle", price);
		else if (person instanceof Student)
			((Student) person).buyFood("Noodle", price);
		else if (person instanceof Visitor)
			((Visitor) person).buyFood("Noodle", price);
	}
}
