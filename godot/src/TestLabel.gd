extends Label

const fade_duration: float = 1.0

onready var tween: Tween = $Tween
onready var timer: Timer = $Timer

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	modulate = Color.transparent
	rng.randomize()


func show_result(die: String) -> void:
	var dice_number := int(die.substr(1))
	var result = rng.randi_range(1, dice_number)
	text = "Rolled a %s\nRusult: %d" % [die, result]
	
	tween.remove_all()
	tween.interpolate_property(
		self, 
		"modulate:a", 
		modulate.a,
		1,
		fade_duration * (1-modulate.a)
	)
	tween.start()
	timer.start()


func _on_Timer_timeout() -> void:
	tween.interpolate_property(
		self,
		"modulate:a",
		1,
		0, 
		fade_duration
	)
	tween.start()
