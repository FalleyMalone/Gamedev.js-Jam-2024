extends CharacterBody2D

#Max Speed
const mSPEED = 400.0
#Start Speed
const sSPEED = 75.0
#Turn Around Time
const tuTime = 12
#Jump hight
const JUMP_VELOCITY = -300.0
#Running acceleration
const acceleration = 2
#Max v from KB
const mKB = 1400.0

var extraV := Vector2.ZERO
var can_fire = true
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_z_index(1)

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
	
	#Mid air controls
	if not is_on_floor() && direction && (velocity.x < sSPEED * direction && velocity.x >= 0 || velocity.x > sSPEED * direction && velocity.x <= 0) :
		velocity.x = move_toward(velocity.x, direction * sSPEED, 8)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft

#Gun One Knockback
func _on_gun_shot(direction):
	var tVelocity = direction + velocity
	velocity = tVelocity

#Gun Two Knockback
func _on_gun_two_shot(direction):
	var tVelocity = direction + velocity
	velocity = tVelocity

func _on_guns_shot(direction):
	var tVelocity = direction + velocity
	velocity = tVelocity
