tool
extends Node

export(bool) var reset = false setget onReset
export(String, FILE, "*png") var tilesheet
export(int) var tilesize


func onReset(isTriggered):
	if (isTriggered):
		var sheet = load(tilesheet)
		reset = false
		var cols = sheet.get_width() / tilesize
		var rows = sheet.get_height() / tilesize
		for i in range(cols * rows):
			var x = (i % cols) * tilesize
			var y = (i / cols) * tilesize
			var tile
			if has_node(str(i)):
				tile = get_node(str(i))
				remove_child(tile)
			else:
				tile = Sprite.new()
			add_child(tile)
			tile.set_owner(self)
			tile.set_name(str(i))
			tile.set_texture(sheet)
			tile.set_region(true)
			tile.set_region_rect(Rect2(x, y, tilesize, tilesize))
			tile.position = Vector2(x + tilesize / 2, y + tilesize / 2)