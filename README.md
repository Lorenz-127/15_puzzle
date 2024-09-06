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

- Dynamic grid system supporting various puzzle sizes (3x3 to 8x8)
- Main menu with options for play, settings, profile, and tutorial
- In-game menu with move counter, timer, and control buttons
- Settings menu for adjusting puzzle size and other options
- Pause/Resume functionality
- Restart option
- Return to main menu option
- Move counter and timer to track player progress
- Win condition check
- Full image display upon puzzle completion

## Getting Started

1. Ensure you have Godot 4.3 installed on your system.
2. Clone this repository or download the project files.
3. Open the project in Godot Engine.
4. Run the `main.tscn` scene to start the game.

## How to Play

- From the main menu, select "PLAY" to start a new game.
- Click on tiles adjacent to the empty space to move them.
- Rearrange the tiles to recreate the original image.
- Use the in-game menu to pause, restart, or adjust settings.
- The game will inform you when you've won and display the number of moves and time taken.

## Development

This project uses GDScript and is built with Godot's node-based architecture. The main game logic is handled in `main.gd`, while individual tile behavior is managed in `tile.gd`.

To modify the puzzle image, replace `logo_godot.png` in the Assets folder with your desired image (maintaining the 1024x1024 resolution for compatibility).

## Future Improvements

- Implement Challenge Mode with time and move limits
- Develop Expert Mode with complex, pre-designed patterns
- Create a custom game creator with more adjustable parameters
- Add options for custom puzzle images
- Implement accessibility features
- Optimize for mobile platforms
- Add sound effects and background music

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License

- [MIT License](https://github.com/Lorenz-127/15_puzzle?tab=MIT-1-ov-file)

## Acknowledgements

- [Godot Engine](https://godotengine.org/)
