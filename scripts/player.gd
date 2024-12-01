extends CharacterBody3D


enum  PLAYER_MODES {ATTACKING,IDLE}

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var ui_mode = false
var hp = 10
var last_click = 0
var number_of_clicks = 0 
var start_clicking_time = 0
var playerMode : PLAYER_MODES = PLAYER_MODES.IDLE
const MOVEMENT_RADIUS : float = 15.0
var angle : float = 0.0

var is_handling_input = true
var bug : CharacterBody3D
func _ready():
	bug = get_parent().get_node("bug")
	last_click= Time.get_ticks_msec()

func handle_action(delta:float,ui_mode_en = false):
	
	
	
	if Input.is_action_just_pressed("action"):
		
		last_click= Time.get_ticks_msec()
		start_clicking_time = last_click	
		
	if Input.is_action_pressed("action"):
		if Time.get_ticks_msec() - start_clicking_time >= 200 and number_of_clicks > 0:

			if ui_mode_en:
				match number_of_clicks:
					1:
						_on_playagain_button_down()
					2:
						_on_exit_button_down()
			else:
				handle_clicks()
		elif Time.get_ticks_msec() - start_clicking_time >= 200:
			if ui_mode_en:
				return
			
			angle +=delta
			velocity=  Vector3(cos((angle))* MOVEMENT_RADIUS,0,sin((angle))*MOVEMENT_RADIUS)

			move_and_slide()
			$AnimationPlayer.play("moving")

			pass
		

		
	if Input.is_action_just_released("action"):
		var time_diff = Time.get_ticks_msec()-last_click

		if time_diff <= 200 :
			if number_of_clicks >= 2:
				number_of_clicks = 0
				$Control/clicks.text = "0"
			else:
				number_of_clicks+=1
				$Control/clicks.text = str(number_of_clicks)
			
			pass
			#it is an additional click
		else:
			number_of_clicks = 0
			$Control/clicks.text = "0"
		pass
		
	
		
		print( Time.get_ticks_msec() - start_clicking_time)		
		
		if Time.get_ticks_msec() - start_clicking_time >=200:
			print("we have been talking and just stopped")
		else:		
			print("number of clicks " + str(number_of_clicks))
			
func take_damage(damage:int ):
	hp-=damage
	if hp <=0:
		
		$AnimationPlayer.play("death")
		pass
	pass
	

### this function takes a number of clicks, play certain animation and apply many other things
func handle_clicks():
	is_handling_input = false
	match number_of_clicks:
		1:
			playerMode= PLAYER_MODES.ATTACKING
			$AnimationPlayer.play("punch")
			
			pass
	pass
	
	

func _physics_process(delta):
	look_at(Vector3(bug.global_position.x,global_position.y,bug.global_position.z))
	get_parent().get_node("Camera3D").look_at(global_position)
		
	
	
	if ui_mode:
		handle_action(delta,true)
		
		return
		
	if is_handling_input:
		handle_action(delta)


func _on_hand_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	
	if playerMode == PLAYER_MODES.ATTACKING:
		print( "direct hit")
		body.call("got_attacked")


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"moving":
			$AnimationPlayer.play("idle")
		"punch":
			$AnimationPlayer.play("idle")
			playerMode = PLAYER_MODES.IDLE
			is_handling_input= true
			number_of_clicks=0
			$Control/clicks.text = "0"
		"death":
			ui_mode= true
			$CanvasLayer.visible = true
			pass
	pass # Replace with function body.


func _on_playagain_button_down():
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_exit_button_down():
	get_tree().quit()
	pass # Replace with function body.
