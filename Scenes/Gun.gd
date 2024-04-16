extends Sprite2D

signal shot

var can_fire = true
var bullet = preload("res://Scenes/bullet.tscn")

var powerL = 100
var powerR = 100

const maxPower = 1000
const charge_speed = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true) # Replace with function body.
	set_z_index(2)

func _physics_process(delta):
	position.x = lerp(position.x, get_parent().position.x, 1)
	position.y = lerp(position.y, get_parent().position.y+5, 1)
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	if Input.is_action_just_pressed("FireL"):
		powerL += int(delta * charge_speed)
		if Input.is_action_just_released("FireL"):
			fire(powerL)
		elif powerL >= maxPower:
			powerL = maxPower
			fire(powerL)
			
	if Input.is_action_just_pressed("FireR"):
		powerR += int(delta * charge_speed)
		if Input.is_action_just_released("FireR"):
			fire(powerR)
		elif powerR >= maxPower:
			powerR = maxPower
			fire(powerR)

func fire(power):
	#Bullet
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = rotation
	bullet_instance.global_position = get_global_position()
	get_parent().add_child(bullet_instance)
	#Knockback
	var diff = (global_position-get_global_mouse_position()).normalized()*power
	emit_signal("shot", diff)
	#Can Fire
	#can_fire = false
	#await get_tree().create_timer(.5).timeout
	#can_fire = true
