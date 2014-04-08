% Assignment 6
%
% Abe Fehr
% 100908743

/*
SWI-Prolog requires us to declare as dynamic any predicates that may change.
Also retract all existing statements in the knowledge base, for easier restart.
*/

:- dynamic i_am_at/1, at/5, holding/1, door/1, safe/1.
:- retractall(at(_, _)),
	retractall(i_am_at(_)),
	retractall(holding(_)),
	retractall(door(_)),
	retractall(safe(_)).

/*
the area descriptions

NOTE: that the only reason Im doing more than one description of the rule is so
that I can use the bold rule that I made earlier to print out bold text. If I
stored the descriptions of the room separately and printed them it would look a
lot cleaner, but then Id have to forego the bold text. This is way cooler :P
*/
describe(center) :-
	write('You are in the center of the room.\n\nThere is a plant in \
the '), bold('corner'), write(' of the room, a '), bold('desk'), write(' against the wall, a '), bold('wardrobe'), write(' off to the side and \
the '), bold('door'), write(' to exit is behind you.\n\n'), !.
describe(desk) :-
	write('You are by the desk.\n\nThere is a '), bold('safe'),
	write(' under it. \n'), !.
describe(safe) :-
	write('You kneel to look at the safe.\n\nYou could try to '),
	bold('"open."'),
	write(' it. \n\n'), !.
describe(door) :-
	write('You are by what looks to be the exit of the room. On occassion, \
voices can be heard on the other side.\n\nThe door is locked, but the correct \
4-digit passcode can unlock it. \nYou can try passcodes by typing something like \
"enter_code(_,_,_,_)."\n\nThere is also something interesting carved into the \
'), bold('trim'), write(' beside the door'), !.
describe(corner) :-
	write('You are in the corner of the room. There\'s a plant in the \
corner, and something in the '), bold('pot'), write(' is gleaming.').
describe(plant) :- describe(pot).
describe(pot) :-
	write('You kneel to look into the pot.\n\n'), !.
describe(wardrobe) :-
	write('An old wooden wardrobe. It\'s empty\n\n').
describe(trim) :-
  write('There\'s a "5" carved into the wall here...What does that mean?').
describe(_) :-
	write('I don\'t know where you are.\n\n'), !.

/*
start is the first rule we will run when grading your game. Anything you want to be
seen first should go in here. This one just prints out where you currently are in
the world.
*/

start :- intro, instructions, look.

intro :- write('You wake up with a headache in the center of a large, unfamiliar room. '), bold('You must \
escape. '), write('You stand up, dazed and confused.\n\n').

instructions :- write('Instructions:\n-Type '), bold('"look."'), write('to look \
around where you are. It will tell you where you are, what\'s around you, and \
what you can pick up where you are.\n-Type '), bold('"go_to(place)."'), write(' \
to move somewhere in the room.\n-Type '), bold('"pick_up(item)."'), write('to pick \
up an item.\n-Type '), bold('"held_items."'), write(' list all the items you\'re \
currently holding.\n-Type '), bold('"examine(item)."'), write(' to look at an item \
that you\'re currently holding.\n\nYou can type'), bold('"instructions."'),
write(' again at any time to see these again.\nGood luck.\n').

/*
World Setup

I just thought I should write a bit of a disclaimer here. I know that the
assignment asks us to create at least 10 rooms, but I thought it would be really
interesting to make one of those games where a person is stuck in a room and has
to escape. I hope you guys dont mind that I converted the "rooms" idea into
"areas". It didnt make it any easier as far as I know
*/

%you can go over to the desk from any part of the room
path(_, desk).

%you can only get to the safe from being by the desk
path(desk, safe).

%the corner of the room, it contains a potted plant
path(_, corner).

%you can go back into the center of the room from everywhere
path(_, center).

%the pot of the plant. it contains a key for the safe
path(corner, pot).

%the door to exit the room. its locked, but can be unlocked with a keycode
path(_, door).

path(door, trim).

%the wardrobe where the note lies
path(_, wardrobe).

%the door and the safe are locked at first
door(locked).
safe(locked).

/*
At/6 is an interesting clause. Its "arguments" are:
-location of the item
-name of the item
-relationship of the item to its location
-the broader location of the item
-the items description
*/

%the pen on the desk. it does nothing, but you can pick it up for fun
at(desk, pen, 'on', 'desk', 'It doesn\'t write.\n').

%the diary. it contains unique information about the room, and has a number of
%the keycode on the door
at(safe, diary, 'in the safe under', 'desk', 'The leather cover is torn, it looks really old. The name "Jack" is inscribed on the front.\n').

%the key in the pot of the plant in the corner
at(pot, key, 'in', 'pot', 'It looks useful\n').

at(wardrobe, note, 'on the ground by', 'desk', 'It\'s hand-written').

examine(key) :-
	holding(key),
  write('It\'s just a rusty old key. I wonder where it goes...\n'), !.

examine(diary) :-
	holding(diary),
  write('You open the diary to read several of it\'s old pages.\n\n'),
	entry1,
	write('\n\n'),
	entry2,
  write('\n\n\n\nThe rest of the pages are blank...\n'), !.

examine(note) :-
  holding(note),
  write('It says: \n\n   "8"\n\n\nI wonder what that means?'), !.

examine(_) :- write('You have to be holding an item to examine it.\n'), !.

entry1 :- write('   December 20th, 1943\n\nI woke up in this awful room...I \
haven\'t eaten anything in days.\nI\'m writing this in fear that this is the \
last thing I ever write.\n\n  -Jack').

entry2 :- write('   December 22nd, 1943\n\nThere are footsteps outside sometimes, I can hear people \
talking. The door is locked, but I think I overheard one of the men saying that the first \
two digits to the passcode were "5 and 3". I\'ve tried hundreds of digits for \
the last two but I just can\'t figure it out...I may die in here. I just want \
to hold my children one more time...\n\n  -Jack').

%the key code entry for the door
enter_code(A, B, C, D) :-
  i_am_at(door), A = 5, B = 3, C = 8, D = 5,
	( door(locked)
	  -> (write('That was the correct passcode! The door is now unlocked. Type "open." to finally escape!'),
		retract(door(locked)),
		assert(door(unlocked)))
		; write('The door is already unlocked. Type "open." to ecsape!')
	).

%the key code entry when its wrong or attempted from the wrong location
enter_code(_, _, _, _) :-
	( i_am_at(door)
	  -> write('That passcode didn\'t work...\n')
		; wrong_location
	), !.

open :-
	i_am_at(door),
	door(locked),
  write('The door is locked! You can\'t open it'), !.

open :-
  i_am_at(door),
  door(unlocked),
  write('Beads of sweat roll down your face. You turn the handle until \
the door clicks and begin to slowly push it open...\n\n...you walk into a room \
as the door closes and locks behind you. You find yourself in another room \
which is an exact mirror of the one you just escaped from.\n\nYou laugh \
hysterically and settle into the chair by the desk, and you begin to add a \
chapter to an empty diary, which you sign as "Jack".\n\n'), bold('The End.'), !.

open :-
  i_am_at(safe),
	( holding(key)
	  -> (write('Your key fits! You crack open the safe to reveal it\'s contents. There\'s a '),
		    bold('diary'), write(' inside.'),
				retract(safe(locked)), %forget the safe was ever locked
				assert(safe(unlocked)), %unlock it
				retract(holding(key))) %the key is gone now
		; (write('You need a '), bold('key'), write(' to open the safe.'))
	), !.

open :-
  wrong_location.

i_am_at(center). 			%players initial location

/*
Verbs
*/

%Go to - if the movement is valid, move the player.
go_to(Place) :-
	i_am_at(X),
	path(X, Place),
	retract(i_am_at(X)),
	assert(i_am_at(Place)),
	nl, look, !.

%Go to - otherwise, tell the player they cant move.
go_to(_) :-
	write('You can\'t do that'), nl.

%Pick up object - if already holding the object, cant pick it up!
pick_up(X) :-
	holding(X),
	write('You are already holding that item!'), nl,
	!.

%Pick up object - if in the right location, pick it up and remove it from the ground.
pick_up(X) :-
	i_am_at(Place),
	at(Place, X, W, Y, Z),
	retract(at(Place, X, W, Y, Z)),
	assert(holding(X)),
	write('You have picked up the '), bold(X), write('.'),
	nl, !.

%Pick up object - otherwise, cannot pick up the object.
pick_up(_) :-
	write('I do not see that here.'), nl.

wrong_location :-
	write('I don\'t know what that means.'), nl.

%Look - describe where in space the player is, list objects at the location
look :-
	i_am_at(X),
	describe(X),
	list_objects_at(X),
	!.

%Bold - formats whatever text as bold and writes it to the standard output
bold(Text) :-
	ansi_format([bold,fg(black)], Text, [_]).

held_items :-
  holding(X), write(X).

%List objects - these two rules effectively form a loop that go through every object
%				in the location and writes them out.
list_objects_at(X) :- %dont show things if the safe is locked
	X = safe,
	safe(locked), nl.

list_objects_at(X) :-
	at(X, Item, Relationship, Place, Description),
	write('There is a '), bold(Item), write(' '), write(Relationship),
	write(' the '), write(Place), write('. '), write(Description), nl.

list_objects_at(_).
