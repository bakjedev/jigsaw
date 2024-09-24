class_name Weapons extends Resource

@export var name : StringName
@export_category("Weapon Transform")
@export var position : Vector3
@export var rotation : Vector3
@export var scale : Vector3
@export_category("Weapon Visuals")
@export var mesh : Mesh
@export_category("Weapon Sway")
@export var sway_min : Vector2 = Vector2(-20, -20)
@export var sway_max : Vector2 = Vector2(20, 20)
@export_range(0, 0.2, 0.01) var sway_speed_position : float = 0.07
@export_range(0, 0.2, 0.01) var sway_speed_rotation : float = 0.1
@export_range(0, 0.25, 0.01) var sway_amount_position : float = 0.1
@export_range(0, 50, 0.1) var sway_amount_rotation : float = 30.0
@export var idle_sway_adjustment : float = 10.0
@export var idle_sway_rotation_strength : float = 300.0
@export_range(0.1, 100.0, 0.1) var random_sway_amount : float = 5.0
