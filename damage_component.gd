class_name DamageComponent
extends Node

@export var damage: float
@export_enum("Fire", "Ice") var damage_type: String = "Fire"
@export_file("*.txt") var lore
@export var color: Color