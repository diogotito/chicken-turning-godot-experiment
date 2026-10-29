extends AnimatedSprite3D

func _ready() -> void:
	var t := create_tween()
	t.tween_await(animation_finished)
	t.tween_property(self, ^"modulate:a", 0.0, 0.2)
	t.tween_callback(queue_free)


func boom():
	(create_tween()
		.tween_property(%stick, ^"position:y", 0, 0.8)
		.set_ease(Tween.EASE_OUT)
		.set_trans(Tween.TRANS_BOUNCE))
	await get_tree().create_timer(0.4).timeout
	get_tree().call_group(&"perishable", &"queue_free")
	(create_tween()
		.tween_property(get_window(), ^"position:y", 80, 0.4).as_relative()
		.set_trans(Tween.TRANS_EXPO)
		.set_ease(Tween.EASE_OUT))
	play()
	await frame_changed
	await frame_changed;  clone(Vector3(-0.68,  0.3, 0), 0.7)
	await frame_changed;  clone(Vector3( 0.68,  0.3, 0), 0.6)
	await frame_changed
	await frame_changed;  clone(Vector3( 0.68, -0.3, 0), 0.5)
	await frame_changed; (clone(Vector3(-0.68, -0.3, 0), 0.4)
						   .animation_finished
						   .connect(get_tree().quit))


func clone(offset_by: Vector3, scale_by: float = 1.0) -> AnimatedSprite3D:
	get_window().position += Vector2i(randi_range(-25, 25), randi_range(-10, 15))
	var dupe := duplicate(DUPLICATE_SCRIPTS) as AnimatedSprite3D
	dupe.position = position + offset_by
	dupe.scale *= scale_by
	dupe.modulate *= sqrt(scale_by)
	dupe.play()
	add_sibling(dupe)
	return dupe
