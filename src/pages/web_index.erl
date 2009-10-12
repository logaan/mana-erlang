-module (web_index).
-include_lib ("nitrogen/include/wf.inc").
-include("../records.hrl").
-compile(export_all).

main() -> 
  #template { file = "./wwwroot/template.html"}.

title() ->
  "Create Deck".

body() -> [
  #textbox{ id=cardName, text="Type part of a card name...", next=search },
  #button{ id=search, text="Search", postback=search },
  #panel{ id=results }
  ].

event(search) ->
  [Name] = wf:q(cardName),
  wf:update(results, #bind{
    id    = oracleBinding,
    data  = oracle:name_search(Name),
    map   = #card{ name = nameLabel@text, cost = costLabel@body },
    body  = [
    #panel{ body = [
      #h2{ id = nameLabel },
      #p{  id = costLabel }
    ]}
  ]}),
  ok;
event(_) -> ok.

