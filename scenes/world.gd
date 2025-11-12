extends Node2D

func _ready():
	if Global.game_first_loadin == true:
		$player.position.x = Global.player_start_posx
		$player.position.y = Global.player_start_posy
	else:
		$player.position.x = Global.player_exit_house_posx
		$player.position.y = Global.player_exit_house_posy

func _process(delta):
	change_scene()
	Global.collected()
	change_background()

func _on_house_transition_point_body_entered(body):
	if body.is_in_group("player"):
		Global.transition_scene = true


func _on_house_transition_point_body_exited(body):
	if body.is_in_group("player"):
		Global.transition_scene = false

func change_scene():
	if Global.transition_scene == true:
		if Global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/house.tscn")
			Global.game_first_loadin = false
			Global.finish_changescene()

func change_background():
	if Global.background_opened == 1:
		await get_tree().create_timer(0.2).timeout
		$Night.visible = false
		$Day.visible = true

