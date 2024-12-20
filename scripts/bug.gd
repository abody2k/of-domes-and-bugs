extends CharacterBody3D

enum STATES {IDLE,ATTACKING,AVOIDING}
const SPEED = 3.0
const JUMP_VELOCITY = 4.5
var hp = 50
var player  : CharacterBody3D
@export var state : STATES = STATES.IDLE
var dead = false


func _ready():
	player = get_parent().get_node("player")
	$AnimationPlayer.play("idle")
	
	
	
func got_attacked():
	hp-=1
	get_parent().get_node("CanvasLayer/Control/bug").value = hp
	if hp <= 0:
		dead=true
		$AnimationPlayer.play("death")
		$Timer.stop()
		set_physics_process(false)
	elif hp ==1:
		(get_parent().get_node("AudioStreamPlayer") as AudioStreamPlayer).volume_db+=10
		
	return

func _physics_process(_delta):
	if global_position != Vector3(player.global_position.x,global_position.y,player.global_position.z):
		look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z))
	if state == STATES.IDLE and global_position.distance_squared_to(player.global_position) > 500 :
		velocity = -basis.z * SPEED
		move_and_slide()
	if state == STATES.IDLE and global_position.distance_squared_to(player.global_position) < 200 :
		velocity = basis.z * SPEED * 2
		move_and_slide()
	pass



func _on_attacking_zone_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if state != STATES.ATTACKING:
		return
	else:
		body.call("take_damage",1)
	pass # Replace with function body.


## this function is called when the player triggers an attack, the bug either avoid it or take it like a champ XD
func player_about_to_attack():
	pass
	

func attack():
	if randf() > .5 and global_position.distance_squared_to(player.global_position) <= 200:
		state = STATES.AVOIDING
		$wing.play()
		$AnimationPlayer.play("avoid")
	pass
	
	
func go_forward(_v):
	velocity = basis.z * SPEED
	move_and_slide()
	
func go_backward(_v):
	velocity = -basis.z * SPEED
	move_and_slide()

func make_it_go_backward():
	var temp_tween2 = get_tree().create_tween()
	temp_tween2.tween_method(go_backward,0,10,0.9)
	pass
	
func _on_timer_timeout():
	if dead:
		return
		
	if global_position.distance_squared_to(player.global_position) > 500:
			state = STATES.IDLE
			return
	#The bug either stays idle or it attacks depending on a random value
	if randf() > .5 and state == STATES.IDLE:# we can alter this later to provide an attack while jumping
		state =  STATES.ATTACKING
		$AnimationPlayer.play("attack_below")
		var temp_tween = get_tree().create_tween()
		temp_tween.finished.connect(make_it_go_backward)
		temp_tween.tween_method(go_forward,0,10,0.1)
		
		
		pass #ATTACK
	elif state == STATES.ATTACKING and !$AnimationPlayer.is_playing():
		state = STATES.IDLE
		$AnimationPlayer.play("idle")
		#DO NOTHING
		pass
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		#"attack_below":
			#state = STATES.IDLE
			#$AnimationPlayer.play("idle")
		"avoid":
			state = STATES.IDLE
			$AnimationPlayer.play("idle")
		"death":
			player.call("_on_animation_player_animation_finished","death")
