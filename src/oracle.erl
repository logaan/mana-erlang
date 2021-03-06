-module(oracle).
-include_lib("stdlib/include/qlc.hrl").
-include("records.hrl").
-export([
  insert_card/1,
  all_cards/0,
  name_search/1,
  load_cards/1,
  read_cards/1
]).

insert_card(Card) ->
    Fun = fun() -> mnesia:write(Card) end,
    mnesia:transaction(Fun).

all_cards() ->
    F = fun() -> qlc:e(qlc:q([X || X <- mnesia:table(card)])) end,
    {atomic, Cards} = mnesia:transaction(F),
    Cards.

name_search(Name) ->
    F = fun() -> qlc:e(qlc:q(
                         [ X || X <- mnesia:table(card),
                                string:str(binary_to_list(X#card.name), Name) /= 0
                                   ])) end,
    {atomic, Cards} = mnesia:transaction(F),
    Cards.

load_cards(Filename) ->
    Cards = read_cards(Filename),
    [{atomic, ok} = insert_card(Card) || Card <- Cards],
    ok.

read_cards(Filename) ->
    {ok, FileContents} = file:read_file(Filename),
    JsonCards = json_eep:json_to_term(binary_to_list(FileContents)),
    lists:map(fun json_card_to_record/1, JsonCards).

json_card_to_record( {[{<<"cost">>,Cost}, {<<"card_type">>,Type}, {<<"pt">>,PT}, {<<"name">>,Name}, {<<"text">>,Text}]}) ->
    #card{ name = Name, cost = Cost, type = Type, text = Text, pt = PT };
json_card_to_record({[{<<"cost">>, Type}, {<<"card_type">>,null}, {<<"name">>, Name}]}) ->
    #card{ name = Name, type = Type };
json_card_to_record( {[{<<"cost">>,Cost}, {<<"card_type">>,Type}, {<<"name">>,Name}, {<<"text">>,Text}]}) ->
    #card{ name = Name, cost = Cost, type = Type, text = Text }.

