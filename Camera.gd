extends Camera2D

func change_room(pos):
	offset = lerp(offset, pos, .1)