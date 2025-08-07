@tool
class_name ComponentDock
extends VBoxContainer

@onready var message_label: Label = $MessageLabel as Label
@onready var component_properties_control: Control = $ScrollContainer/ComponentProperties as Control

# set in component_editor.gd
var editor_interface: EditorInterface

func _ready() -> void:
	if editor_interface:
		editor_interface.get_selection().selection_changed.connect(_on_selection_changed)

func _on_selection_changed():
	#print_debug("selection changed")
	if editor_interface.get_selection().get_selected_nodes().size() == 0:
		_clear_component_properties()
		message_label.text = "No node selected"
		message_label.show()
	elif editor_interface.get_selection().get_selected_nodes().size() > 1:
		_clear_component_properties()
		message_label.text = "Too many nodes selected"
		message_label.show()
	else:
		message_label.hide()
		var selected_node: Node = editor_interface.get_selection().get_selected_nodes()[0]

		if selected_node is Components:
			_update_all_component_properties(selected_node as Components)
			return

		var components_node: Components
		var has_components: bool = false
		for n: Node in selected_node.get_children():
			if n is Components:
				has_components = true
				components_node = n as Components
				break		

		if has_components:
			_update_all_component_properties(components_node as Components)	
		else:
			_clear_component_properties()
			message_label.text = "Selected node does not have a Components node as a child"
			message_label.show()
			
func _clear_component_properties():
	# Clear any previous UI
	for child in component_properties_control.get_children():
		component_properties_control.remove_child(child)
		child.queue_free()

func _update_all_component_properties(components_node: Components):
	_clear_component_properties()

	print_debug("update all components \n")

	if components_node.export_properties:
		for child: Node in components_node.get_children():
			_update_component_properties(child)

func _update_component_properties(component: Node):
	print_debug("update specific components")

	var fold_button := Button.new() as Button
	fold_button.text = (component.get_script() as Script).get_global_name()
	fold_button.focus_mode = Control.FOCUS_NONE
	fold_button.keep_pressed_outside = false
	fold_button.toggle_mode = true
	#fold_button.button_pressed = true
	fold_button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	#var style_box: StyleBoxFlat = StyleBoxFlat.new() as StyleBoxFlat
	#style_box.bg_color = Color.hex(0x555555FF)
	#fold_button.add_theme_stylebox_override("normal", style_box)
	#fold_button.add_theme_stylebox_override("pressed", style_box)
	#fold_button.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())

	var all_properties_vbox = VBoxContainer.new()

	all_properties_vbox.name = "Properties_" + str(component)

	var properties := (component.get_script() as Script).get_script_property_list()

	for prop in properties:
		var name: String = prop.name
		var usage: int = prop.usage

		# Check if this is a script variable declared with @export
		#print(name)
		if (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != 0:
			# Create an editor control for this property
			var label = Label.new()
			label.text = name

			var field = LineEdit.new()
			field.text = str(component.get(name))
			field.size_flags_horizontal = Control.SIZE_EXPAND_FILL

			# Bind the variable name and component to update on change
			field.text_submitted.connect(func(new_text: String):
				var value = new_text
				# Optional: Type conversion based on hint_type
				component.set(name, value)
			)

			var property_hbox = HBoxContainer.new()
			property_hbox.add_child(label)
			property_hbox.add_child(field)

			all_properties_vbox.add_child(property_hbox)
	
	component_properties_control.add_child(fold_button)
	component_properties_control.add_child(all_properties_vbox)

func get_custom_class_name(node: Node) -> String:
	var result: String
	print(node.get_property_list())
	for prop in node.get_property_list():
		# There is a special property 'script_class' holding the class_name
		if prop.name == "script_class":
			result = node.get(prop.name)
	return result