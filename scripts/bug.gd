extends CharacterBody3D

enum STATES {IDLE,ATTACKING,AVOIDING}
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var hp = 10
var player  : CharacterBody3D
var state : STATES = STATES.IDLE



func _ready():
	player = get_parent().get_node("player")
func got_attacked():
	hp-=1
	return

func _physics_process(_delta):
	look_at(Vector3(player.global_position.x,global_position.y,player.global_position.z))
	
	pass



func _on_attacking_zone_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if state != STATES.ATTACKING:
		return
	else:
		print("just attacked THE PLAYER SUCCESSFULLY")
		body.call("take_damage",1)
	pass # Replace with function body.


## this function is called when the player triggers an attack, the bug either avoid it or take it like a champ XD
func player_about_to_attack():
	pass
	

func attack():
	print("trying")
	if randf() > .5 :
		print("success")
		state = STATES.AVOIDING
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
	#The bug either stays idle or it attacks depending on a random value
	if randf() > .5 and state != STATES.AVOIDING and state != STATES.ATTACKING :# we can alter this later to provide an attack while jumping
		state =  STATES.ATTACKING
		$AnimationPlayer.play("attack_below")
		var temp_tween = get_tree().create_tween()
		temp_tween.finished.connect(make_it_go_backward)
		temp_tween.tween_method(go_forward,0,10,0.1)
		
		
		pass #ATTACK
	else:
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
