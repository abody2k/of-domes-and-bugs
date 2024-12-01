extends CharacterBody3D

enum STATES {IDLE,ATTACKING,AVOIDING}
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
enum BUG_MODES {IDLE,ATTACKING}
var bug_mode : BUG_MODES = BUG_MODES.IDLE
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
	
	$AnimationPlayer.play("idle")
	pass



func _on_attacking_zone_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if bug_mode == BUG_MODES.IDLE:
		return
	else:
		body.call("take_damage",1)
	pass # Replace with function body.


## this function is called when the player triggers an attack, the bug either avoid it or take it like a champ XD
func player_about_to_attack():
	pass
	

func attack():
	pass
	
	
	
func _on_timer_timeout():
	#The bug either stays idle or it attacks depending on a random value
	if randf() > .5 :
		
		pass #ATTACK
	else:
		#DO NOTHING
		pass
	pass # Replace with function body.
