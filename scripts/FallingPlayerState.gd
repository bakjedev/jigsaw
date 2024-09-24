class_name FallingPlayerState extends PlayerMovementState

@export var SPEED: float = 5.0
@export var ACCELERATION: float = 5.0
@export var DECELERATION: float = 0.0

func physics_update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(delta, SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	PLAYER.update_fov(delta, 8.0)
	WEAPON.sway_weapon(delta, false)
	if PLAYER.is_on_floor():
		transition.emit("IdlePlayerState")
