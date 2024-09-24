class_name IdlePlayerState extends PlayerMovementState

@export var SPEED: float = 5.0
@export var ACCELERATION: float = 5.0
@export var DECELERATION: float = 10.0

func physics_update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(delta, SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	PLAYER.update_fov(delta, 8.0)
	WEAPON.sway_weapon(delta, true)
	if PLAYER.velocity.length() > 0.1 and Global.player.is_on_floor():
		transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("Jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if PLAYER.velocity.y < -3.0 and not PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
