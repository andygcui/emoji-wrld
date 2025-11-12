extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$music.play()

func _process(delta):
	change_scene()
	

func _on_house_exit_point_body_entered(body):
	if body.is_in_group("player"):
		Global.transition_scene = true
		

func _on_house_exit_point_body_exited(body):
	if body.is_in_group("player"):
		Global.transition_scene = false

func change_scene():
	if Global.transition_scene == true:
		if Global.current_scene == "house":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			Global.finish_changescene()

