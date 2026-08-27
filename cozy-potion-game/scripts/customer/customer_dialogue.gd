##A class that handles the creation of dialogue for customers
##It gets passed customers as arguments for its methods
## and returns DialogueResources
## this is a (in actuality) static class and not an autoload
## because it doesn't need state
class_name CustomerDialogue extends Node

##returns a dialogueline that the customer will say when
##meeting the player for the first time
static func get_initial_dialogue(customer: Customer) -> DialogueResource:
	return DialogueManager.create_resource_from_text("~ start\nMan: Hello I am the man")
