# Quick Start Guide

## Your Visual Novel Framework is Ready!

Everything is set up. Here's what you need to do to start making your game:

## Step 1: Test the Framework

Open the project in Godot:
```bash
cd /home/nullveil/code/game
godot project.godot
```

Then press **F5** to run the game and see the example story in action.

## Step 2: Add Your Images

1. Generate images with ComfyUI (aim for 800x600 or similar aspect ratio)
2. Save them as PNG files
3. Drop them into `assets/images/`
4. Name them something memorable like `scene01_introduction.png`

## Step 3: Write Your Story

1. Open `story/chapter1.json`
2. Replace the example entries with your story
3. Reference your images like: `"image": "res://assets/images/scene01_introduction.png"`

### Story Entry Quick Reference

**Show dialogue:**
```json
{
    "type": "dialogue",
    "speaker": "Character Name",
    "text": "What they say",
    "image": "res://assets/images/your_image.png"
}
```

**Give player a choice:**
```json
{
    "type": "choice",
    "text": "What do you do?",
    "choices": ["Option 1", "Option 2", "Option 3"]
}
```

**Change stats:**
```json
{
    "type": "stat_change",
    "stats": {"hp": -10, "strength": 2}
}
```

## Step 4: Customize Your Stats

Edit `scripts/game_manager.gd` around line 4 to change what stats your game tracks:

```gdscript
var player_stats = {
    "name": "Your Character Name",
    "hp": 100,
    "mp": 50,
    # Add or remove stats as needed
}
```

The stats panel will automatically update to show your changes.

## Step 5: Make More Chapters

1. Copy `story/chapter1.json` to `story/chapter2.json`
2. Write your next chapter
3. Add a story entry to load the next chapter:
```json
{
    "type": "dialogue",
    "speaker": "Narrator",
    "text": "End of Chapter 1..."
}
```
4. Modify `game_manager.gd` to load chapter2 when chapter1 ends

## PC-98 Style Tips

For authentic retro aesthetic:
- Use limited color palettes (16-256 colors)
- Add dithering in ComfyUI
- High contrast artwork
- Clean line art
- Anime/manga style

## Controls

- **ENTER or SPACE**: Next dialogue
- **F**: Toggle fullscreen image view
- **Click**: Select choices

## Common Issues

**"Failed to load image"** → Check the file path starts with `res://` and the file exists

**"Failed to parse story file"** → Your JSON has a syntax error, use a JSON validator

**Stats not showing** → Make sure stat names in `stat_change` entries match `player_stats` exactly

## What's Next?

- Add more story chapters
- Create character sprites
- Add background music (put MP3/OGG in `assets/audio/`)
- Implement save/load system
- Build your first minigame
- Customize the UI colors and layout

Check `README.md` for more detailed information!

---

**You're all set! Start creating your visual novel!**
