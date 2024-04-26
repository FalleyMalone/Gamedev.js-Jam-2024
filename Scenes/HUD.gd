extends CanvasLayer
signal pow

@onready var bEnergy = $BlueCharge
@onready var rEnergy = $RedCharge

var scoreVal = 100
var buffer = true
var clock = 0.0

#Pick-up buffer
const bufferVal = 0.5

func _process(delta):
	clock += delta
	if scoreVal > 0 && buffer && int(clock) % 2 == 0:
		scoreVal -= delta
	$Score.text = str(int(scoreVal)) + "%"

func _on_energy_cell_body_entered(body):
	scoreVal += 10
	buffer = false
	await get_tree().create_timer(bufferVal).timeout
	buffer = true
	$Score.text = str(int(scoreVal)) + "%"

func _on_main_character_b_charge_changed(new_bEnergy):
	bEnergy.value = new_bEnergy

func _on_main_character_r_charge_changed(new_rEnergy):
	rEnergy.value = new_rEnergy

func _on_main_character_shot(level):
	var sCost = (level * 2) + 2
	if sCost < scoreVal:
		scoreVal -= sCost
	else:
		scoreVal = 0

func _on_energy_cell_pickedup():
	scoreVal += 10
	buffer = false
	await get_tree().create_timer(bufferVal).timeout
	buffer = true
	$Score.text = str(int(scoreVal)) + "%"

func _on_flag_end():
	emit_signal("pow", str(int(scoreVal)) + "%")
	get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
