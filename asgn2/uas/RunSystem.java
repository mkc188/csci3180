import java.util.ArrayList;

// CSCI3180 Principles of Programming Languages

// --- Declaration ---

// I declare that the assignment here submitted is original except for source
// material explicitly acknowledged. I also acknowledge that I am aware of
// University policy and regulations on honesty in academic work, and of the
// disciplinary guidelines and procedures applicable to breaches of such policy
// and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/

// Assignment 2

public class RunSystem {
	public static void main(String[] args) {
		System.out.println("University Administration System:");

		Professor jimmy = new Professor("p001", "Jimmy");
		Student mary = new Student("s001", "Mary");
		Visitor visitor = new Visitor("v001");
		Library cuLib = new Library("CU");
		Canteen cuCtn = new Canteen("CU");
		Department cse = new Department("CSE");
		StaffClub teaClub = new StaffClub("SCR");

		ArrayList person_list = new ArrayList();
		person_list.add(jimmy);
		person_list.add(mary);
		person_list.add(visitor);

		for (Object person : person_list) {
			System.out.println();
			System.out.println(person.toString() + " enters CUHK ...");

			System.out.println(person.toString() + " enters " + cuLib.toString() + ".");
			cuLib.lendBook(person, 20);
			cuLib.lendBook(person, 20);
			cuLib.returnBook(person, 10);
			cuLib.returnBook(person, 25);

			System.out.println(person.toString() + " enters " + cuCtn.toString() + ".");
			cuCtn.sellNoodle(person);

			System.out.println(person.toString() + " enters " + cse.toString() + ".");
			cse.paySalary(person, 10000);
			cse.payScholarship(person, 2000);

			System.out.println(person.toString() + " enters " + teaClub.toString() + ".");
			teaClub.holdParty(person);
		}
	}
}
