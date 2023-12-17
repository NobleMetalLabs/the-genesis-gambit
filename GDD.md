# Game Design Document

Revision: 0.0.1

## The Elevator Pitch

Draft Game is a Real Time Strategy, Tabletop Card Game.

## Core Gameplay

Draft Game’s core gameplay involves playing cards out of a deck drafted (semi) at random, and to try and set up large plays to overwhelm the opponent(s).

## Project Scope

- Time
  - 1 Month
- Personnel
  - Adobe
  - Programming
  - Music?
    - Cog
  - Programming
  - Art?

## Influences

- TTCCG’s
  - Draft Game is a TTCCG at its core, with mechanics altered intended to reduce the focus on “collecting”.
- Nertz Online
  - Nertz is a core influence for Draft Game, as its fast-paced nature is novel to the TTCCG genre.
- TIS100 / Molek Syntez
  - Draft Game’s visual style is inspired by these games. The main goal is to have something we can reasonably achieve that doesn’t look half-baked.

## Project Description

Draft Game is a card game that features a twist on deck-building, where instead of building a deck you build a “deck” of pack types from which you draft at the start of every game.

### What sets this project apart?

Most games in the TTCCG genre feature turn-based action. None that I know of have realtime, fast-paced gameplay. 

## Core Mechanics

- Deckbuilding
  - Card Rarities:
    - Common
    - Rare
    - Mythic
    - Epic
      - Epics are odd in that they can be passives or actives
      - If a passive, then a badge is displayed below the player, which when hovered will show the card/effect (but usually with very specific conditions / odd effects)
  - Pack Contents:
    - Epic packs contain 3 cards each, with 1 being chosen
    - Mythic packs contain 5 cards each, with 1 being chosen
    - Rare and Common packs contain 5 cards each, with 2 being chosen
  - Pack Types:
    - Common Packs
      - Small Creatures I
      - Medium Creatures I
      - Large Creatures I
      - Spellslingers I
    - Rare Packs
      - Bugs
      - Small Creatures II
      - Medium Creatures II
      - Large Creatures II
      - Spellslingers II
      - Traps
      - Support
    - Mythic Packs
      - Fishies
      - Apes
      - Warriors
      - Traps II
      - Procs .5
      - Support II
    - Epic Packs
      - Monoliths
      - Horrors
      - Powers
      - Procs
      - Instincts (Passives)
  - Players build their "decks" to contain:
    - 4 Epic Packs
    - 3 Mythic Packs
    - 6 Rare Packs
    - 10 Common Packs
- Game Rules
  - The Draft Period
    - The Draft Period is at the beginning of every match, and is where the players draft their decks.
    - The draft period occurs as follows:
      - Phase 1 (Kickstart):
        - Epic
        - Rare
        - Rare
        - Mythic
        - Epic
      - Phase 2 (Fill):
        - Rare
        - Common
        - Common
        - Common
        - Common
        - Rare
      - Phase 3 (Specialize):
        - Epic
        - Mythic
        - Common
        - Common
        - Rare
      - Phase 4 (Refine):
        - [where instead of receiving the chosen card, you pick a currently possessed card to replace]
        - Epic
        - Common
        - Common
        - Rare
        - Common
        - Common
        - Mythic
  - Playing Cards
    - There are no turns
    - Cards may be played any time their play conditions are satisfied
    - Cards can go anywhere on the playfield
      - Once they are placed, they cannot be moved unless granted by an effect.
  - Summoning Monsters
    - You may only summon a monster any time their play conditions are satisfied
    - Playing a monster results in its Mana cost being taken from your max Mana. The Mana cost is repaid whenever the monster is killed or destroyed.
    - Playing a monster card which results in exceeding your max Mana, you are forced to choose an existing monster to stay under max.
  - Targeting
    - Cards may have effects that require a target
    - For instance, most monsters will attack their target at an interval
    - Cards which require a target can have their target set by Right-Clicking the card in question, and dragging to the target card
    - If a card that requires a target does not have one at the time of its effect activating, it could:
      - Do nothing (likely dying of Boredom)
      - Activate the effect on a randomly chosen target
  - Boredom
    - Any card that does not have an active effect dies of Boredom
    - A card that "procs" on another action does not apply
      - It does have an active effect–being waiting
  - Burning
    - At any time, a player can choose to burn their hand, discarding all cards and redrawing the amount equal to what they discarded
    - After doing so, they are unable to do it again for 1 minute
  - Freezing
    - At any time, a player can choose a card on the playfield to Freeze.
    - A frozen card's active effects will not trigger, but it will not die of Boredom
    - A frozen card will remain frozen for 10 seconds.
    - After doing so, they are unable to do it again for 1 minute
    - If another player freezes an already frozen card, 10 more seconds is added on top of the remaining time.
  - Winning the Game
    - Uhh idk
      - Prolly just deal damage to opp but im open

# Checklist

- [ ] Card Functionality
  - [x] Place Cards
  - [ ] Card Targeting
  - [ ] Card Freezing
- [ ] Hand Functionality
  - [ ] Possess a Hand
  - [ ] Drawing Cards
  - [ ] Playing from Hand
  - [ ] Burning Hand
- [ ] UI
  - [ ] Gamefield Background
  - [ ] Card rarity backgrounds
    - [ ] Full size
    - [ ] Mini size
  - [x] Inspect Cards
  - [ ] Draft Stage
    - [ ] Opening a pack into a set of cards
    - [ ] Picking a card
    - [ ] Adding to deck
    - [ ] Replacing existing card in deck
- [ ] Card Functionality Functionality
  - [x] Arbitrarily define card functionality
  - [ ] Provide Card Functionality Utilities
  - (an easy way [hopefully ~1-2 method calls] to do the following)
    - [ ] Cards that wait for a proc
    - [ ] Cards with Charges
    - [ ] Cards with AOE
    - [ ] Cards that increase Stats (both self and others)
    - [ ] Cards that Spawn other Cards
    - [ ] Handling Boredom
- [ ] Multiplayer
  - [ ] V1: RPC
    - [ ] . . .
  - [ ] V2: Rollback
    - [ ] . . .
