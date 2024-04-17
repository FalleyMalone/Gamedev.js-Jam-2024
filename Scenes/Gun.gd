extends Sprite2D
signal shot

var bullet = preload("res://Scenes/bullet.tscn")

var can_fireL = true
var can_fireR = true
var powerL = 100
var powerR = 100
var is_charging_R = false
var is_charging_L = false

const maxPower = 1000
const charge_speed = 150
const coolDown = 0.5


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true) # Replace with function body.
	set_z_index(2)


func _physics_process(delta):
	#Aims guns at cursor
	position.x = lerp(position.x, get_parent().position.x, 1)
	position.y = lerp(position.y, get_parent().position.y+5, 1)
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	#Handles start of charge L
	if is_charging_L && can_fireL:
		powerL += delta * charge_speed
	else:
		stop_charge("L")
	#Handles end of charge L
	if Input.is_action_just_released("FireL") && can_fireL:
		if powerL >= maxPower:
			powerL = maxPower
		fire(powerL)
		stop_charge("L")
		can_fireL = false
		await get_tree().create_timer(coolDown).timeout
		can_fireL = true
	
	#Handles start of charge R
	if is_charging_R && can_fireR:
		powerR += delta * charge_speed
	else:
		stop_charge("R")
	#Handles end of charge R
	if Input.is_action_just_released("FireR") && can_fireR:
		if powerR >= maxPower:
			powerR = maxPower
		fire(powerR)
		stop_charge("R")
		can_fireR = false
		await get_tree().create_timer(coolDown).timeout
		can_fireR = true


#Waits for mouse input
func _input(_event):
	if Input.is_action_just_pressed("FireL") && can_fireL:
		start_charge("L")
	if Input.is_action_just_pressed("FireR") && can_fireR:
		start_charge("R")


#Starts the charge build up
func start_charge(c):
	if c == "L":
		is_charging_L = true
	else:
		is_charging_R = true


#Resets to base case
func stop_charge(c):
	if c == "L":
		is_charging_L = false
		powerL = 100
	else:
		is_charging_R = false
		powerR = 100


#Is called to fire gun
func fire(power):
	print("Power: " + str(power))
	#Bullet
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = rotation
	bullet_instance.global_position = get_global_position()
	get_parent().add_child(bullet_instance)
	#Knockback
	var diff = (global_position-get_global_mouse_position()).normalized()*power
	emit_signal("shot", diff)
