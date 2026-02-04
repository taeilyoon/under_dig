# Under Dig - Project Documentation

## 1. Project Overview
**Title**: Under Dig  
**Engine**: Flutter + Flame  
**Genre**: Vertical Digging / Survival / Puzzle Strategy  
**Goal**: Dig downwards, survive enemy waves, and collect loot.

## 2. Core Architecture

### Grid System (`lib/systems/grid_system.dart`)
- **Size**: 8 Columns x 10 Rows (Logic: `GridSystem.cols`, `GridSystem.rows`).
- **Tile Size**: Derived from screen width (responsive).
- **Coordinates**: Logical `(gridX, gridY)` mapped to World `Vector2` positions via `gridToWorld()`.

### Entity Hierarchy
All interactive objects inherit from `GridEntity` to ensure unified positioning logic.

1.  **`GridEntity`** (`PositionComponent`):
    -   Base class. Manages `gridX`, `gridY` and visual position syncing.
2.  **`Destructible`** (Mixin):
    -   Adds HP, MaxHP, and Damage logic (`takeDamage`).
    -   Handles death (removal from parent).
3.  **Concrete Classes**:
    -   **`Player`**: Controlled character. Has HP, AttackPower.
    -   **`Enemy`**: AI entity. Moves down, attacks player.
    -   **`BreakableBlock`**: Static destructible (Crates/Rocks).
    -   **`Chest`**: Loot container (Interactable).

## 3. Game Mechanics

### Turn System (`lib/game.dart`)
- **Step-Based**: Game advances 1 "Step" when:
    -   Player performs an action (Move/Attack).
    -   Timer exceeds **2.0 seconds** (Auto-step).
-   **Step Order**:
    1.  **Enemies Act**: Bottom-most enemies move first to prevent overlapping.
    2.  **Spawning**: New enemy spawns at the top row (if space is available).

### Combat Rules
1.  **Attack**: Player deals `attackPower` (Default: 1) to target.
2.  **Chain Damage (Combo)**:
    -   Hiting an enemy propagates damage to **all connected enemies** of the same type (color).
3.  **Counter-Attack**:
    -   Enemies immediately strike back when attacked.
    -   **Safe Kill**: If the player kills the enemy (HP <= 0), the enemy **does not** counter-attack.
4.  **Enemy AI**:
    -   Moves down 1 tile per Step.
    -   **Blocked**: If the Player or an Object is below, the enemy STOPS (does not attack). This allows "stacking".

## 4. Current Progress
-   [x] Grid Rendering & Player Movement.
-   [x] Turn Logic & Timer.
-   [x] Enemy Spawning (Top) & Vertical Movement (Gravity).
-   [x] Combat Stats (HP/ATK) & UI (HP Text).
-   [x] Chain Damage Logic.
-   [x] Object Refactoring (`GridEntity` parent class).
-   [x] Basic Chest Implementation.

## 5. Next Steps
-   [ ] **Game Over Condition**: End game when Player HP <= 0.
-   [ ] **Game Clear / Depth**: Track depth or difficulty progression.
-   [ ] **Items/Inventory**: Loot from chests (Potions, Weapon Upgrades).
-   [ ] **New Enemy Types**: Ranged enemies, fast enemies, etc.
