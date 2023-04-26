extends Control

onready var demo_label: Label = $DemoLabel


func _on_MenuBar_button_pressed(_menu, button) -> void:
	demo_label.show_result(button)
