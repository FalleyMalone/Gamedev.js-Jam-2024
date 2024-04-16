extends CharacterBody2D

var can_fire = true
#Max Speed
const mSPEED = 400.0
#Start Speed
const sSPEED = 75.0
#Turn Around Time
const tuTime = 12
const JUMP_VELOCITY = -300.0
const acceleration = 2
var extraV := Vector2.ZERO
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if is_on_floor():
		if (velocity.x > 1 || velocity.x < -1):
			sprite_2d.animation = "running"
		else:
			sprite_2d.animation = "default"
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if (velocity.y > 1):
			sprite_2d.animation = "fall"
		else:
			sprite_2d.animation = "jumping"

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if is_on_floor():
		if direction && direction * abs(velocity.x) == velocity.x: #Normal start up
			if velocity.x < sSPEED * direction && velocity.x >= 0 || velocity.x > sSPEED * direction && velocity.x <= 0:
				velocity.x = move_toward(velocity.x, direction * sSPEED, 10)
			else:
				velocity.x = move_toward(velocity.x, direction * mSPEED, acceleration)
		elif direction: #Turning around while moving
			velocity.x = move_toward(velocity.x, direction * sSPEED, tuTime)
		else: #Letting yourself roll to a stop
			velocity.x = move_toward(velocity.x, 0, 10)

	if not is_on_floor() && direction && (velocity.x < sSPEED * direction && velocity.x >= 0 || velocity.x > sSPEED * direction && velocity.x <= 0) :
		velocity.x = move_toward(velocity.x, direction * sSPEED, 8)
		
	if Input.is_action_pressed("Fire") && can_fire:
		var diff := (global_position-get_global_mouse_position()).normalized()*1000
		extraV = diff
		#if velocity > velocity + extraV
		velocity = velocity + extraV
		can_fire = false
		await get_tree().create_timer(1).timeout
		can_fire = true

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
