// CSCI3180 Principles of Programming Languages

// --- Declaration ---

// I declare that the assignment here submitted is original except for source
// material explicitly acknowledged. I also acknowledge that I am aware of
// University policy and regulations on honesty in academic work, and of the
// disciplinary guidelines and procedures applicable to breaches of such policy
// and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/

// Assignment 2

public class StaffClub {
	public String clubName;

	StaffClub(String name) {
		this.clubName = name;
	}

	public String toString() {
		return this.clubName + " Club";
	}

	public void holdParty(Object person) {
		// duck typing: check what type of person it is
		if (person instanceof Professor) {
			((Professor) person).attendClub();
		}
		else if (person instanceof Student)
			System.out.println(((Student) person).toString() + " has no rights to use facilities in the Club!");
		else if (person instanceof Visitor)
			System.out.println(((Visitor) person).toString() + " has no rights to use facilities in the Club!");
	}
}
