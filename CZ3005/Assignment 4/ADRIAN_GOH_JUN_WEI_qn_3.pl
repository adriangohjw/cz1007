% Setting up of list methods for appending
append([], Y, Y).
append([H|X], Y, [H|Z]):-
    append(X, Y, Z).


% creating an empty list variable
empty_list([]).


% Facts to check conditions
healthy_meal(healthy).
value_meal(value).
vegan_meal(vegan).
veggie_meal(veggie).
meaty_delight_meal(meaty_delight).


% Possible options for each category
meals([healthy, normal, value, vegan, veggie, meaty_delight]).

vegan_breads([italian_wheat, parmesan_oregano, hearty_italian, multigrain, flatbread]).
non_vegan_breads([honey_oat]).

value_mains([chicken, ham, bacon, tuna]).
expensive_mains([beef, salmon, turkey]).

veggies([cucumber, green_peppers, lettuce, red_onions, tomatoes, olives, jalapenos, pickles]).

healthy_sauces([honey_mustard, sweet_onion, chilli, tomato]).
unhealthy_sauces([chipotle_southwest, bbq, ranch, mayonnaise]).

non_vegan_topups([american, monterey_jack, cheddar, egg_mayonnaise]).
vegan_topups([avocado]).

healthy_sides([cookies, energy_bar]).
unhealthy_sides([chips, hashbrowns]).

healthy_drinks([mineral_water, orange_juice, green_tea, coffee]).
unhealthy_drinks([fountain_drinks]).


% simplified aggregator
all_options(A, X):-
    A == meals -> meals(X);
    A == breads -> breads(X);
    A == mains -> mains(X);
    A == veggies -> veggies(X);
    A == sauces -> sauces(X);
    A == topups -> topups(X);
    A == sides -> sides(X);
    A == drinks -> drinks(X).

% simplified aggregator for available options for each category based on inputs
available_options(A, X):-
    A == meals -> ask_meals(X);
    A == breads -> ask_breads(X);
    A == mains -> ask_mains(X);
    A == veggies -> ask_veggies(X);
    A == sauces -> ask_sauces(X);
    A == topups -> ask_topups(X);
    A == sides -> ask_sides(X);
    A == drinks -> ask_drinks(X).

% simplified aggregator for selected options for each category
selected_options(A, X):-
    A == meals -> findall(X, selected_meals(X), X);
    A == breads -> findall(X, selected_breads(X), X);
    A == mains -> findall(X, selected_mains(X), X);
    A == veggies -> findall(X, selected_veggies(X), X);
    A == sauces -> findall(X, selected_sauces(X), X);
    A == topups -> findall(X, selected_topups(X), X);
    A == sides -> findall(X, selected_sides(X), X);
    A == drinks -> findall(X, selected_drinks(X), X).


% Return a list of all the breads available
breads(X):-
    vegan_breads(B1), non_vegan_breads(B2), append(B1, B2, X).


% Return a list of all the mains available
mains(X):-
    value_mains(M1), expensive_mains(M2), append(M1, M2, X).


% Return a list of all the sauces available
sauces(X):-
    healthy_sauces(S1), unhealthy_sauces(S2), append(S1, S2, X).


% Return a list of all the topups available
topups(X):-
    non_vegan_topups(T1), vegan_topups(T2), append(T1, T2, X).


% Return a list of all the sides available
sides(X):-
    healthy_sides(S1), unhealthy_sides(S2), append(S1, S2, X).


% Return a list of all the drinks available
drinks(X):-
    healthy_drinks(D1), unhealthy_drinks(D2), append(D1, D2, X).

    
% Return a list of possible meals based on previous choices
ask_meals(X):-
    meals(X).


% Return a list of possible breads based on previous choices
% Vegan meals do not have honey oat as an option, return vegan_breads
ask_breads(X):-
    selected_meals(Y), vegan_meal(Y) -> vegan_breads(X);   
    breads(X).


% Return a list of possible mains based on previous choices
% Value meals do not have expensive mains as an option, return value_mains
% Vegan and Veggie meals do not have main options, return empty list [].
ask_mains(X):-
    selected_meals(Y), vegan_meal(Y) -> empty_list(X);
    selected_meals(Y), veggie_meal(Y) -> empty_list(X);
    selected_meals(Y), value_meal(Y) -> value_mains(X); 
    mains(X).


% Return a list of possible veggies based on previous choices
% Meaty delight meals do not have veggie options, return empty list [].
ask_veggies(X):-
    selected_meals(Y), \+ meaty_delight_meal(Y), veggies(X).


% Return a list of possible sauces based on previous choices
% Healthy meals do not have unhealthy sauces, return a list containing only healthy_sauces
ask_sauces(X):-
    selected_meals(Y), healthy_meal(Y) -> healthy_sauces(X);   
    sauces(X).


% Return a list of possible top-ups based on previous choices
% Value meal does not have topup, returns an empty list
% Vegan meal does not have non vegan topups, return a list containing vegan_topups
ask_topups(X):-
    selected_meals(Y), value_meal(Y) -> empty_list(X);
    selected_meals(Y), vegan_meal(Y) -> vegan_topups(X); 
    topups(X).


% Return a list of possible sides based on previous choices
% Healthy meals does not have unhealthy sides, return a list containing healthy_sides
ask_sides(X):-
    selected_meals(Y), healthy_meal(Y) -> healthy_sides(X);   
    sides(X).


% Return a list of possible drinks based on previous choices
% Healthy meals does not have unhealthy drinks, return a list containing healthy_drinks
ask_drinks(X):-
    selected_meals(Y), healthy_meal(Y) -> healthy_drinks(X);   
    drinks(X).