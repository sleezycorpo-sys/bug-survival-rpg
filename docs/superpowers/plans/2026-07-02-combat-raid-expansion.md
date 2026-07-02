# Combat / Raid Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB‑SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task‑by‑task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a full combat system for raids, including enemy AI, damage handling, and reward scaling.

**Architecture:**
- Extend the existing `RaidManager` to spawn enemy bugs with health and attack values.
- Introduce a new `CombatSystem.server.lua` that resolves attacks between player bugs and raid enemies.
- Update the HUD to display enemy health and a combat log.
- Keep all new code in the `src/Raids` and `src/Combat` directories, preserving the server/client split.

**Tech Stack:** Roblox Lua (Luau), Rojo, TestEZ, rbxmk for testing.

## Global Constraints
- All server‑side logic must reside under `ServerScriptService` (i.e., files ending in `.server.lua`).
- Client‑side UI must be under `StarterPlayer` and use `.client.lua`.
- Tests must be placed under `src/**/test.lua` and run via `rbxmk.exe test`.
- Use the existing `Player` table shape: `{UserId, Resources, NestLevel, OwnedSkins}`; extend with `Health` and `Attack` as needed.
- Follow the repository's line‑ending policy (CRLF) and commit each task separately.

---

### Task 1: Define Enemy Data Structure

**Files:**
- Create: `src/Raids/EnemyData.server.lua`
- Create: `src/Raids/EnemyData.test.lua`

**Interfaces:**
- Consumes: None (stand‑alone data definition).
- Produces: `EnemyData.New(typeName)` returns a table `{Type, Health, Attack}`.

- [ ] **Step 1: Write the failing test**

```lua
return function()
    local EnemyData = require(script.Parent.EnemyData)
    local enemy = EnemyData.New("Spider")
    expect(enemy.Type).to.equal("Spider")
    expect(enemy.Health).to.be.a("number")
    expect(enemy.Attack).to.be.a("number")
end
```

- [ ] **Step 2: Run test to verify it fails**

```bash
rbxmk.exe test src/Raids/EnemyData.test.lua -v
```
Expected: error because `EnemyData` module does not exist.

- [ ] **Step 3: Write minimal implementation**

```lua
local EnemyData = {}
EnemyData.__index = EnemyData

local ENEMY_STATS = {
    Ant = {Health = 30, Attack = 5},
    Bee = {Health = 40, Attack = 7},
    Spider = {Health = 50, Attack = 10},
    Beetle = {Health = 60, Attack = 12},
    Dragonfly = {Health = 80, Attack = 15},
}

function EnemyData.New(typeName)
    local stats = ENEMY_STATS[typeName] or {Health = 30, Attack = 5}
    return {Type = typeName, Health = stats.Health, Attack = stats.Attack}
end

return EnemyData
```

- [ ] **Step 4: Run test to verify it passes**

```bash
rbxmk.exe test src/Raids/EnemyData.test.lua -v
```
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add src/Raids/EnemyData.server.lua src/Raids/EnemyData.test.lua
git commit -m "feat: enemy data definition for raids"
```

---

### Task 2: Extend RaidManager to Spawn Enemies

**Files:**
- Modify: `src/Raids/RaidManager.server.lua`
- Create: `src/Raids/RaidManager.test.lua`

**Interfaces:**
- Consumes: `EnemyData.New`
- Produces: `RaidManager.StartRaid(player, raidName, enemyCount)` – now creates `enemyCount` enemies and stores them in `RaidManager.ActiveRaids[raidName].Enemies`.

- [ ] **Step 1: Write failing test**

```lua
return function()
    local RaidMgr = require(script.Parent.RaidManager)
    local EnemyData = require(script.Parent.EnemyData)
    local player = {UserId = 1, Resources = 0}
    RaidMgr.StartRaid(player, "PicnicBasket", 3)
    local raid = RaidMgr.ActiveRaids["PicnicBasket"]
    expect(#raid.Enemies).to.equal(3)
    expect(raid.Enemies[1].Type).to.be.a("string")
    expect(raid.Enemies[1].Health).to.be.a("number")
end
```

- [ ] **Step 2: Run test – expect failure**

```bash
rbxmk.exe test src/Raids/RaidManager.test.lua -v
```

- [ ] **Step 3: Implement minimal changes**

```lua
local RaidManager = {}
RaidManager.ActiveRaids = {}
local EnemyData = require(script.Parent.EnemyData)

function RaidManager.StartRaid(player, raidName, enemyCount)
    player.Resources = (player.Resources or 0) + 5 -- base reward
    local enemies = {}
    for i = 1, enemyCount do
        table.insert(enemies, EnemyData.New("Spider"))
    end
    RaidManager.ActiveRaids[raidName] = {Owner = player.UserId, Participants = {player}, Enemies = enemies}
end

return RaidManager
```

- [ ] **Step 4: Run test – should PASS**

```bash
rbxmk.exe test src/Raids/RaidManager.test.lua -v
```

- [ ] **Step 5: Commit**

```bash
git add src/Raids/RaidManager.server.lua src/Raids/RaidManager.test.lua
git commit -m "feat: raid manager now spawns enemies"
```

---

### Task 3: Combat System – Resolve Player Attack

**Files:**
- Create: `src/Combat/CombatSystem.server.lua`
- Create: `src/Combat/CombatSystem.test.lua`

**Interfaces:**
- Consumes: `RaidManager.ActiveRaids`, `EnemyData` (enemy objects), `Player` table (must have `Attack` and `Health`).
- Produces: `CombatSystem.PlayerAttack(player, raidName, enemyIndex)` – reduces enemy health by player attack; if enemy health <= 0, remove enemy and grant reward.

- [ ] **Step 1: Write failing test**

```lua
return function()
    local Combat = require(script.Parent.CombatSystem)
    local RaidMgr = require(script.Parent.RaidManager)
    local player = {UserId = 1, Resources = 0, Attack = 15, Health = 100}
    RaidMgr.StartRaid(player, "PicnicBasket", 1)
    local beforeHealth = RaidMgr.ActiveRaids["PicnicBasket"].Enemies[1].Health
    Combat.PlayerAttack(player, "PicnicBasket", 1)
    local afterHealth = RaidMgr.ActiveRaids["PicnicBasket"].Enemies[1].Health
    expect(afterHealth).to.equal(beforeHealth - player.Attack)
end
```

- [ ] **Step 2: Run test – expect failure**

```bash
rbxmk.exe test src/Combat/CombatSystem.test.lua -v
```

- [ ] **Step 3: Minimal implementation**

```lua
local CombatSystem = {}
local RaidMgr = require(script.Parent.RaidManager)

function CombatSystem.PlayerAttack(player, raidName, enemyIdx)
    local raid = RaidMgr.ActiveRaids[raidName]
    local enemy = raid.Enemies[enemyIdx]
    if not enemy then return end
    enemy.Health = enemy.Health - (player.Attack or 0)
    if enemy.Health <= 0 then
        -- grant reward for killing enemy
        player.Resources = (player.Resources or 0) + 2
        table.remove(raid.Enemies, enemyIdx)
    end
end

return CombatSystem
```

- [ ] **Step 4: Run test – should PASS**

```bash
rbxmk.exe test src/Combat/CombatSystem.test.lua -v
```

- [ ] **Step 5: Commit**

```bash
git add src/Combat/CombatSystem.server.lua src/Combat/CombatSystem.test.lua
git commit -m "feat: basic combat system – player attack against raid enemy"
```

---

### Task 4: Enemy Counter‑Attack Logic

**Files:**
- Modify: `src/Combat/CombatSystem.server.lua`
- Create: `src/Combat/CombatSystemEnemyAttack.test.lua`

**Interfaces:**
- Consumes: Same as Task 3.
- Produces: `CombatSystem.EnemyAttack(player, raidName, enemyIdx)` – reduces player health by enemy attack; if player health <= 0, mark player as defeated (set `Health = 0`).

- [ ] **Step 1: Write failing test**

```lua
return function()
    local Combat = require(script.Parent.CombatSystem)
    local RaidMgr = require(script.Parent.RaidManager)
    local player = {UserId = 1, Resources = 0, Attack = 10, Health = 30}
    RaidMgr.StartRaid(player, "PicnicBasket", 1)
    Combat.EnemyAttack(player, "PicnicBasket", 1)
    expect(player.Health).to.be.below(30)
end
```

- [ ] **Step 2: Run test – fails**

```bash
rbxmk.exe test src/Combat/CombatSystemEnemyAttack.test.lua -v
```

- [ ] **Step 3: Implement enemy attack**

```lua
function CombatSystem.EnemyAttack(player, raidName, enemyIdx)
    local raid = RaidMgr.ActiveRaids[raidName]
    local enemy = raid.Enemies[enemyIdx]
    if not enemy then return end
    player.Health = (player.Health or 0) - (enemy.Attack or 0)
    if player.Health <= 0 then
        player.Health = 0
        -- could add defeat flag here later
    end
end
```

- [ ] **Step 4: Run test – should PASS**

```bash
rbxmk.exe test src/Combat/CombatSystemEnemyAttack.test.lua -v
```

- [ ] **Step 5: Commit**

```bash
git add src/Combat/CombatSystem.server.lua src/Combat/CombatSystemEnemyAttack.test.lua
git commit -m "feat: enemy counter‑attack implementation"
```

---

### Task 5: HUD Updates for Combat

**Files:**
- Modify: `src/UI/HUD.client.lua`
- Create: `src/UI/HUDCombat.test.lua`

**Interfaces:**
- Consumes: Player table (`Health`, `Resources`) and current raid enemy list (`ActiveRaids`).
- Produces: Updated UI frame that shows player health, resources, and a list of enemy health bars.

- [ ] **Step 1: Write failing UI test**

```lua
return function()
    local HUD = require(script.Parent.HUD)
    local player = {Resources = 5, Health = 40}
    local raid = {Enemies = {{Type = "Spider", Health = 50}, {Type = "Bee", Health = 40}}}
    local frame = HUD.CreateCombat(player, raid)
    expect(frame:FindFirstChild("PlayerHealth").Text).to.equal("40")
    expect(#frame:FindFirstChild("Enemies").GetChildren()).to.equal(2)
end
```

- [ ] **Step 2: Run test – fails**

```bash
rbxmk.exe test src/UI/HUDCombat.test.lua -v
```

- [ ] **Step 3: Implement HUD combat UI**

```lua
local HUD = {}

function HUD.CreateCombat(player, raid)
    local frame = Instance.new("Frame")
    local pHealth = Instance.new("TextLabel")
    pHealth.Name = "PlayerHealth"
    pHealth.Text = tostring(player.Health or 0)
    pHealth.Parent = frame

    local enemiesFolder = Instance.new("Folder")
    enemiesFolder.Name = "Enemies"
    enemiesFolder.Parent = frame
    for _, enemy in ipairs(raid.Enemies or {}) do
        local eLabel = Instance.new("TextLabel")
        eLabel.Name = enemy.Type .. "Health"
        eLabel.Text = tostring(enemy.Health)
        eLabel.Parent = enemiesFolder
    end
    return frame
end

return HUD
```

- [ ] **Step 4: Run test – should PASS**

```bash
rbxmk.exe test src/UI/HUDCombat.test.lua -v
```

- [ ] **Step 5: Commit**

```bash
git add src/UI/HUD.client.lua src/UI/HUDCombat.test.lua
git commit -m "feat: HUD now displays combat info"
```

---

### Task 6: End‑to‑End Raid Flow Test

**Files:**
- Create: `src/Raids/RaidFlow.test.lua`

**Interfaces:**
- Consumes all previously created modules.
- Produces: A single test that runs a full raid: start raid, player attacks until enemies are dead, verifies resource reward and that `ActiveRaids` is cleared.

- [ ] **Step 1: Write the integration test**

```lua
return function()
    local RaidMgr = require(script.Parent.RaidManager)
    local Combat = require(script.Parent.CombatSystem)
    local player = {UserId = 1, Resources = 0, Attack = 20, Health = 100}
    RaidMgr.StartRaid(player, "PicnicBasket", 2)
    -- Simulate player attacking both enemies until they die
    while #RaidMgr.ActiveRaids["PicnicBasket"].Enemies > 0 do
        Combat.PlayerAttack(player, "PicnicBasket", 1)
    end
    expect(#RaidMgr.ActiveRaids["PicnicBasket"].Enemies).to.equal(0)
    expect(player.Resources).to.be.above(0) -- rewards from kills and base reward
end
```

- [ ] **Step 2: Run test – fails (missing loop logic, etc.)**

```bash
rbxmk.exe test src/Raids/RaidFlow.test.lua -v
```

- [ ] **Step 3: Adjust `CombatSystem.PlayerAttack` to grant kill reward** (already does, ensure reward applied for each kill).

- [ ] **Step 4: Run test – should PASS**

```bash
rbxmk.exe test src/Raids/RaidFlow.test.lua -v
```

- [ ] **Step 5: Commit**

```bash
git add src/Raids/RaidFlow.test.lua
git commit -m "test: end‑to‑end raid flow validates combat and rewards"
```

---

## Self‑Review Checklist
1. **Spec coverage** – all combat‑related requirements (enemy data, spawning, player attack, enemy counter‑attack, HUD updates, end‑to‑end flow) have dedicated tasks.
2. **No placeholders** – every step contains concrete code or commands.
3. **Type consistency** – `EnemyData` returns `Health` and `Attack` numbers; `CombatSystem` uses those fields; `Player` now has `Health` and `Attack` fields defined consistently across tasks.
4. **Commit granularity** – each task ends with an isolated commit.
5. **Test isolation** – each task includes its own failing‑then‑passing test suite.

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-07-02-combat-raid-expansion.md`.** Two execution options:

1. **Subagent‑Driven (recommended)** – I will dispatch a fresh sub‑agent per task, review each result, and commit iteratively.
2. **Inline Execution** – I will run the tasks sequentially in this session using the `executing-plans` skill.

**Which approach would you like to take?**