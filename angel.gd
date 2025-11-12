extends CharacterBody2D
var player_in_range = false

func _physics_process(delta):
	$AnimatedSprite2D.play("idle")
	if player_in_range == true:
		if Input.is_action_just_pressed("ui_accept"):
			$sound.play()
			DialogueManager.show_example_dialogue_balloon(load("res://angel.dialogue"), "angel")
			return


func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true


func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
