class_name SprintingPlayerState extends PlayerMovementState

@export var SPEED: float = 8.0
@export var ACCELERATION: float = 5.0
@export var DECELERATION: float = 10.0
@export var WEAPON_BOB_SPEED : float = 8.0
@export var WEAPON_BOB_H : float = 3.0
@export var WEAPON_BOB_V : float = 1.5

func physics_update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(delta, SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	PLAYER.update_fov(delta, 8.0)
	
	WEAPON.weapon_bob(delta, WEAPON_BOB_SPEED, WEAPON_BOB_H, WEAPON_BOB_V)
	WEAPON.sway_weapon(delta, false)
	
	var forward_dir = -PLAYER.global_transform.basis.z 

	# sprint forward check
	var move_dir = Vector3.ZERO
	if Input.is_action_pressed("Forward"):
		move_dir += -PLAYER.global_transform.basis.z
	if Input.is_action_pressed("Backward"):
		move_dir += PLAYER.global_transform.basis.z
	if Input.is_action_pressed("Left"):
		move_dir += -PLAYER.global_transform.basis.x
	if Input.is_action_pressed("Right"):
		move_dir += PLAYER.global_transform.basis.x
	move_dir = move_dir.normalized()
	
	var dot_product = forward_dir.dot(move_dir)
	if Input.is_action_just_released("Sprint") or dot_product < 0.5:
		transition.emit("WalkingPlayerState")
	
	if PLAYER.velocity.length() <= 0.1:
		transition.emit("IdlePlayerState")
	
	if Input.is_action_just_pressed("Jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if PLAYER.velocity.y < -3.0 and not PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
