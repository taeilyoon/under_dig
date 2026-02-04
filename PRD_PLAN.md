# Under Dig - Product Requirement Document (Part 1: Plan)

## 1. Product Overview
**App Name**: Under Dig  
**Platform**: Andorid / iOS (Flutter)  
**Genre**: Vertical Survival Puzzle / Roguelite  
**Core Concept**: "Dig or Die". A tense, turn-based survival game where the player must descend an infinite vertical shaft while managing space, enemies, and HP.

## 2. Target Audience
-   **Primary**: Mobile gamers who enjoy puzzle-strategy (e.g., *Hoplite*, *Downwell*).
-   **Secondary**: Roguelike fans looking for "pocket-sized" runs (3-5 mins).
-   **Motivation**: High stakes, quick decision making, and satisfying combo executions.

## 3. Core Gameplay Loop
1.  **Descend**: Move down the 8x10 grid to escape the crushing ceiling (future feature) or enemy hordes.
2.  **Survive**: Use strategic positioning to block, attack, or combo enemies.
3.  **Loot**: Open chests for upgrades (HP, ATK, Skills).
4.  **Die & Repeat**: Roguelite progression means death is frequent but rewarding (meta-progression).

## 4. Feature Requirements

### Phase 1: MVP (Completed/In-Progress)
-   [x] **Grid System**: Responsive 8x10 grid.
-   [x] **Turn System**: Hybrid (Player Move or 2s Timer).
-   [x] **Basic Combat**: Attack, Counter-Attack, Safe Kill.
-   [x] **Enemy AI**: Vertical movement (Gravity), Blocking logic.
-   [x] **Chain Combo**: Linked enemies die together.
-   [x] **Objects**: Chests, Breakable Blocks.

### Phase 2: Alpha (Next Steps)
-   [ ] **Game Over Loop**: Player Death -> Result Screen -> Restart.
-   [ ] **Scoring System**: Depth reached, Enemies killed, Max Combo.
-   [ ] **Level Progression**: Difficulty curve (Spawn rate increases with depth).
-   [ ] **Item System**: Chests dropping usable items (Potions, Scrolls).

### Phase 3: Beta (Polish & Depth)
-   [ ] **New Enemies**: Ranged (Archer), Fast (Slime), Tank (Golem).
-   [ ] **Skills/Upgrades**: "Action" cards or localized skills (e.g., Push, Stun).
-   [ ] **Visual Polish**: Animations for Moving, Attacking, Dying, Chain Explosions.
-   [ ] **Audio**: BGM and SFX.

## 5. Technical Stack
-   **Engine**: Flutter + Flame
-   **State Management**: Built-in Flame Components (Component Tree).
-   **Persistence**: `shared_preferences` (High Score), Hive/Isar (Run History).

## 6. Success Metrics (KPIs)
-   **Session Length**: Average > 5 mins.
-   **Retention**: D1 > 35%.
-   **Combo Satisfaction**: Players effectively using Chain mechanics (tracked via analytics).

## 7. Roadmap & Priorities
| Priority | Feature | Description |
| :--- | :--- | :--- |
| **P0** | Game Over | Essential loop closure. |
| **P0** | Item System | Meaningful rewards for Chests. |
| **P1** | Scoring | Motivation to replay. |
| **P1** | New Enemies | Variety in gameplay. |
| **P2** | Visual FX | Juice/Polish (Screen shake, particles). |
