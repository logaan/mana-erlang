-module (web_index).
-include_lib ("nitrogen/include/wf.inc").
-include("../records.hrl").
-compile(export_all).

main() -> 
  #template { file="./wwwroot/template.html"}.

title() ->
  oracle:greet().

body() ->
  Data = oracle:all_cards(),
  Map = #card{ name=nameLabel@text, cost=costLabel@text },
  [
    #label{text="web_index body."},
    #bind{ id=oracleBinding, data=Data, map=Map, body=[
      #panel{ body=[
        #hr{},
        #label{ id=nameLabel },
        #label{ id=costLabel }
      ]}
    ]}
  ].

event(_) -> ok.
