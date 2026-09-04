class_name NewsEvent extends Resource

var headline: String
var description: String
#this dictionary maps strings representing effect names to floats
#representing their magnitudes. At the moment, each news event has the same three
#effects, but this may change
var effects: Array

func initialise(news_dict: Dictionary = {}) -> void:
	if news_dict.size() <= 0:
		return
	headline = news_dict.get("HEADLINE")
	description = news_dict.get("DESCRIPTION")
	for i in range(1,4):
		var effect = NewsEffect.new()
		effect.name = news_dict.get("EFFECT_%d" % i)
		effect.magnitude = randf_range(float(news_dict.get("EFFECT_%d_MIN_MULT" % i)), float(news_dict.get("EFFECT_%d_MAX_MULT" % i)))
		effect.target = news_dict.get("TARGET_%d" % i)
		effects.append(effect)
	
func get_effect(name: String) -> NewsEffect:
	for effect in effects:
		if effect.name == name:
			return effect
	return null

class NewsEffect extends Resource:
	var name: String
	var target: String
	var magnitude: float
