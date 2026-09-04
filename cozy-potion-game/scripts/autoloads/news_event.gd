class_name NewsEvent extends Resource

var headline: String
var description: String
#this dictionary maps strings representing effect names to floats
#representing their magnitudes. At the moment, each news event has the same three
#effects, but this may change
var effects: Dictionary[String, float]
var targets: Array[String]

func initialise(news_dict: Dictionary = {}) -> void:
	if news_dict.size() <= 0:
		return
	headline = news_dict.get("HEADLINE")
	description = news_dict.get("DESCRIPTION")
	for i in range(1,4):
		print_debug("EFFECT_%d_MIN_MULT" % i)
		print_debug(news_dict.get("EFFECT_%d_MIN_MULT" % i))
		effects[news_dict.get("EFFECT_%d" % i)] = \
		randf_range(float(news_dict.get("EFFECT_%d_MIN_MULT" % i)), float(news_dict.get("EFFECT_%d_MAX_MULT" % i)))
		targets.append(news_dict.get("TARGET_%d" % i))
	
func get_effect(key: String) -> Variant:
	return effects.get(key)
