# Visual Novel Game - PC-98 Style

A classic Japanese visual novel engine built in Godot 4.5, featuring the retro PC-98 aesthetic with modern resolution.

## Features

- 1920x1080 resolution with classic PC-98 inspired layout
- Text box at the bottom for dialogue
- Stats panel on the left side
- Picture frame in the center (with fullscreen toggle)
- JSON-based story scripting
- Choice system for branching narratives
- Dynamic stat tracking and modification
- Easy integration with ComfyUI generated images

## Controls

- **ENTER / SPACE**: Advance dialogue
- **F**: Toggle fullscreen view of current image
- **Mouse**: Click choices when presented

## Project Structure

```
game/
├── scenes/          # Godot scene files
│   └── main.tscn   # Main game scene
├── scripts/         # GDScript files
│   ├── game_manager.gd  # Core game logic
│   └── main_ui.gd       # UI controller
├── assets/          # Game assets
│   ├── images/      # Your ComfyUI generated images go here
│   ├── fonts/       # Custom fonts (optional)
│   └── audio/       # Sound effects and music
└── story/           # Story data files
    └── chapter1.json
```

## How to Add Your Content

### 1. Adding Images

Place your ComfyUI generated images in `assets/images/`. Supported formats:
- PNG (recommended for pixel art)
- JPG
- WebP

Reference them in your story files like: `"image": "res://assets/images/your_image.png"`

### 2. Writing Your Story

Edit `story/chapter1.json` or create new JSON files. The story format is simple:

#### Dialogue Entry
```json
{
    "type": "dialogue",
    "speaker": "Character Name",
    "text": "What the character says...",
    "image": "res://assets/images/scene1.png"
}
```

#### Choice Entry
```json
{
    "type": "choice",
    "speaker": "Narrator",
    "text": "What do you do?",
    "choices": [
        "Option 1",
        "Option 2",
        "Option 3"
    ]
}
```

#### Stat Change Entry
```json
{
    "type": "stat_change",
    "stats": {
        "hp": 10,
        "mp": -5,
        "strength": 2
    }
}
```

### 3. Customizing Stats

Edit the `player_stats` dictionary in `scripts/game_manager.gd` to add or modify stats:

```gdscript
var player_stats = {
    "name": "Player",
    "hp": 100,
    "mp": 50,
    "level": 1,
    "strength": 10,
    "magic": 10,
    "defense": 10,
    # Add your own stats here!
}
```

## Running the Game

1. Open Godot 4.5
2. Click "Import" and select this directory
3. Press F5 to run the game

Or from command line:
```bash
godot --path /home/nullveil/code/game
```

## ComfyUI Workflow Tips

For that PC-98 aesthetic, consider these parameters in ComfyUI:
- Limited color palette (16-256 colors)
- Dithering effects
- Lower resolution upscaled (for authentic pixelation)
- High contrast lighting
- Anime/manga style checkpoints

Export your images at 800x600 or 1024x768 for best results in the picture frame.

## Customization Ideas

### Visual Styling
- Edit colors in `scenes/main.tscn` to match your aesthetic
- Add custom fonts by importing TTF files to `assets/fonts/`
- Modify panel backgrounds and borders for more PC-98 authenticity

### Gameplay Systems
- Add inventory system in `game_manager.gd`
- Implement save/load functionality
- Create minigame scenes and link them from story entries
- Add sound effects on dialogue advance

### UI Enhancements
- Animated text reveal (typewriter effect)
- Character portraits with expressions
- Background music system
- Screen transition effects

## Next Steps for Minigames

To add minigames:
1. Create a new scene in `scenes/minigames/`
2. Add a "minigame" type to story JSON
3. Handle scene switching in `game_manager.gd`
4. Return to main UI when minigame completes

Example minigame types to implement:
- Card games (poker, blackjack)
- Simple combat system
- Puzzle games
- Quick-time events
- Resource management

## Troubleshooting

**Images not loading?**
- Check file path starts with `res://`
- Verify image is in `assets/images/`
- Make sure file extension matches actual format

**Story not advancing?**
- Check JSON syntax (use a JSON validator)
- Verify story file path in `game_manager.gd`
- Look for errors in Godot's output console

**Stats not updating?**
- Ensure stat names match exactly (case-sensitive)
- Check `game_manager.gd` has the stat defined

## License

This is your project! Do whatever you want with it.

---

**Have fun creating your visual novel!**
