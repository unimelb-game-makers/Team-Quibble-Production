The player will spawn wherever the player prefab is in the scene, unless
there is a portal in the scene and the portal static var spawn_at_portal is true,
in which case they will spawn at the portal.

There are four foliagemanagers, one for each quadrant. each has an array of
markers which are positions where foliage will spawn, and an array of
foliages that will spawn on those markers. 

ignore decorative foliages for now

each marker is placed far above the forest, but casts a ray down to determine the spawn point
on the ground
