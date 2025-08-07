class_name KnockbackComponent
extends Node

@export var knockback_receiver: Node
@export_group("Knockback Values")
@export_exp_easing var acceleration_curve: float
@export_group("Knockback Application")
@export var kb_app_type: KnockbackApplicationType

enum KnockbackApplicationType{
	DIRECT,
	INDIRECT,
	THIRD_OPTION
}