extends Sprite2D
signal shot
signal bCharge_changed
signal rCharge_changed

@onready var bGun = $BGun
@onready var rGun = $RGun

var bulletB = preload("res://Scenes/bulletB.tscn")

var bulletR = preload("res://Scenes/bulletR.tscn")

const power_1 = 500
const power_2 = 600
const power_3 = 700
const power_4 = 800

const coolDown = 0.5

@export
var chargeTime: float = 1.0
var bAmmo = 1
var rAmmo = 1
var cdB = true
var cdR = true

var current_stateB: ChargeStateB = ChargeStateB.T0
var state_timerB: float = 0.0
enum ChargeStateB {
	T0,
	T1,
	T2,
	T3,
	T4
}


var current_stateR = ChargeStateR.T0
var state_timerR: float = 0.0
enum ChargeStateR {
	T0,
	T1,
	T2,
	T3,
	T4
}

var current_flipState = flipState.f
enum flipState {
	f,
	t,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true) # Replace with function body.
	set_z_index(2)


func _change_state_B(new_state: ChargeStateB) -> void:
	current_stateB = new_state
	match current_stateB:
		ChargeStateB.T0:
			bGun.animation = "T0"
			cdB = coolDown
			emit_signal("bCharge_changed", 0)
		ChargeStateB.T1:
			bGun.animation = "T1"
			state_timerB = chargeTime
			emit_signal("bCharge_changed", 1)
		ChargeStateB.T2:
			bGun.animation = "T2"
			state_timerB = chargeTime
			emit_signal("bCharge_changed", 2)
		ChargeStateB.T3:
			bGun.animation = "T3"
			state_timerB = chargeTime
			emit_signal("bCharge_changed", 3)
		ChargeStateB.T4:
			bGun.animation = "T4"
			state_timerB = chargeTime
			emit_signal("bCharge_changed", 4)

func _change_state_R(new_state: ChargeStateR) -> void:
	current_stateR = new_state
	match current_stateR:
		ChargeStateR.T0:
			rGun.animation = "T0"
			cdR = coolDown
			emit_signal("rCharge_changed", 0)
		ChargeStateR.T1:
			rGun.animation = "T1"
			state_timerR = chargeTime
			emit_signal("rCharge_changed", 1)
		ChargeStateR.T2:
			rGun.animation = "T2"
			state_timerR = chargeTime
			emit_signal("rCharge_changed", 2)
		ChargeStateR.T3:
			rGun.animation = "T3"
			state_timerR = chargeTime
			emit_signal("rCharge_changed", 3)
		ChargeStateR.T4:
			rGun.animation = "T4"
			state_timerR = chargeTime
			emit_signal("rCharge_changed", 4)

func _change_flipState(new_state: flipState) -> void:
	current_flipState = new_state
	match flipState:
		flipState.f:
			print("flip")
			bGun.flip_v = false
			rGun.flip_v = false
		flipState.t:
			print("flip")
			bGun.flip_v = true
			rGun.flip_v = true


func _process(delta: float) -> void:
	match current_stateB:
		ChargeStateB.T0:
			if Input.is_action_just_pressed("FireL") && bAmmo > 0:
				_change_state_B(ChargeStateB.T1)
		ChargeStateB.T1:
			state_timerB -= delta
			if state_timerB <= 0.0:
				_change_state_B(ChargeStateB.T2)
			if Input.is_action_just_released("FireL"):
				if not cdB:
					bAmmo = 0
				fire(power_1, "Blue", 1)
				_change_state_B(ChargeStateB.T0)
		ChargeStateB.T2:
			state_timerB -= delta
			if state_timerB <= 0.0:
				_change_state_B(ChargeStateB.T3)
			if Input.is_action_just_released("FireL"):
				if not cdB:
					bAmmo = 0
				fire(power_2, "Blue", 2)
				_change_state_B(ChargeStateB.T0)
		ChargeStateB.T3:
			state_timerB -= delta
			if state_timerB <= 0.0:
				_change_state_B(ChargeStateB.T4)
			if Input.is_action_just_released("FireL"):
				if not cdB:
					bAmmo = 0
				fire(power_3, "Blue", 3)
				_change_state_B(ChargeStateB.T0)
		ChargeStateB.T4:
			if Input.is_action_just_released("FireL"):
				if not cdB:
					bAmmo = 0
				fire(power_4, "Blue", 4)
				_change_state_B(ChargeStateB.T0)
	
	match current_stateR:
		ChargeStateR.T0:
			if Input.is_action_just_pressed("FireR") && rAmmo > 0:
				_change_state_R(ChargeStateR.T1)
		ChargeStateR.T1:
			state_timerR -= delta
			if state_timerR <= 0.0:
				_change_state_R(ChargeStateR.T2)
			if Input.is_action_just_released("FireR"):
				if not cdR:
					rAmmo = 0
				fire(power_1, "Red", 1)
				_change_state_R(ChargeStateR.T0)
		ChargeStateR.T2:
			state_timerR -= delta
			if state_timerR <= 0.0:
				_change_state_R(ChargeStateR.T3)
			if Input.is_action_just_released("FireR"):
				if not cdR:
					rAmmo = 0
				fire(power_2, "Red", 2)
				_change_state_R(ChargeStateR.T0)
		ChargeStateR.T3:
			state_timerR -= delta
			if state_timerR <= 0.0:
				_change_state_R(ChargeStateR.T4)
			if Input.is_action_just_released("FireR"):
				if not cdR:
					rAmmo = 0
				fire(power_3, "Red", 3)
				_change_state_R(ChargeStateR.T0)
		ChargeStateR.T4:
			if Input.is_action_just_released("FireR"):
				if not cdR:
					rAmmo = 0
				fire(power_4, "Red", 4)
				_change_state_R(ChargeStateR.T0)

func _physics_process(delta):
	#Aims guns at cursor
	position.x = lerp(position.x, get_parent().position.x, 1)
	position.y = lerp(position.y, get_parent().position.y+5, 1)
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)

func fire(power, color, level):
	print("Power: " + str(power))
	#Bullet
	var bullet_instance = bulletB.instantiate()
	if color == "Red":
		bullet_instance = bulletR.instantiate()
	bullet_instance.rotation = rotation
	bullet_instance.global_position = get_global_position()
	get_parent().add_child(bullet_instance)
	#Knockback
	var diff = (global_position-get_global_mouse_position()).normalized()*power
	emit_signal("shot", diff, level)

func _on_main_character_flip_sprite(toggle):
	bGun.flip_v = toggle
	rGun.flip_v = toggle
	if toggle:
		bGun.offset.x = 8
		rGun.offset.x = 0
		bGun.offset.y = 2
		rGun.offset.y = 1
		bGun.z_index = 1
		rGun.z_index = 3
	else:
		bGun.offset.x = 0
		rGun.offset.x = 8
		bGun.offset.y = -1
		rGun.offset.y = -2
		bGun.z_index = 3
		rGun.z_index = 1


func _on_main_character_on_floor(switch):
	cdB = switch
	cdR = switch
	if switch:
		bAmmo = 1
		rAmmo = 1
