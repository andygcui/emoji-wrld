extends CharacterBody2D

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var angel_cooldown = true
var demon_cooldown = true
var health = 100
var player_alive = true
var attacking = false
var demon_in_range = false
var angel_in_range = false

var speed = 200
#Players current direction
var current_dir = "none"

func player():
	pass
	
func _ready():
	#screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play("front_idle")
	

func _physics_process(delta):
	attack()
	player_movement(delta)
	current_camera()
	enemy_attack()
	update_health()
	demon_attack()
	angel_heal()
	chest_regen()
	chest_speed()
	chest_invis()
	if Input.is_action_just_pressed("attack"):
		await get_tree().create_timer(0.5).timeout
		DialogueManager.show_example_dialogue_balloon(load("res://chests.dialogue"), "chests")
	
	if health <= 0:
		Global.game_first_loadin = true
		Global.transition_scene = true
		Global.finish_changescene()
		get_tree().change_scene_to_file("res://game_over.tscn")
		player_alive = false
		health = 0
		print("You died")
		self.queue_free()

func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		$music_attack.play()
		Global.player_current_attack = true
		attacking = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()

#Move and animate player based based on input
func player_movement(delta):
	#var velocity = Vector2.ZERO
	#Grid based player movement logic
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_animation(1)
		velocity.x += speed
		#velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_animation(1)
		velocity.x -= speed
		#velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_animation(1)
		#velocity.x = 0
		velocity.y -= speed
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_animation(1)
		#velocity.x = 0
		velocity.y += speed
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	move_and_slide()

	position += velocity * delta

func play_animation(movement):
	var dir = current_dir
	var animation = $AnimatedSprite2D
	
	if dir == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if attacking == false:
				animation.play("side_idle")
	
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if attacking == false:
				animation.play("side_idle")
	
	if dir == "up":
		animation.flip_h = false
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			if attacking == false:
				animation.play("back_walk")
	
	if dir == "down":
		animation.flip_h = false
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			if attacking == false:
				animation.play("front_walk")

func current_camera():
	if Global.current_scene == "world":
		$world_camera.enabled = true
		$house_camera.enabled = false
	elif Global.current_scene == "house":
		$world_camera.enabled = false
		$house_camera.enabled = true

func _on_player_hitbox_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("ghost") or body.is_in_group("skeleton"):
		enemy_in_attack_range = true
	elif body.is_in_group("demon"):
		demon_in_range = true
	elif body.is_in_group("angel"):
		angel_in_range = true

func _on_player_hitbox_body_exited(body):
	if body.is_in_group("enemy") or body.is_in_group("ghost") or body.is_in_group("skeleton"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		$get_hit.play()
		health -= 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("player health: " + str(health))

func angel_heal():
	if angel_in_range and angel_cooldown == true and attacking:
		health += 20
		if health >= 100:
			health = 100
		angel_cooldown = false
		$angel_cooldown.start()

func demon_attack():
	if demon_in_range and demon_cooldown == true and attacking:
		health -= 20
		demon_cooldown = false
		$demon_cooldown.start()

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func chest_regen():
	if Global.regen == 20:
		health = 100
		Global.regen = 0

func chest_speed():
	if Global.speed == 20:
		speed = 300
		$music_speed.play()
		await get_tree().create_timer(30.0).timeout
		Global.speed_back = true
		$music_speed.stop()
		speed = 200

func chest_invis():
	if Global.invisible == 20:
		$music_invisible.play()
		$AnimatedSprite2D.hide()
		health = 100
	else:
		$music_invisible.stop()
		$AnimatedSprite2D.show()

	await get_tree().create_timer(1).timeout

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attacking = false

func update_health():
	var health_bar = $health_bar
	health_bar.value = health
	
	if health >= 100:
		health_bar.visible = false
	else:
		health_bar.visible = true
