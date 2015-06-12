(**
 * CSCI3180 Principles of Programming Languages

 * --- Declaration ---

 * I declare that the assignment here submitted is original except for source
 * material explicitly acknowledged. I also acknowledge that I am aware of
 * University policy and regulations on honesty in academic work, and of the
 * disciplinary guidelines and procedures applicable to breaches of such policy
 * and regulations, as contained in the website
 * http://www.cuhk.edu.hk/policy/academichonesty/

 * Assignment 4
 *)

(**
 * 3
 *)
fun fibonacci (0:int):int = 0
  | fibonacci (1:int):int = 1
  | fibonacci (2:int):int = 1
  | fibonacci (n:int):int = fibonacci(n-1) + fibonacci(n-2);

(**
 * 4(a)
 *)
datatype 'a bTree = nil | bt of 'a bTree * 'a * 'a bTree;
fun noOfLeaves nil = 0
  | noOfLeaves (bt(nil,_,nil)) = 1
  | noOfLeaves (bt(lt,_,rt)) = noOfLeaves lt + noOfLeaves rt;

(**
 * 4(b)
 *)
fun height nil = 0
  | height (bt(lt,_,rt)) = 1 + Int.max (height lt, height rt);

(**
 * 4(c)
 *)
fun size nil = 0
  | size (bt(lt,_,rt)) = 1 + size lt + size rt;
