class_name MenuContainer
extends Control

signal button_pressed(button_id)

const menu_item_scene: PackedScene = preload("res://src/UI_Elements/MenuItem.tscn")

onready var v_box: VBoxContainer = $VBoxContainer


func _ready() -> void:
	hide()


func fill(menu_items: Array) -> void:
	for menu_item_config in menu_items:
		create_button(menu_item_config)


func create_button(menu_item_config: MenuItemConfig) -> void:
	var new_menu_item: MenuItem = menu_item_scene.instance()
	v_box.add_child(new_menu_item)
	new_menu_item.connect("pressed", self, "_on_MenuItem_pressed", [menu_item_config.button_id])
	new_menu_item.setup(menu_item_config.text, menu_item_config.icon, menu_item_config.icon_color)


func _on_MenuItem_pressed(button_id: String) -> void:
	emit_signal("button_pressed", button_id)


func set_menu_position(global_position: Vector2) -> void:
	v_box.rect_global_position = global_position


func has_position(global_position: Vector2) -> bool:
	return v_box.get_global_rect().has_point(global_position)


func open() -> void:
	show()
	for item in v_box.get_children():
		item.open()


func close() -> void:
	for item in v_box.get_children():
		item.close()
	yield(get_tree().create_timer(MenuItem.fade_duration), "timeout")
	hide()
