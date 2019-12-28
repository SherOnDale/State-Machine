extends "res://Scripts/Character.gd"


var motion = Vector2()
var state_machine

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	update_motion(delta)
	move_and_slide(motion)
	
func update_motion(delta):
	if Input.is_action_pressed("ui_left")  and not Input.is_action_pressed("ui_right"):
		motion.x = clamp((motion.x - SPEED), -MAX_SPEED, 0)
		if Input.is_action_just_pressed('shoot'):
			state_machine.travel("run and shoot")
		else:
			state_machine.travel("run")
	elif Input.is_action_pressed("ui_right")  and not Input.is_action_pressed("ui_left"):
		motion.x = clamp((motion.x + SPEED), 0, MAX_SPEED)
		if Input.is_action_just_pressed('shoot'):
			state_machine.travel("run and shoot")
		else:
			state_machine.travel("run")
	else:
		motion.x = lerp(motion.x, 0, FRICTION)
		if not Input.is_action_just_pressed('shoot'):
			state_machine.travel("idle")
	$RunSprite.flip_h = motion.x < 0
	$RunAndShootSprite.flip_h = motion.x < 0
		
func _input(event):
	if Input.is_action_just_pressed('shoot'):
		state_machine.travel("shoot")