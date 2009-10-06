-module (web_index).
-include_lib ("nitrogen/include/wf.inc").
-include("../records.hrl").
-compile(export_all).

main() -> 
  #template { file = "./wwwroot/template.html"}.

title() ->
  oracle:greet().

body() ->
  #bind{
    id    = oracleBinding,
    data  = oracle:all_cards(),
    map   = #card{ name = nameLabel@text, cost = costLabel@body },
    body  = [
    #panel{ body = [
      #h2{ id = nameLabel },
      #p{  id = costLabel }
    ]}
  ]}.

event(_) -> ok.

