-module (game_hand).
-include_lib ("nitrogen/include/wf.inc").
-compile(export_all).

main() -> 
	#template { file="./wwwroot/template.html"}.

title() ->
	"game_hand".

body() ->
	#label{text="game_hand body."}.
	
event(_) -> ok.