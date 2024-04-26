extends Control

var endval = "error"

func _process(delta):
	$Score.text = endval
	
func _on_hud_pow(s):
	endval = s
	
