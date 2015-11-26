Making a survival craft game about building a factory.

You build robots that do stuff for you, like mining ores, and trying to optimize them so they do more stuff for you.

You can follow development on livecoding.tv : https://www.livecoding.tv/blue112/

# Done:

- Make some mining engine (ME) (1 tile x 1 tile)
- Make the ME put item in front of it, it there's no other item in front of it, otherwise, stop working
- Change the direction of which it places the item (rotate ME)
- Belt conveyors
- Add map layers
- Add drop shadow to floor items
- Rotate a building while placing it
- Map save
- Chests
- Automatic inventory view refresh when model changes
- Save chest inventory
- Get item in chest
- Oven (Iron + Coal => Iron Bars)
- Add a GUI window to the oven
- Be able to move windows with drag'n'drop
- [BUG] Opening the craft window when the inventory is opened prevents from closing both
- Deconstruct buildings
- Add back the floating message when the player's inventory changes
- Rotative item mover (RIM)
- Allow player to build multiple items at once
- Integrate a nicer character
- Add stone ressource to make oven
- Smelt stone to make bricks
- Add variations of the tiles for stone, iron and coal switch between them at random
- Make Mining Engines work using Coal
- Add the "no fuel" icon to oven that have no coal
- Cleanup SVG
- Crafting machines (input components => output result)
- Save assigned recipes from Crafting machines
- Save coal slot in the AME
- Collisions (stone, buildings)
- Item launcher (strong RIM) => Push item further than one tile (two tiles)
- Ability to add multiple coal into AME
- Handle deconstructing building doesn't preserve inventories and slots
- Do not draw tiles outside the map boundaries
- [BONUS] Make conveyor belts move item "visibly slowly"
- [BONUS] Change ItemOnFloor class name to FloorItem

# Todo

- Make remote save system
- Implements enemies
- [BONUS] Look for focus lost to stop mining
- Add nice graphics (help needed)
- Create a nice game
