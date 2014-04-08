% Assignment 6
%
% Abe Fehr
% 100908743

capital(bern).
capital(london).
capital(prague).
capital(bonn).
capital(belgrade).
city-in(prague, czechoslovakia).
city-in(bratislava, czechoslovakia).
city-in(berlin, germany).
city-in(leipzig, germany).
city-in(bonn, germany).
city-in(hamberg, germany).
city-in(belgrade, yugoslavia).
city-in(zagreb, yugoslavia).
city-in(bern switzerland).
city-in(zurich, switzerland).
city-in(london, united_kingdom).
city-in(edinburgh, united_kingdom).
belongs-to(czechoslovakia, 'COMECON').
belongs-to(germany, 'EC').
belongs-to(switzerland, 'EFTA').
belongs-to(united_kingdom, 'EC').

capital_of(City, Country) :- capital(City), city-in(City, Country).

capital_of(Community, Capitals) :-
