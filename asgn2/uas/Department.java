// CSCI3180 Principles of Programming Languages

// --- Declaration ---

// I declare that the assignment here submitted is original except for source
// material explicitly acknowledged. I also acknowledge that I am aware of
// University policy and regulations on honesty in academic work, and of the
// disciplinary guidelines and procedures applicable to breaches of such policy
// and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/

// Assignment 2

public class Department {
	public String deptName;

	Department(String name) {
		this.deptName = name;
	}

	public String toString() {
		return this.deptName + " Department";
	}

	public void payScholarship(Object person, int amount) {
		// duck typing: check what type of person it is
		if (person instanceof Student) {
			System.out.println(this.toString() + " pays scholarship $" + amount + " to " + ((Student) person).toString() + ".");
			((Student) person).getScholarship(amount);
		}
		else if (person instanceof Professor)
			System.out.println(((Professor) person).toString() + " has no rights to get scholarship from " + this.toString() + "!" );
		else if (person instanceof Visitor)
			System.out.println(((Visitor) person).toString() + " has no rights to get scholarship from " + this.toString() + "!" );
	}

	public void paySalary(Object person, int amount) {
		// duck typing: check what type of person it is
		if (person instanceof Professor) {
			System.out.println(this.toString() + " pays Salary $" + amount + " to " + ((Professor) person).toString() + ".");
			((Professor) person).getSalary(amount);
		}
		else if (person instanceof Student)
			System.out.println(((Student) person).toString() + " has no rights to get salary from " + this.toString() + "!" );
		else if (person instanceof Visitor)
			System.out.println(((Visitor) person).toString() + " has no rights to get salary from " + this.toString() + "!" );
	}
}
