##A class that handles the creation of dialogue for customers
##It gets passed customers as arguments for its methods
## and returns DialogueResources
## this is a (in actuality) static class and not an autoload
## because it doesn't need state
class_name CustomerDialogue extends Node

static var potion_request_lines: Array[PotionRequestLine]


const MATCHING_CUSTOMER_TYPE_WEIGHT = 7
const POTION_REQUEST_LINES_JSON: String = "res://resources/json/potion_request_lines.json"

## The one other classes call.
static func get_potion_request_line(attribute: Alchemy.AttributeID, customer: Customer.CustomerID) -> DialogueResource:
	if not potion_request_lines:
		populate_potion_request_lines()
	
	var shortlist = get_shortlist(attribute, customer)
	
	var text = shortlist.pick_random().text
	return DialogueManager.create_resource_from_text("~ start\n %s" % text)
	
static func get_shortlist(attribute: Alchemy.AttributeID, customer: Customer.CustomerID) -> Array[PotionRequestLine]:
	var res: Array[PotionRequestLine]
	for element in potion_request_lines:
		print_debug(element.attribute, attribute)
		if element.attribute == attribute:
			res.append(element)
			if element.customer == customer:
				for i in range(MATCHING_CUSTOMER_TYPE_WEIGHT):
					res.append(element)
	return res

static func get_initial_dialogue(customer: Customer) -> DialogueResource:
	var res: String = "Hello, I am a [%s]. Please help me, I have [%s]." % \
	[customer.customer_id, customer.primary_need]
	var i := 1
	while i < customer.needs.size():
		res += " I also have [%s]." % customer.needs[i]
		i += 1
	res += " If I had to rate how bad my [%s] is from 1 to 100... I would say [[%f]]" % \
	[customer.primary_need, customer.need_severities.front()]
	return DialogueManager.create_resource_from_text("~ start\nMan: %s" % res)


static func populate_potion_request_lines() -> void:
	var json_data = Utils.get_json(POTION_REQUEST_LINES_JSON)
	
	for element in json_data.data:
		print_debug(element["ATTR"])
		var request_line: PotionRequestLine = PotionRequestLine.new()
		request_line.attribute = Alchemy.AttributeID.keys().find(element["ATTR"])
		request_line.customer = Customer.CustomerID.keys().find(element["NPC"])
		request_line.text = element["PROBLEM"]
		if request_line.attribute and request_line.customer and request_line.text:
			potion_request_lines.append(request_line)
	
## A tuple, a tuple, my life for a tuple
class PotionRequestLine extends Resource:
	var attribute: Alchemy.AttributeID
	var customer: Customer.CustomerID
	var text: String
