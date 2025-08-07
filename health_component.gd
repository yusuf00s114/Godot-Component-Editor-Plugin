class_name HealthComponent
extends Node

@export var max_health: float = 100
@export_range(0, 100) var resistance: float = 5
@export var death_message: String

func _init() -> void:
	pass