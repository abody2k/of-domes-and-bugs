extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var last_click = 0
var number_of_clicks = 0 
var start_clicking_time = 0

func _ready():
	last_click= Time.get_ticks_msec()

func handle_action():
	
	
	
	if Input.is_action_just_pressed("action"):
		

		
		last_click= Time.get_ticks_msec()
		start_clicking_time = last_click
		
		
		
	if Input.is_action_pressed("action"):
		if Time.get_ticks_msec() - start_clicking_time >= 200 and number_of_clicks > 0:
			print("making a kick of a power of " + str(number_of_clicks))
			#stop handing this process
			#activate the move
			#play the animation and all
			#reset the number of clicks
			#resume the process again
		else:
			print("moving in a circle")
			#start moving in a circle 
			pass
		pass
		
		
		
		
	if Input.is_action_just_released("action"):
		var time_diff = Time.get_ticks_msec()-last_click
		if time_diff <= 200 :
			number_of_clicks+=1
			pass
			#it is an additional click
		else:
			number_of_clicks = 0
		pass
		
		
		
		print( Time.get_ticks_msec() - start_clicking_time)		
		
		if Time.get_ticks_msec() - start_clicking_time >=200:
			print("we have been talking and just stopped")
		else:		
			print("number of clicks " + str(number_of_clicks))
			


func _physics_process(delta):
	
	handle_action()
