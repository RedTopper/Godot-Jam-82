extends Node
	
func get_direction_name_deg(angle: float, directions: int = 8) -> String:
	var step = 360.0 / float(directions)
	var angle_clamp = fmod(angle + (step / 2.0), 360.0)
	if angle_clamp < 0: angle_clamp += 360.0
	return "%03d_deg" % int(floor(angle_clamp / step) * step)
