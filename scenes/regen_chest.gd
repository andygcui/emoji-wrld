extends StaticBody2D
var player_inattack_zone = false
var health = 20

func _physics_process(delta):
	deal_with_damage()
	box_opened()

func box_opened():
	if health == 0:
		$AnimatedSprite2D.play("open")
		Global.player_regen()
		health -= 1
		Global.number_chests += 1
		Global.regen_opened += 1
		await get_tree().create_timer(0.5).timeout
		Global.regen_opened += 1

func _on_chest_hitbox_body_entered(body):
	if body.is_in_group("player"):
		player_inattack_zone = true

func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack == true:
		health -= 20
