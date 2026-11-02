class_name CustomerDialogue 
extends Node
## A class that handles the creation of dialogue for customers
## It gets passed customers as arguments for its methods
## and returns DialogueResources
## this is a (in actuality) static class and not an autoload
## because it doesn't need state

const MATCHING_CUSTOMER_TYPE_WEIGHT = 7
const POTION_REQUEST_LINES_JSON: String = "res://resources/json/potion_request_lines.json"

static var potion_request_lines: Array[PotionRequestLine]

## The one other classes call.
static func get_potion_request_line(attribute: Alchemy.AttributeID, customer: Customer.CustomerID) -> DialogueResource:
	print_debug("potion_request_lines:",potion_request_lines)
	
	if not potion_request_lines:
		populate_potion_request_lines()
	
	if not attribute or not customer:
		DialogueManager.create_resource_from_text("~ start\n %s" % potion_request_lines.pick_random().text)

	
	var shortlist = get_shortlist(attribute, customer)
	
	var text = shortlist.pick_random().text
	return DialogueManager.create_resource_from_text("~ start\n %s" % text)
	
static func get_shortlist(attribute: Alchemy.AttributeID, customer: Customer.CustomerID) -> Array[PotionRequestLine]:
	var res: Array[PotionRequestLine]
	for element in potion_request_lines:
		if element.attribute == attribute:
			res.append(element)
			# print_debug("short_list:\n - element.attribute %s\n - element.customer %s\n - element.text %s" % [element.attribute, element.customer, element.text])

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
		var request_line: PotionRequestLine = PotionRequestLine.new()
		request_line.attribute = Alchemy.AttributeID.keys().find(element["ATTR"])
		request_line.customer = Customer.CustomerID.keys().find(element["NPC"])
		request_line.text = element["PROBLEM"]

		if request_line.text == "":
			request_line.text = element["REQUEST"]

		if (request_line.attribute != Alchemy.AttributeID.ATTR_NULL_ATTR) and request_line.customer and request_line.text:
			potion_request_lines.append(request_line)

		else:
			var response = "%s : %s : %s" % [str(bool(request_line.attribute)), str(bool(request_line.customer)), str(request_line.text.is_empty())]
			response += "\nrequest_line:\n - request_line.attribute %s\n - request_line.customer %s\n - request_line.text %s\n" % [Alchemy.AttributeID.keys()[request_line.attribute], request_line.customer, request_line.text]
			print_debug(response)


	

## A tuple, a tuple, my life for a tuple
## I get that -H
class PotionRequestLine extends Resource:
	var attribute: Alchemy.AttributeID = -1 as Alchemy.AttributeID
	var customer: Customer.CustomerID
	var text: String
