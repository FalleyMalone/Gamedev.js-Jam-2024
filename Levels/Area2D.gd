extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	set_physics_process(false)

func _on_body_entered(_body):
	get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")

