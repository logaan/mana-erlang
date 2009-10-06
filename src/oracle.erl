-module(oracle).
-include_lib("stdlib/include/qlc.hrl").
-include("records.hrl").
-export([
  greet/0,
  reset_schema/0,
  create_tables/0,
  insert_card/1,
  all_cards/0
]).

greet() -> "Hello kitty.".

reset_schema() ->
  mnesia:stop(),
  mnesia:delete_schema( [node()] ),
  mnesia:create_schema( [node()] ),
  mnesia:start().

create_tables() ->
  mnesia:create_table( card, [
    {disc_copies, [node()]},
    {attributes, record_info(fields, card)}
  ]).

insert_card(Card) ->
  Fun = fun() -> mnesia:write(Card) end,
  mnesia:transaction(Fun).

all_cards() ->
  F = fun() -> qlc:e(qlc:q([X || X <- mnesia:table(card)])) end,
  {atomic, Cards} = mnesia:transaction(F),
  Cards.
