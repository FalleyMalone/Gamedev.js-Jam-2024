extends CharacterBody2D

signal bCharge_changed
signal rCharge_changed
signal flipSprite
signal shot
signal on_floor

#Max Speed
const mSPEED = 400.0
#Start Speed
const sSPEED = 75.0
#Air Speed
const aSPEED = 50.0
#Turn Around Time
const tuTime = 30
#Jump hight
const JUMP_VELOCITY = -400.0
#Running acceleration
const acceleration = 2
#Max v from KB
const mKB = 1400.0

var extraV := Vector2.ZERO
@onready var sprite_2d = $Sprite2D

# Get the grav90ity from the project settings to be synced with RigidBody nodes.
var curGrav = ProjectSettings.get_setting("physics/2d/default_gravity")
var slideGrav = curGrav + 700
var baseGrav = curGrav

var current_mousePos_state: mousePos = mousePos.right
enum mousePos {
	left,
	right
}
var current_Health: healthState = healthState.alive
enum healthState{
	alive,
	hurt,
	dead
}
var current_ground_state: groundState = groundState.idle
enum groundState{
	idle,
	walking,
	sprinting,
	off
}
var current_air_state: airState = airState.decending
enum airState{
	accending,
	decending,
	wallJump,
	off
}
var current_ga_state: gaState = gaState.ground
enum gaState{
	ground,
	air,
	sliding
}


func _ready():
	#set_z_index(1)
	pass


func _change_state_mousePos(new_state: mousePos) -> void:
	current_mousePos_state = new_state
	match current_mousePos_state:
		mousePos.right:
			sprite_2d.flip_h = false
			emit_signal("flipSprite", false)
		mousePos.left:
			sprite_2d.flip_h = true
			emit_signal("flipSprite", true)
func _change_state_healthState(new_state: healthState) -> void:
	current_Health = new_state
	match current_Health:
		healthState.alive:
			pass
		healthState.hurt:
			pass
		healthState.dead:
			pass
func _change_state_groundState(new_state: groundState) -> void:
	current_ground_state = new_state
	match current_ground_state:
		groundState.idle:
			sprite_2d.animation = "default"
			print("idle")
		groundState.walking:
			sprite_2d.animation = "walking"
			print("walking")
		groundState.sprinting:
			sprite_2d.animation = "running"
			print("sprinting")
func _change_state_airState(new_state: airState) -> void:
	current_air_state = new_state
	match current_air_state:
		airState.decending:
			sprite_2d.animation = "fall"
		airState.accending:
			sprite_2d.animation = "jumping"
		airState.wallJump:
			pass
func _change_state_gaState(new_state: gaState) -> void:
	current_ga_state = new_state
	match current_ga_state:
		gaState.ground:
			emit_signal("on_floor", true)
			agBuffer_helper()
			_change_state_airState(airState.off)
		gaState.air:
			emit_signal("on_floor", false)
			_change_state_groundState(groundState.off)
			if (velocity.y < 0):
				_change_state_airState(airState.accending)
			else:
				_change_state_airState(airState.decending)



func _process(delta: float) -> void:
	var localPos = get_local_mouse_position()
	match current_mousePos_state:
		mousePos.right:
			if localPos.x < 0:
				_change_state_mousePos(mousePos.left)
		mousePos.left:
			if localPos.x >= 0:
				_change_state_mousePos(mousePos.right)
	
	match current_Health:
		healthState.alive:
			pass
		healthState.hurt:
			pass
		healthState.dead:
			pass

func _physics_process(delta):
	velocity.y += baseGrav * delta
	var direction = Input.get_axis("Left", "Right")
	move_and_slide()
	#might want to switch to velocity normalized for slopes
	match current_ground_state:
		groundState.idle:
			if (velocity.x > 300 || velocity.x < -300) && not is_on_wall():
				_change_state_groundState(groundState.sprinting)
			if (velocity.x > 1 || velocity.x < -1) && not is_on_wall():
				_change_state_groundState(groundState.walking)
		groundState.walking:
			if (velocity.x > 300 || velocity.x < -300):
				_change_state_groundState(groundState.sprinting)
			if (velocity.x <= 1 && velocity.x >= -1) || is_on_wall():
				_change_state_groundState(groundState.idle)
		groundState.sprinting:
			if (velocity.x < 300 && velocity.x > -300) && (velocity.x > 1 || velocity.x < -1):
				_change_state_groundState(groundState.walking)
			if (velocity.x <= 1 && velocity.x >= -1) || is_on_wall():
				_change_state_groundState(groundState.idle)
	
	match current_air_state:
		airState.decending:
			if (velocity.y < 0):
				_change_state_airState(airState.accending)
		airState.accending:
			if (velocity.y > 0):
				_change_state_airState(airState.decending)
	
	match current_ga_state:
		gaState.ground:
			velocity.y = get_real_velocity().y * .9
			# Get the input direction and handle the movement/deceleration.
			if direction && direction * abs(velocity.x) == velocity.x: #Normal start up
				if velocity.x < sSPEED * direction && velocity.x >= 0 || velocity.x > sSPEED * direction && velocity.x <= 0:
					velocity.x = move_toward(velocity.x, direction * sSPEED, 10)
				else:
					velocity.x = move_toward(velocity.x, direction * mSPEED, acceleration)
			elif direction: #Turning around while moving
				velocity.x = move_toward(velocity.x, direction * sSPEED, tuTime)
			else: #Letting yourself roll to a stop
				velocity.x = move_toward(velocity.x, 0, 15)
			#Jumping
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
			#State Change
			if not is_on_floor():
				_change_state_gaState(gaState.air)
		gaState.air:
			velocity = get_real_velocity()
			#Mid air controls
			#velocity.x = velocity.x + (direction * (aSPEED / (velocity.x + 1)))
			#State Change
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, 20)
				if velocity.x < 5 && velocity.x > -5:
					_change_state_gaState(gaState.ground)


func agBuffer_helper():
	if (velocity.x > 300 || velocity.x < -300):
		_change_state_groundState(groundState.sprinting)
	elif (velocity.x > 1 || velocity.x < -1):
		_change_state_groundState(groundState.walking)
	else:
		_change_state_groundState(groundState.idle)

func _on_guns_shot(direction, level):
	var tVelocity = velocity + direction
	velocity = tVelocity.limit_length(mKB)
	print("Velocity " + str(velocity))
	emit_signal("shot", level)

func _on_guns_b_charge_changed(level):
	emit_signal("bCharge_changed", level)

func _on_guns_r_charge_changed(level):
	emit_signal("rCharge_changed", level)
