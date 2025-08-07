@tool
extends EditorPlugin


var dock: Control

func _enter_tree() -> void:
	_add_dock()

# REMOVE BEFORE RELEASE
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		_reload_dock()

func _exit_tree() -> void:
	_remove_dock()

func _add_dock():
	dock = preload("res://addons/component_editor/ComponentDock.tscn").instantiate() as Control
	(dock as ComponentDock).editor_interface = get_editor_interface()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)

func _remove_dock():
	remove_control_from_docks(dock)
	dock.queue_free()

func _reload_dock():
	if dock:
		_remove_dock()

	_add_dock()