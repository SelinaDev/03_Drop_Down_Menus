extends PanelContainer

signal button_pressed(menu, button)

onready var h_box: HBoxContainer = $HBoxContainer


func _ready() -> void:
	var spawn_y: float = rect_global_position.y + rect_size.y
	for menu_button in h_box.get_children():
		menu_button.spawn_y = spawn_y
		menu_button.connect("button_pressed", self, "_on_MenuButton_button_pressed")


func _on_MenuButton_button_pressed(menu: String, button: String) -> void:
	emit_signal("button_pressed", menu, button)
