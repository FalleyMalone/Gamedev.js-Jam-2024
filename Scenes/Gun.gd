extends Sprite2D
signal shot
signal bCharge_changed
signal rCharge_changed

@onready var bGun = $Gun
@onready var rGun = $RedGun

var bulletB = preload("res://Scenes/bulletB.tscn")
var bgs1 = preload("res://RoBo Sprites/Guns/Blue-Gun1.png")
var bgs2 = preload("res://RoBo Sprites/Guns/Blue-Gun2.png")
var bgs3 = preload("res://RoBo Sprites/Guns/Blue-Gun3.png")
var bgs4 = preload("res://RoBo Sprites/Guns/Blue-Gun4.png")
var bgs5 = preload("res://RoBo Sprites/Guns/Blue-Gun5.png")

var bulletR = preload("res://Scenes/bulletR.tscn")

const power_1 = 400
const power_2 = 600
const power_3 = 800
const power_4 = 1000

const coolDown = 0.5

@export
var chargeTime: float = 1.0

var cdB = 0.0
var current_stateB: ChargeStateB = ChargeStateB.T0
var state_timerB: float = 0.0
enum ChargeStateB {
	T0,
	T1,
	T2,
	T3,
	T4
}

var cdR = 0.0
var current_stateR = ChargeStateR.T0
var state_timerR: float = 0.0
enum ChargeStateR {
	T0,
	T1,
	T2,
	T3,
	T4
}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true) # Replace with function body.
	set_z_index(2)

func _change_state_B(new_state: ChargeStateB) -> void:
	current_stateB = new_state
	match current_stateB:
		ChargeStateB.T0:
			#bGun.texture = bgs1
			cdB = coolDown
			emit_signal("bCharge_changed", 0)
		ChargeStateB.T1:
			#bGun.texture = bgs2
			state_timerB = chargeTime
			emit_signal("bCharge_changed", 1)
		ChargeStateB.T2:
			#bGun.texture = bgs3
			state_timerB = chargeTime
			emit_signal("bCharge_changed", 2)
		ChargeStateB.T3:
			#bGun.texture = bgs4
			state_timerB = chargeTime
			emit_signal("bCharge_changed", 3)
		ChargeStateB.T4:
			#bGun.texture = bgs5
			state_timerB = chargeTime
			emit_signal("bCharge_changed", 4)

func _change_state_R(new_state: ChargeStateR) -> void:
	current_stateR = new_state
	match current_stateR:
		ChargeStateR.T0:
			#bGun.texture = bgs1
			cdR = coolDown
			emit_signal("rCharge_changed", 0)
		ChargeStateR.T1:
			#bGun.texture = bgs2
			state_timerR = chargeTime
			emit_signal("rCharge_changed", 1)
		ChargeStateR.T2:
			#bGun.texture = bgs3
			state_timerR = chargeTime
			emit_signal("rCharge_changed", 2)
		ChargeStateR.T3:
			#bGun.texture = bgs4
			state_timerR = chargeTime
			emit_signal("rCharge_changed", 3)
		ChargeStateR.T4:
			#bGun.texture = bgs5
			state_timerR = chargeTime
			emit_signal("rCharge_changed", 4)

func _process(delta: float) -> void:
	match current_stateB:
		ChargeStateB.T0:
			cdB -= delta
			if Input.is_action_just_pressed("FireL") && cdB <= 0.0:
				_change_state_B(ChargeStateB.T1)
		ChargeStateB.T1:
			state_timerB -= delta
			if state_timerB <= 0.0:
				_change_state_B(ChargeStateB.T2)
			if Input.is_action_just_released("FireL"):
				fire(power_1, "Blue")
				_change_state_B(ChargeStateB.T0)
		ChargeStateB.T2:
			state_timerB -= delta
			if state_timerB <= 0.0:
				_change_state_B(ChargeStateB.T3)
			if Input.is_action_just_released("FireL"):
				fire(power_2, "Blue")
				_change_state_B(ChargeStateB.T0)
		ChargeStateB.T3:
			state_timerB -= delta
			if state_timerB <= 0.0:
				_change_state_B(ChargeStateB.T4)
			if Input.is_action_just_released("FireL"):
				fire(power_3, "Blue")
				_change_state_B(ChargeStateB.T0)
		ChargeStateB.T4:
			if Input.is_action_just_released("FireL"):
				fire(power_4, "Blue")
				_change_state_B(ChargeStateB.T0)
	
	match current_stateR:
		ChargeStateR.T0:
			cdR -= delta
			if Input.is_action_just_pressed("FireR") && cdR <= 0.0:
				_change_state_R(ChargeStateR.T1)
		ChargeStateR.T1:
			state_timerR -= delta
			if state_timerR <= 0.0:
				_change_state_R(ChargeStateR.T2)
			if Input.is_action_just_released("FireR"):
				fire(power_1, "Red")
				_change_state_R(ChargeStateR.T0)
		ChargeStateR.T2:
			state_timerR -= delta
			if state_timerR <= 0.0:
				_change_state_R(ChargeStateR.T3)
			if Input.is_action_just_released("FireR"):
				fire(power_2, "Red")
				_change_state_R(ChargeStateR.T0)
		ChargeStateR.T3:
			state_timerR -= delta
			if state_timerR <= 0.0:
				_change_state_R(ChargeStateR.T4)
			if Input.is_action_just_released("FireR"):
				fire(power_3, "Red")
				_change_state_R(ChargeStateR.T0)
		ChargeStateR.T4:
			if Input.is_action_just_released("FireR"):
				fire(power_4, "Red")
				_change_state_R(ChargeStateR.T0)

func _physics_process(delta):
	#Aims guns at cursor
	position.x = lerp(position.x, get_parent().position.x, 1)
	position.y = lerp(position.y, get_parent().position.y+5, 1)
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)

func fire(power, color):
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
	emit_signal("shot", diff)
