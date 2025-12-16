# Game Architecture Plan

## Overview

This project implements a modular game architecture using Elm, designed for collaborative development with GitHub Copilot agents. The architecture emphasizes:

1. **System Isolation**: Agents work on independent game systems
2. **Minimal Interfaces**: Systems expose only necessary APIs
3. **Testability**: Each system has unit tests and demo applications
4. **Single Repository**: Everything in one repo, organized by folders
5. **No Build Tools**: Pure Elm, no npm required

## Repository Structure

```
game-project/
├── elm.json                           # Main application config
├── src/
│   └── Main.elm                       # Main game orchestration
├── systems/
│   ├── Physics/
│   │   ├── Physics.elm                # Public API
│   │   ├── Internal.elm               # Private implementation
│   │   ├── tests/
│   │   │   ├── elm.json              # Physics test config
│   │   │   ├── PhysicsTests.elm      # Unit tests
│   │   │   └── run-tests.sh          # Test runner script
│   │   ├── demo/
│   │   │   ├── elm.json              # Physics demo config
│   │   │   ├── Demo.elm              # Demo application
│   │   │   ├── index.html            # Demo HTML
│   │   │   └── run-demo.sh           # Demo runner script
│   │   └── assets/
│   │       └── physics.css
│   ├── AI/
│   │   ├── AI.elm
│   │   ├── Pathfinding.elm
│   │   ├── tests/
│   │   ├── demo/
│   │   └── assets/
│   ├── Rendering/
│   │   ├── Rendering.elm
│   │   ├── tests/
│   │   ├── demo/
│   │   └── assets/
│   └── Input/
│       ├── Input.elm
│       ├── tests/
│       ├── demo/
│       └── assets/
├── assets/
│   └── main.css
├── test-all.sh                        # Run all system tests
├── test-system.sh                     # Run specific system tests
└── demo-system.sh                     # Run specific system demo
```

## Main Application Configuration

The root `elm.json` references all system source directories:

```json
{
  "type": "application",
  "source-directories": [
    "src",
    "systems/Physics",
    "systems/AI",
    "systems/Rendering",
    "systems/Input"
  ],
  "elm-version": "0.19.1",
  "dependencies": {
    "direct": {
      "elm/browser": "1.0.2",
      "elm/core": "1.0.5",
      "elm/html": "1.0.0"
    },
    "indirect": {}
  },
  "test-dependencies": {
    "direct": {},
    "indirect": {}
  }
}
```

## System Structure

Each system follows this pattern:

### Public API Module (e.g., `Physics.elm`)

```elm
module Physics exposing 
    ( Model
    , Msg
    , init
    , update
    , view
    )

-- Exposes ONLY the public interface
-- Hides all implementation details
```

### Internal Implementation (e.g., `Internal.elm`)

```elm
module Physics.Internal exposing (..)

-- Contains all implementation details
-- Not accessible from Main.elm
-- Accessible from tests for thorough testing
```

### Main Game Composition (`src/Main.elm`)

```elm
module Main exposing (main)

import Physics
import AI
import Rendering
import Input

type alias Model =
    { physics : Physics.Model
    , ai : AI.Model
    , rendering : Rendering.Model
    , input : Input.Model
    }

type Msg
    = PhysicsMsg Physics.Msg
    | AIMsg AI.Msg
    | RenderingMsg Rendering.Msg
    | InputMsg Input.Msg
    | Tick Float

-- Orchestrates all systems using only their public APIs
```

## Testing Strategy

### Test Configuration

Each system has its own `tests/elm.json`:

```json
{
  "type": "application",
  "source-directories": [
    "..",                          // Access system modules
    "."                            // Access test files
  ],
  "elm-version": "0.19.1",
  "dependencies": {
    "direct": {
      "elm/core": "1.0.5",
      "elm-explorations/test": "2.1.2"
    },
    "indirect": {}
  }
}
```

### Test Structure

```elm
module PhysicsTests exposing (suite)

import Test exposing (..)
import Expect
import Physics
import Physics.Internal as Internal

suite : Test
suite =
    describe "Physics System"
        [ describe "Public API"
            [ test "init creates valid model" <| \_ ->
                -- Test public interface
            ]
        
        , describe "Internal Implementation"
            [ test "gravity calculation is correct" <| \_ ->
                -- Test internal functions
            ]
        ]
```

### Running Tests

```bash
# Test specific system
cd systems/Physics/tests
./run-tests.sh

# Or use helper script
./test-system.sh Physics

# Test all systems
./test-all.sh
```

## Demo Applications

Each system has an isolated demo application for:
- Visual verification of system behavior
- Interactive testing during development
- Living documentation of system capabilities
- Scratch space for experiments

### Demo Configuration

Each system has its own `demo/elm.json`:

```json
{
  "type": "application",
  "source-directories": [
    "..",                          // Access system module
    "."                            // Access Demo.elm
  ],
  "elm-version": "0.19.1",
  "dependencies": {
    "direct": {
      "elm/browser": "1.0.2",
      "elm/core": "1.0.5",
      "elm/html": "1.0.0",
      "elm/time": "1.0.0"
    }
  }
}
```

### Demo Structure

```elm
module Demo exposing (main)

import Browser
import Physics

-- Standalone application that exercises the Physics system
-- in isolation from the main game

type alias Model =
    { physics : Physics.Model
    , paused : Bool
    }

-- Full Browser.element setup for interactive testing
```

### Running Demos

```bash
# Run specific system demo
cd systems/Physics/demo
./run-demo.sh

# Or use helper script
./demo-system.sh Physics
```

## CSS Management

### Option 1: Direct HTML Links

```html
<link rel="stylesheet" href="assets/main.css">
<link rel="stylesheet" href="systems/Physics/assets/physics.css">
<link rel="stylesheet" href="systems/AI/assets/ai.css">
```

### Option 2: CSS Imports

```css
/* assets/main.css */
@import url('../systems/Physics/assets/physics.css');
@import url('../systems/AI/assets/ai.css');
@import url('../systems/Rendering/assets/rendering.css');
```

### Option 3: Build Script Concatenation

```bash
cat assets/main.css \
    systems/Physics/assets/physics.css \
    systems/AI/assets/ai.css \
    > dist/bundle.css
```

## GitHub Copilot Agent Workflows

### Agent: Physics System Developer

**Context:**
```
You are working on the Physics system in systems/Physics/.

Structure:
- Physics.elm: Public API (expose only: Model, Msg, init, update, view)
- Internal.elm: Private implementation details
- tests/PhysicsTests.elm: Unit tests for both public and internal
- demo/Demo.elm: Interactive demo application

Workflow:
1. Implement features in Internal.elm
2. Expose minimal API in Physics.elm
3. Write tests in tests/PhysicsTests.elm
4. Create demo scenarios in demo/Demo.elm

Run tests: cd systems/Physics/tests && ./run-tests.sh
Run demo: cd systems/Physics/demo && ./run-demo.sh
```

### Agent: AI System Developer

**Context:**
```
You are working on the AI system in systems/AI/.

Structure:
- AI.elm: Public API
- Pathfinding.elm: Internal implementation
- tests/AITests.elm: Unit tests
- demo/Demo.elm: Interactive demo

Follow the same workflow as other systems.
Expose only: Model, Msg, init, update, view
Keep pathfinding and decision logic internal.
```

### Agent: Main Game Integrator

**Context:**
```
You work on src/Main.elm.

Your role:
- Compose Physics, AI, Rendering, and Input systems
- Use ONLY their public APIs
- Orchestrate system interactions
- Handle game loop and timing

You cannot access Internal modules.
Keep Main.elm focused on composition, not implementation.
```

## Development Commands

### Build Main Game

```bash
elm make src/Main.elm --output=dist/elm.js

# With optimization
elm make src/Main.elm --output=dist/elm.js --optimize

# Development with auto-reload
elm-live src/Main.elm -- --output=dist/elm.js
```

### Test Commands

```bash
# Test specific system
./test-system.sh Physics

# Test all systems
./test-all.sh

# Watch mode (if using elm-test)
cd systems/Physics/tests
elm-test --watch
```

### Demo Commands

```bash
# Run specific demo
./demo-system.sh Physics

# Watch mode for demo development
cd systems/Physics/demo
elm-live Demo.elm --open -- --output=demo.js
```

## Benefits of This Architecture

### For Development
✅ **No npm Required**: Pure Elm, compiler handles everything  
✅ **Single Repository**: Simple folder structure, no submodules  
✅ **Clear Boundaries**: Each system in its own directory  
✅ **Interface-Based Design**: `exposing` controls API surface  

### For Testing
✅ **Complete Isolation**: Each system tests independently  
✅ **Internal Access**: Tests can verify implementation details  
✅ **Visual Feedback**: Demo apps for interactive verification  
✅ **Fast Iteration**: Quick test/demo cycle  

### For Collaboration
✅ **Agent-Friendly**: Clear workspaces for different agents  
✅ **Small Context**: Main.elm stays tiny, systems self-contained  
✅ **Independent Work**: Systems don't interfere with each other  
✅ **Easy Integration**: Just add to source-directories  

### For Maintenance
✅ **Modular**: Systems can be developed/tested independently  
✅ **Documented**: Demos serve as living documentation  
✅ **Scalable**: Easy to add new systems  
✅ **Type-Safe**: Elm's compiler ensures correctness  

## Getting Started

### 1. Create First System

```bash
mkdir -p systems/Physics
mkdir -p systems/Physics/tests
mkdir -p systems/Physics/demo
mkdir -p systems/Physics/assets
```

### 2. Set Up System Files

- Create `Physics.elm` with public API
- Create `Internal.elm` with implementation
- Create `tests/elm.json` and `PhysicsTests.elm`
- Create `demo/elm.json` and `Demo.elm`

### 3. Update Root elm.json

Add `"systems/Physics"` to `source-directories`

### 4. Import in Main

```elm
import Physics

type alias Model =
    { physics : Physics.Model }
```

### 5. Develop with Tests & Demo

- Write tests: `cd systems/Physics/tests && elm-test`
- Build demo: `cd systems/Physics/demo && elm make Demo.elm`
- Iterate quickly with visual feedback

## Next Steps

1. Create initial system templates
2. Set up helper scripts (test-system.sh, demo-system.sh, etc.)
3. Establish coding conventions for system interfaces
4. Define common patterns for Model/Msg/init/update/view
5. Create example system as reference for Copilot agents
6. Document inter-system communication patterns

---

**Note**: This architecture is designed specifically for collaborative development with GitHub Copilot, emphasizing clear boundaries, isolated testing, and minimal context requirements.
