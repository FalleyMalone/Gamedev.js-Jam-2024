extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _physics_process(_delta):
	await get_tree().create_timer(0.01).timeout
	#$sprite.frame = 1
	set_physics_process(false)


func _on_body_entered(_body):
	queue_free()
