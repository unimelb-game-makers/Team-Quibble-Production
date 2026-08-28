##A class that handles the creation of dialogue for customers
##It gets passed customers as arguments for its methods
## and returns DialogueResources
## this is a (in actuality) static class and not an autoload
## because it doesn't need state
class_name CustomerDialogue extends Node

##returns a dialogueline that the customer will say when
##meeting the player for the first time
static func get_initial_dialogue(customer: Customer) -> DialogueResource:
	var res: String = "Hello, I am a [%s]. Please help me, I have [%s]." % \
	[customer.customer_type, customer.primary_need]
	var i := 1
	while i < customer.needs.size():
		res += " I also have [%s]." % customer.needs[i]
		i += 1
	res += " If I had to rate how bad my [%s] is from 1 to 100... I would say [[%f]]" % \
	[customer.primary_need, customer.need_severities.front()]
	return DialogueManager.create_resource_from_text("~ start\nMan: %s" % res)
