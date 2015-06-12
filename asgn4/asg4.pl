/**
 * CSCI3180 Principles of Programming Languages

 * --- Declaration ---

 * I declare that the assignment here submitted is original except for source
 * material explicitly acknowledged. I also acknowledge that I am aware of
 * University policy and regulations on honesty in academic work,and of the
 * disciplinary guidelines and procedures applicable to breaches of such policy
 * and regulations,as contained in the website
 * http://www.cuhk.edu.hk/policy/academichonesty/

 * Assignment 4
 */

/**
 * 1(a)
 */
tree(bt(a,bt(b,bt(d,nil,nil),bt(e,nil,bt(g,nil,nil))),bt(c,nil,bt(f,nil,nil)))).

%% ?- tree(T).
%% T = bt(a,bt(b,bt(d,nil,nil),bt(e,nil,bt(g,nil,nil))),bt(c,nil,bt(f,nil,nil))).

/**
 * 1(b)
 */
max(X,Y,R) :- X > Y, !, R = X.
max(_,Y,R) :- R = Y.
height(nil,0).
height(bt(_,L,R),H) :- height(L,H1), height(R,H2), max(H1,H2,H3), H is H3 + 1.

%% ?- tree(T), height(T,H).
%% T = bt(a,bt(b,bt(d,nil,nil),bt(e,nil,bt(g,nil,nil))),bt(c,nil,bt(f,nil,nil))),
%% H = 4.

/**
 * 1(c)
 */
size(nil,0).
size(bt(_,L,R),N):- size(L,NL), size(R,NR), N is NL + NR + 1.

%% ?- tree(T), size(T,N).
%% T = bt(a,bt(b,bt(d,nil,nil),bt(e,nil,bt(g,nil,nil))),bt(c,nil,bt(f,nil,nil))),
%% N = 7.

/**
 * 2(a)
 */
int(0).
int(s(X)) :- int(X).
sum(0,X,X).
sum(s(X),Y,s(Z)) :- sum(X,Y,Z).
product(0,_,0).
product(s(Y),X,P) :- sum(X,Z,P), product(X,Y,Z).

/**
 * 2(b)
 */
%% ?- product(s(s(0)),s(s(s(0))),X).
%% X = s(s(s(s(s(s(0)))))).

/**
 * 2(c)
 */
%% ?- product(s(s(0)),X,s(s(s(s(s(s(s(s(0))))))))).
%% X = s(s(s(s(0)))) .

/**
 * 2(d)
 */
%% ?- product(X,Y,s(s(s(s(s(s(0))))))).
%% X = s(s(s(s(s(s(0)))))),
%% Y = s(0) ;
%% X = s(s(s(0))),
%% Y = s(s(0)) ;
%% X = s(s(0)),
%% Y = s(s(s(0))) ;
%% X = s(0),
%% Y = s(s(s(s(s(s(0)))))) ;
%% false.

/**
 * 2(e)
 */
mult(0,_,0).
mult(s(X),Y,P) :- sum(Y,Z,P), mult(X,Y,Z).
exp(0,s(_),0).
exp(s(_),0,s(0)).
exp(X,s(Y),Z) :- exp(X,Y, W), mult(W,X,Z).

/**
 * 2(f)
 */
%% ?- exp(s(s(0)),s(s(s(0))),X).
%% X = s(s(s(s(s(s(s(s(0)))))))) .

/**
 * 2(g)
 */
%% ?- exp(s(s(0)),X,s(s(s(s(s(s(s(s(0))))))))).
%% X = s(s(s(0))) .
