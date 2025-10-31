# Game Design Document - Portal Runner

## Overview

A PC-98 inspired visual novel with shmup minigame mechanics, featuring companion romance paths and an overarching world-saving narrative.

## Story Summary

**Opening (1990s)**: College student witnesses explosion, gets pulled into portal by Kara (orc warrior), encounters hostile THINGS from another dimension, instinctively creates barrier that traps them - first time in history they've been stopped.

**Time Skip (3 Years Later)**: Barrier still holds. Humans discovered abilities. Other species came through as refugees. New economy of "dungeon runners" who explore other worlds for magical items. Player operates from Crossroads Inn.

**Endgame**: Max out all companion relationships to unlock final mission - seal the THINGS' homeworld forever.

## Game Loop

```
INTRO (One-time)
    ↓
HUB (Crossroads Inn)
    ↓
SELECT COMPANION or GO SOLO
    ↓
DUNGEON RUN (Shmup Minigame)
    ↓
SUCCESS? → COMPANION INTERACTION (Friendship +1)
FAILURE? → Companion Unavailable (3 rounds) OR Game Over (solo path)
    ↓
Check: All Companions Maxed?
    ├─ NO → Return to HUB
    └─ YES → ENDING SEQUENCE
```

## Companions

### Kara (Orc Warrior)
- **Stat Bonus**: Strength (+5 per friendship level)
- **Combat Effect**: +50% damage in dungeon runs
- **Personality**: Tough exterior, grateful, protective
- **Romance Arc**: Warrior to vulnerable lover

### Miko (Catgirl Rogue)
- **Stat Bonus**: Dexterity (+5 per friendship level)
- **Combat Effect**: +50% attack speed in dungeon runs
- **Personality**: Playful, observant, agile
- **Romance Arc**: Playful to devoted

### Sarah (Human Cleric)
- **Stat Bonus**: Health (+10 per friendship level)
- **Combat Effect**: +30% max HP in dungeon runs
- **Personality**: Kind, protective, caring
- **Romance Arc**: Professional to intimate

### Solo (Magic Path)
- **Stat Bonus**: None (pure player skill)
- **Combat Effect**: +100% damage, -50% HP
- **Risk**: Death = Game Over (no second chances)
- **Unlocks**: World lore instead of romance

## Progression System

### Dungeon Difficulty Scaling

| Runs Completed | Enemies | Spawn Rate | Wave # |
|----------------|---------|------------|--------|
| 0-1            | 10      | 2.0s       | 1-2    |
| 2-3            | 10      | 1.5s       | 3-4    |
| 4              | 20      | 1.2s       | 5      |
| 5+             | 20+(n*5)| 0.5s min   | 6+     |

### Friendship Progression

**Level 1-2**: Friendly interactions, learning backstory
**Level 3-4**: Deeper conversations, trust building
**Level 5-7**: Romantic tension, flirty dialogue
**Level 8-9**: Confession moments, emotional peaks
**Level 10**: Romance culmination (fade to black)

Each level unlocks:
- New story segment
- Permanent stat bonus
- Character development

## Combat System (Shmup)

### Player Abilities
- **Movement**: Arrow keys (speed scales with DEX)
- **Attack**: Space/Enter (speed scales with DEX, damage with STR)
- **Health**: Based on Health stat (modified by companion)

### Enemy Behavior
- Spawn at top of screen
- Move toward player (bottom)
- Deal damage on contact
- Health: 30 HP base
- Escape if they reach bottom (no penalty, just missed kill)

### Win/Loss Conditions
- **Win**: Defeat all enemies
- **Loss**: Health reaches 0
- **Success**: Return to hub, friendship +1
- **Failure**: Companion unavailable, return to hub (or game over if solo)

## File Structure for Story Content

### Story Files Location
```
story/
├── intro.json                    # Opening sequence (one-time)
├── hub.json                      # Inn/companion selection
├── ending.json                   # Victory ending
└── companions/
    ├── orc_level_1.json          # Kara friendship 1
    ├── orc_level_2.json          # Kara friendship 2
    ├── ...
    ├── orc_level_10.json         # Kara romance climax
    ├── catgirl_level_1.json      # Miko friendship 1
    ├── ...
    ├── human_level_1.json        # Sarah friendship 1
    └── ...
```

### Story JSON Format

```json
[
  {
    "type": "dialogue",
    "speaker": "Character Name",
    "text": "What they say",
    "image": "res://assets/images/scene.png"
  },
  {
    "type": "choice",
    "text": "Make a choice?",
    "choices": ["Option 1", "Option 2"]
  }
]
```

## Stat Explanations

### Player Stats
- **Health**: Survivability in combat, modified by Sarah
- **Strength**: Damage output, modified by Kara
- **Dexterity**: Attack speed + movement speed, modified by Miko
- **Magic**: Affects solo path power (future expansion)
- **Level**: Tracks overall progression

### Companion Stats
- **Friendship**: 0-10, one point per successful run
- **Available**: Can they be selected? (false if recently failed)
- **Story Unlocked**: Highest friendship scene shown

## Expansion Ideas (Future)

### Additional Companions
- Secret 4th companion unlocked after beating all three paths
- Male romance options
- Non-binary options

### Advanced Features
- **Save/Load System**: Track multiple playthroughs
- **New Game+**: Keep stats, new challenges
- **Alternative Minigames**:
  - Card battle for tavern scenes
  - Puzzle mini-dungeons
  - Boss fights with unique mechanics
- **Crafting System**: Use dungeon loot to craft items
- **Multiple Endings**: Different epilogues per companion
- **Gallery Mode**: Replay scenes, view unlocked art

### Story Expansions
- Rival dungeon runners
- Companion backstory dungeons
- Political intrigue (inter-species relations)
- THINGS origin story (solo path deep lore)

## Current Implementation Status

✅ **Complete**:
- Core game manager with stats, companions, phases
- Intro story sequence (42 scenes)
- Hub system with companion selection
- Friendship progression system
- Basic shmup minigame
- Companion story files (levels 1 and 5 for all three)
- Stat tracking UI
- Image reference list for generation

🔨 **Need Images**:
- All scenes currently reference placeholder images
- See IMAGES_NEEDED.md for complete list
- Priority: Intro sequence (get game playable first)

📝 **Need Writing**:
- Companion levels 2, 3, 4, 6, 7, 8, 9, 10 (27 files per companion = 81 total)
- Ending sequence
- Solo path world lore interactions
- Additional hub dialogue variations

🎮 **Polish Needed**:
- Shmup needs proper sprites (currently colored circles)
- Enemy collision shapes need to be defined
- Player/projectile sprites need art
- Sound effects and music
- Visual effects (hit flashes, explosions, etc.)
- Proper collision detection (currently basic)

## How to Add Content

### Adding a New Friendship Scene

1. Create file: `story/companions/{companion_id}_level_{N}.json`
2. Write dialogue using template format
3. Reference images you'll generate
4. Game automatically loads when friendship increases

### Adding More Enemies

1. Modify `setup_wave()` in [scripts/shmup_game.gd](scripts/shmup_game.gd)
2. Adjust `enemies_remaining` and `spawn_interval`
3. Can add different enemy types with new scenes

### Modifying Companion Bonuses

Edit [scripts/game_manager.gd:14-43](scripts/game_manager.gd#L14-L43):
- Change `stat_bonus` to affect different stat
- Modify `bonus_per_level` for balance
- Adjust combat bonuses in [scripts/shmup_game.gd:33-50](scripts/shmup_game.gd#L33-L50)

## Testing Checklist

- [ ] Intro plays through completely
- [ ] Hub presents companion choices
- [ ] Each companion selection works
- [ ] Solo path works
- [ ] Dungeon minigame is playable
- [ ] Victory returns to hub and increases friendship
- [ ] Failure makes companion unavailable
- [ ] Solo path death = game over
- [ ] Stats update correctly
- [ ] Friendship scenes trigger at right levels
- [ ] All 3 companions can reach level 10
- [ ] Ending triggers when all maxed

## Balance Notes

**Current balance is placeholder!** Adjust these based on playtesting:

- Enemy health (currently 30)
- Player base damage (currently 10 + STR/2)
- Spawn rates
- Companion bonuses (currently +50% for Kara/Miko, +30% for Sarah)
- Friendship gain rate (currently 1 per successful run = 10 runs per companion)

Total runs needed: **30 successful runs minimum** (10 per companion)

Consider: Should friendship increase by 2 on later runs? Should there be friendship decay?

---

**Start by generating the intro images, then test the intro sequence!**
