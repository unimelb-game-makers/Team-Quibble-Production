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
	if potion_request_lines.is_empty():
		populate_potion_request_lines()

	var shortlist = get_shortlist(attribute, customer)

	if shortlist.is_empty():
		push_warning("No dialogue found for attribute: %s" % attribute)
		return DialogueManager.create_resource_from_text(
			"~ start\nI'm looking for a potion."
		)

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
	potion_request_lines.clear()

	var json_data = Utils.get_json(POTION_REQUEST_LINES_JSON)

	for element in json_data.data:
		var attribute_id = Alchemy.AttributeID.keys().find(element["ATTR"])
		if attribute_id < 0 or attribute_id == Alchemy.AttributeID.ATTR_NULL_ATTR:
			continue

		var npc_name: String = element["NPC"]
		var customer_id: int = -1

		if npc_name != "GENERIC":
			customer_id = Customer.CustomerID.keys().find("NPC_" + npc_name)
			if customer_id < 0:
				continue

		var line_text: String = element["PROBLEM"]
		if line_text.is_empty():
			line_text = element["REQUEST"]

		if line_text.is_empty():
			continue

		var request_line = PotionRequestLine.new()
		request_line.attribute = attribute_id
		request_line.customer = customer_id as Customer.CustomerID
		request_line.text = line_text

		potion_request_lines.append(request_line)


	

## A tuple, a tuple, my life for a tuple
## I get that -H
class PotionRequestLine extends Resource:
	var attribute: Alchemy.AttributeID = -1 as Alchemy.AttributeID
	var customer: Customer.CustomerID
	var text: String
