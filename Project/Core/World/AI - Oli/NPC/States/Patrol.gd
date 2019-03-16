extends OLI_STATE_ALERT

func setup(context, args):
	context.path_agent.reset(context)
	
func clean():
	pass

func update(context, delta):
	.update(context, delta)
	var last_position = context.global_transform.origin
	context.global_transform.origin = lerp(context.global_transform.origin, context.path_agent.global_transform.origin, context.lerp_speed)
	context.direction = context.global_transform.origin - last_position
	
	print('$$ Patrol')
	
	
	