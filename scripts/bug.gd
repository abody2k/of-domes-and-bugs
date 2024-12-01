extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
enum BUG_MODES {IDLE,ATTACKING}
var bug_mode : BUG_MODES = BUG_MODES.IDLE
var hp = 10
var player  : CharacterBody3D


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
