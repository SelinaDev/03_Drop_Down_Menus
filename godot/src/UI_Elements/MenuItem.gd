class_name MenuItem
extends Control

signal pressed

const fade_duration: float = 0.15

export (Color) var highlight_color

onready var label: Label = $MarginContainer/MarginContainer/HBoxContainer/Label
onready var icon: TextureRect = $MarginContainer/MarginContainer/HBoxContainer/Icon
onready var margin_container: MarginContainer = $MarginContainer
onready var button: Button = $MarginContainer/Button
onready var tween: Tween = $Tween


func _ready() -> void:
	rect_min_size.x = margin_container.rect_size.x
	icon.rect_min_size.x = icon.rect_size.y


func setup(text: String, icon_texture: Texture, icon_color: Color) -> void:
	label.text = text
	icon.texture = icon_texture
	icon.modulate = icon_color


func _on_Button_pressed() -> void:
	emit_signal("pressed")


func _highlight(fade_in) -> void:
	tween.remove(button, "self_modulate")
	
	var start: Color = highlight_color if not fade_in else Color.white
	var target: Color = highlight_color if fade_in else Color.white
	var duration := fade_duration * inverse_lerp(target.r, start.r, button.self_modulate.r)
	
	tween.interpolate_property(
		button, 
		"self_modulate",
		button.self_modulate,
		target,
		duration
	)
	
	tween.start()


func open() -> void:
	button.self_modulate = Color.white
	var duration := fade_duration * inverse_lerp(margin_container.rect_size.y, 0, rect_min_size.y)
	tween.remove(self, "rect_min_size:y")
	tween.interpolate_property(
		self,
		"rect_min_size:y",
		0,
		margin_container.rect_size.y,
		duration
	)
	tween.start()
	

func close() -> void:
	var duration := fade_duration * inverse_lerp(0, margin_container.rect_size.y, rect_min_size.y)
	tween.remove(self, "rect_min_size:y")
	tween.interpolate_property(
		self,
		"rect_min_size:y",
		margin_container.rect_size.y,
		0,
		duration
	)
	tween.start()
