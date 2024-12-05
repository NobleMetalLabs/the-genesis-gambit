class_name GlobalCommandValidators
extends RefCounted

static func debug_return_valid(_value : String) -> bool:
	return true

static func debug_return_invalid(_value : String) -> bool:
	return false

static func is_valid_string(value : String) -> bool:
	assert(value is String)
	return true

static func is_valid_int(value : String) -> bool:
	return value.is_valid_int()

static func is_valid_int_positive(value : String) -> bool:
	if not value.is_valid_int(): return false
	var int_value : int = int(value)
	return int_value >= 0

static func is_valid_float(value : String) -> bool:
	return value.is_valid_float()

static func is_valid_float_positive(value : String) -> bool:
	if not value.is_valid_float(): return false
	var float_value : float = float(value)
	return float_value >= 0

static func is_valid_float_percent(value : String) -> bool:
	if not value.is_valid_float(): return false
	var float_value : float = float(value)
	return float_value >= 0 and float_value <= 1