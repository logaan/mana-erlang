-module (web_index).
-include_lib ("nitrogen/include/wf.inc").
-include("../records.hrl").
-compile(export_all).

main() -> 
    #template { file = "./wwwroot/template.html"}.

title() ->
    "Create Deck".

body() -> [
	   #p{ body=
	       #inplace_textbox{ tag=deckName, text="Deck Name" }
	      },
           #textbox{ id=cardName, text="Type part of a card name...", next=search },
           #button{ id=search, text="Search", postback=search },
           #list{ id=results }
          ].

event(search) ->
    [Name] = wf:q(cardName),
    wf:update(results, #bind{
                id    = oracleBinding,
                data  = oracle:name_search(Name),
                map   = #card{ name = nameLabel@text },
                body  = [ #listitem{ id = nameLabel } ]
	       }),
    ok;
event(_) -> ok.

inplace_textbox_event(deckName, Value) ->
  wf:wire(#alert { text="Changed name" }),
  Value.
