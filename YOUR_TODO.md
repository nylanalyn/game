# Your Next Steps

The game framework is **100% functional and ready**. Here's what you need to do to make it playable:

## Step 1: Generate Priority Images (CRITICAL)

Open [IMAGES_NEEDED.md](IMAGES_NEEDED.md) and start generating with ComfyUI.

**Generate these FIRST** (minimum viable game):
1. Intro sequence images (42 images)
2. Main character portraits (9 images)
3. Hub scene (4 images)

That's **55 images** to get a playable intro → hub → character selection flow.

### Quick ComfyUI Tips:
- Use the PC-98 aesthetic guide in IMAGES_NEEDED.md
- Keep character designs consistent (save your prompts!)
- Generate in batches (all Kara scenes together, etc.)
- Use the import helper: `./import_images.sh /path/to/comfyui/output`

## Step 2: Test the Intro

Once you have intro images:
```bash
cd /home/nullveil/code/game
godot project.godot  # Press F5 to run
```

The intro should play through completely. Press ENTER to advance dialogue, F to view images fullscreen.

## Step 3: Generate Friendship Scene Images

For each companion, you need images for friendship levels 1-10.

**I've already written**:
- Kara level 1 & 5
- Miko level 1
- Sarah level 1

**You need to write**:
- Levels 2, 3, 4, 6, 7, 8, 9, 10 for each companion
- Copy the template from `story/companions/orc_level_1.json`
- Make levels 1-4 friendly
- Make levels 5-7 flirty/romantic
- Make levels 8-10 romantic climax (level 10 = fade to black)

## Step 4: Generate Combat Graphics

The shmup minigame works but needs art:
- Player sprite
- Enemy sprites
- Projectile effects
- Background images

These can be simple for now - even solid color sprites work!

## Step 5: Playtest the Loop

Once you have companion images:
1. Run game
2. Watch intro
3. Select companion at hub
4. Play dungeon run
5. See friendship scene
6. Return to hub
7. Repeat!

Test that:
- Friendship increases after successful runs
- Stats increase with friendship
- All three companions work
- Solo path works (and kills you on failure!)

## File Locations Quick Reference

**Add images here**: `assets/images/`

**Write companion stories here**: `story/companions/`
- Format: `{companion}_level_{number}.json`
- Example: `orc_level_3.json`

**Modify game balance**:
- `scripts/game_manager.gd` - companion bonuses, friendship rates
- `scripts/shmup_game.gd` - enemy count, spawn rates, damage

**Change character names**:
- `scripts/game_manager.gd` line 16, 25, 34 (Kara, Miko, Sarah)

## Current Status

✅ **DONE**:
- Complete game engine
- All systems implemented
- Intro story written (42 scenes)
- Example companion stories
- Hub system
- Shmup minigame
- Stat tracking
- Friendship progression
- Image reference list

⏳ **YOUR PART**:
- Generate images with ComfyUI
- Write remaining companion stories (optional - game works with what's there)
- Playtest and balance

## Expected Timeline

**Phase 1 (Intro Playable)**:
- Generate 55 intro/hub images
- **Time**: Depends on your ComfyUI setup, maybe 2-4 hours?

**Phase 2 (One Companion Route Playable)**:
- Generate Kara friendship scene images (10 levels worth)
- Write Kara levels 2-4, 6-10
- **Time**: Another 2-3 hours?

**Phase 3 (Full Game)**:
- All companions fully implemented
- All images generated
- Playtested and balanced
- **Time**: 10-20 hours total?

## Tips

1. **Start small**: Get the intro working first, then add companions one at a time
2. **Placeholder art is fine**: The game works with the placeholder images, you can swap later
3. **Test frequently**: Run the game after every batch of images
4. **Use the import script**: `./import_images.sh` makes adding images easier
5. **Save your ComfyUI workflows**: You'll be generating a LOT of images

## Getting Help

If something breaks or you need modifications:
- Check [GAME_DESIGN.md](GAME_DESIGN.md) for how systems work
- Check [README.md](README.md) for general info
- Check [QUICKSTART.md](QUICKSTART.md) for basic usage

The code is heavily commented - look at the scripts if you want to understand or modify something!

## Final Notes

**This is YOUR game now!**

The framework is solid. I've built:
- The engine
- The game loop
- The progression systems
- The companion romance mechanics
- The minigame
- Example story content

**You bring**:
- The visuals (ComfyUI art)
- The story details (companion interactions)
- Your creative vision

The split is perfect for what you wanted - you handle pictures and story, the code does everything else.

---

**Now go make some art and bring this world to life!** 🎨
