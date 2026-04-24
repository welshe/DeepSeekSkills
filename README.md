# Dungeon Defenders Recreation in Godot 4.5

This is a faithful recreation of the classic tower defense game Dungeon Defenders, built in Godot 4.5.

## Features Implemented

- **3D Environment**: Basic dungeon map with walls, floor, and navigation mesh for enemy pathing
- **Enemy Pathing**: Enemies use NavigationAgent3D to pathfind towards the crystal
- **Towers**: Basic towers that shoot at enemies in range
- **Player Character**: Controllable hero with WASD movement and attached camera
- **Crystal**: Central objective that takes damage when enemies reach it
- **Wave System**: Press G to start waves, build phases between waves
- **HUD**: Displays current phase, wave number, and crystal health
- **Game Flow**: Main Menu > Tavern > Enemy Map with build/wave cycles

## Project Structure

- `scenes/`: Godot scene files (.tscn)
  - MainMenu.tscn: Start menu
  - Tavern.tscn: Hero selection (simplified)
  - EnemyMap.tscn: Main 3D game level
  - Map.tscn: 3D dungeon map
  - Enemy.tscn: Enemy character
  - Tower.tscn: Tower defense unit
  - Player.tscn: Player character
  - Crystal.tscn: Objective crystal
- `scripts/`: GDScript files
  - MainMenu.gd: Menu logic
  - Tavern.gd: Tavern logic
  - GameManager.gd: Main game logic, state management
  - Enemy.gd: Enemy behavior
  - Tower.gd: Tower behavior
  - Player.gd: Player movement
  - Crystal.gd: Crystal health
- `assets/`: Models, textures, audio (empty for now)
- `project.godot`: Godot project configuration

## How to Run

1. Install Godot 4.5 or later
2. Open the `project.godot` file in the Godot Editor
3. Press F5 or click the Play button

## Controls

- **Main Menu/Tavern**: Click buttons to navigate
- **Enemy Map**:
  - WASD: Move player
  - Left Click: Place tower (during build phase)
  - G: Start wave (during build phase)

## Game Flow

1. **Main Menu**: Click "Start Game"
2. **Tavern**: Select hero (currently just "Apprentice"), click "Enter Map"
3. **Enemy Map**:
   - Initial build phase: Place towers with left click
   - Press G to start wave
   - Enemies spawn and path towards crystal
   - Towers shoot at enemies
   - When all enemies defeated, return to build phase
   - Repeat for increasing waves

## Future Enhancements

To make it more accurate to Dungeon Defenders:

- Add different tower types (archer, mage, etc.)
- Implement hero abilities and upgrades
- Add mana system
- More detailed 3D models and textures
- Sound effects and music
- UI for tower selection and upgrades
- Save/load game state
- Multiple maps and difficulty levels

## Notes

This is a basic prototype capturing the core tower defense mechanics. Dungeon Defenders has many complex systems that would require significant development to fully recreate.
# PeachyOnline
