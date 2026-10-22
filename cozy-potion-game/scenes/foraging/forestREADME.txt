If the player spawns in the forest from a portal, they will spawn at the
portal in the forest, currently in the cave.

foliage is spawned by foliage managers, one for each type of foliage

foliage is spawned on markers that are children of these managers, 
or more precisely on the position of the ground underneath the markers

You can change the spawn location or the player and the weight
of certain items in the FOrestSceneModifications autoload

items picked up during foraging will go in the bag which can be viewed
with a button at thebotto of the screen, and will go to the pantry
autoload when the foraging bag exits the tree

the dithering so we dont obscure the player is a material setting,
so if you want to change it you have to go throuugh all 12 or so of 
the materials used in the forest and change the Distance Fade parameters
for each
