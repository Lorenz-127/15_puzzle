# Puzzle Game Project

This is a simple puzzle game created with Godot 4.3.
The game involves a sliding tile puzzle where players must rearrange tiles to complete an image.
Inspiration for the puzzle was the classic [15-Puzzle-Game](https://en.wikipedia.org/wiki/15_puzzle)

## Project Structure

The project consists of the following main components:

- `main.gd`: The main game logic script
- `tile.gd`: Script for individual tile behavior
- `main.tscn`: Main scene file
- `tile.tscn`: Tile scene file
- Assets:
  - `logo_godot.png`: The main puzzle image
  - `greytile.png`: Image for the empty tile

## Game Features

- 4x4 grid puzzle
- Randomized tile shuffling at game start
- Move counter to track player progress
- Win condition check
- Full image display upon puzzle completion

## Getting Started

1. Ensure you have Godot 4.3 installed on your system.
2. Clone this repository or download the project files.
3. Open the project in Godot Engine.
4. Run the `main.tscn` scene to start the game.

## How to Play

- Click on tiles adjacent to the empty space to move them.
- Rearrange the tiles to recreate the original image.
- The game will inform you when you've won and display the number of moves taken.

## Development

This project uses GDScript and is built with Godot's node-based architecture. The main game logic is handled in `main.gd`, while individual tile behavior is managed in `tile.gd`.

To modify the puzzle image, replace `logo_godot.png` in the Assets folder with your desired image (maintaining the 1024x1024 resolution for compatibility).

## Future Improvements

- Add difficulty levels (e.g., 3x3, 5x5 grids)
- Implement a timer for speedrun challenges
- Create a menu system for game options and level selection
- Add sound effects and background music

Feel free to contribute to the project or use it as a base for your own puzzle game implementations!
