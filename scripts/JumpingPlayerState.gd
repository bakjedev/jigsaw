class_name JumpingPlayerState extends PlayerMovementState

@export var SPEED: float = 5.0
@export var ACCELERATION: float = 5.0
@export var DECELERATION: float = 0.0
@export var JUMP_VELOCITY: float = 4.5

func enter(previous_state) -> void:
	PLAYER.velocity.y += JUMP_VELOCITY

func physics_update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(delta, SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	PLAYER.update_fov(delta, 8.0)
	WEAPON.sway_weapon(delta, false)
	if PLAYER.velocity.y < -3.0 and not PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
	
	if PLAYER.is_on_floor():
		transition.emit("IdlePlayerState")
