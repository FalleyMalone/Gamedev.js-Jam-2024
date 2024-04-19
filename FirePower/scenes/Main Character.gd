extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -1738.0
const acc = 50 
const friction = 70
const wall_jump_pushback = 100
const gravity = 400
const wall_slide_gravity = 100
var is_wall_sliding = false

@onready var sprite_2d = $Sprite2D




func _physics_process(delta):
	#Animations
	if (velocity.x >1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else:
			sprite_2d.animation = "idle"
	if not is_on_floor() and velocity.y > 0:
			sprite_2d.animation = "fall"
	if is_on_wall_only() and velocity.y  > 0 and Input.is_action_pressed("right"):
		sprite_2d.animation = "wall jump"
	if is_on_wall_only() and velocity.y  > 0 and Input.is_action_pressed("left"):
		sprite_2d.animation = "wall jump r"
	if Input.is_action_pressed("jump") and velocity.y < 0:
		sprite_2d.animation = "jumping"
		
	jump()
	wall_slide(delta)
	

	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite_2d.animation = "jumping"
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

#Sliding
	if Input.is_action_pressed("slide") and is_on_floor():
		velocity.x = direction * SPEED
		sprite_2d.animation = "slide"

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
	
	
func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)
	
func jump():
	velocity.y += gravity
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if is_on_wall() and Input.is_action_pressed("right"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -wall_jump_pushback
		if is_on_wall() and Input.is_action_pressed("left"):
			velocity.y = JUMP_VELOCITY
			velocity.x = wall_jump_pushback
func wall_slide(delta):
	if is_on_wall_only() and !is_on_floor():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y += (wall_slide_gravity * delta)
		velocity.y = min(velocity.y, wall_slide_gravity)

