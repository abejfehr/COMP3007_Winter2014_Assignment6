% Assignment 6
%
% Abe Fehr
% 100908743

occurrences_of(X,Y,Z) :-

flatten_list([],[]) :- !.
flatten_list(X,Y) :-

% I changed number and index to the proper math terms
% base and exponent so I wouldn't get confused.
power(Base,Exponent,Power) :-
