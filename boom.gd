extends AnimatedSprite3D

func boom():
	(create_tween()
		.tween_property(%stick, "position:y", 0, 0.8)
		.set_ease(Tween.EASE_OUT)
		.set_trans(Tween.TRANS_BOUNCE))
	await get_tree().create_timer(0.4).timeout
	play()
	await animation_finished
	get_tree().quit()
