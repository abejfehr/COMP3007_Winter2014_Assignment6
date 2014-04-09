% Assignment 6
%
% Abe Fehr
% 100908743

% "base" case
occurrences_of(_,[],0).
occurrences_of(X, [X|Y], Z) :-
  occurrences_of(X,Y,I),
  Z is I+1.
occurrences_of(X,[A|Y],Z) :-
  not(X = A),
  occurrences_of(X,Y,Z).

% "base" case
flatten_list([], []).
% I know that I'm doing something wrong right here, but I can't
% figure out what. I think Imma give up for today, sorry guys.
flatten_list([], _) :-
  [].
flatten_list([W|X],Y) :-
  flatten_list(X,append(Y,W)).


% I changed names to proper math terms
% "base" and "exponent" so I wouldn't get confused.
power(_, 0, 1). %the "base" case
power(Base, Exponent, Power) :-
  X is Exponent-1, %decrement the exponent
  power(Base, X, Y), %call it again
  Power is Y*Base. %multiply the power
