tool
extends MarginContainer

signal button_pressed(menu, menu_item)

const fade_duration: float = 0.8

export var text: String = "<Button>" setget set_text
export var menu_id: String
export (Array, Resource) var menu_options

onready var highlight: Panel = $Highlight
onready var label: Label = $MarginContainer/Label
onready var tween: Tween = $Tween
onready var menu_container: MenuContainer = $MenuContainer

var spawn_y: float
var _is_open: bool = false

func _ready() -> void:
	set_text(text)
	highlight.modulate.a = 0
	menu_container.fill(menu_options)


func set_text(value: String) -> void:
	text = value
	if not is_inside_tree():
		yield(self, "ready")
	label.text = text


func fade(fade_in: bool) -> void:
	tween.remove_all()
	
	var target := float(fade_in)
	var duration := fade_duration * inverse_lerp(target, 1.0 - target, highlight.modulate.a)
	
	tween.interpolate_property(
		highlight, 
		"modulate:a",
		highlight.modulate.a,
		1 if fade_in else 0,
		duration
	)
	tween.start()


func spawn_menu() -> void:
	var menu_pos := Vector2(rect_global_position.x, spawn_y)
	menu_container.set_menu_position(menu_pos)
	menu_container.open()
	_is_open = true


func _on_Button_pressed() -> void:
	if _is_open:
		menu_container.close()
		_is_open = false
	else:
		spawn_menu()


func has_position(global_position: Vector2) -> bool:
	if get_global_rect().has_point(global_position):
		return true
	return menu_container.has_position(global_position)


func _input(event: InputEvent) -> void:
	if (not event.is_echo() 
		and event.get("position") != null 
		and event.get("pressed") == true 
		and not has_position(event.get("position"))):
		menu_container.close()
		_is_open = false


func _on_MenuContainer_button_pressed(button_id) -> void:
	emit_signal("button_pressed", menu_id, button_id)
	menu_container.close()
	_is_open = false
