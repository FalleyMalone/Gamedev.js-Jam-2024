extends Area2D

var speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true) # Replace with function body.

func _process(delta):
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta
	Vector2(1.0,0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	await get_tree().create_timer(0.01).timeout
	#$sprite.frame = 1
	set_physics_process(false)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Replace with function body.


func _on_body_entered(body):
	if !body.is_in_group("mainCharacter"):
		queue_free()
