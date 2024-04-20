extends CanvasLayer

@onready var bEnergy = $BlueCharge
@onready var rEnergy = $RedCharge

var scoreVal = 100
var buffer = true

const bufferVal = 0.5

func _process(delta):
	if scoreVal > 0 && buffer:
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
