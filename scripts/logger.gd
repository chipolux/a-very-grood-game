extends Node

var LEVEL_ERROR = 0
var LEVEL_INFO = 1
var LEVEL_DEBUG = 3
var LOG_LEVEL = LEVEL_DEBUG


func error(msg):
	if LOG_LEVEL >= LEVEL_ERROR:
		_print_log("ERROR", msg)

func info(msg):
	if LOG_LEVEL >= LEVEL_INFO:
		_print_log(" INFO", msg)

func debug(msg):
	if LOG_LEVEL >= LEVEL_DEBUG:
		_print_log("DEBUG", msg)

func _print_log(level, msg):
	print("%010d %s: %s" % [OS.get_ticks_msec(), level, msg])

func _get_timestamp():
	# returns an ISO 8601 UTC timestamp
	var now = OS.get_datetime(true)
	return "%d-%02d-%02dT%02d:%02d:%02dZ" % [
		now['year'], now['month'], now['day'],
		now['hour'], now['minute'], now['second']
	]
