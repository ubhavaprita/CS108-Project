# Snake Stack (Bash + Web)

## Overview

This project is a browser-based Snake game built using a three-layer architecture:

* Frontend: JavaScript + HTML5 Canvas
* Backend: Python (Flask)
* Administration: Bash script

Each layer has a specific responsibility:

* JavaScript handles the game and UI
* Flask receives and stores scores
* Bash processes stored data

---

## System Architecture

Browser (JavaScript) → POST /save_score → Flask (Python) → history.txt → Bash script

---

## Project Structure

snake-system/

├── app.py
├── admin.sh
├── history.txt
└── static/
  └── index.html

---

## How to Run

1. Start the server:

```
python3 app.py
```

2. Open in browser:

```
http://127.0.0.1:5000
```

---

## Game Features

* Grid-based Snake game

* Controls: Arrow keys or WASD

* Food types:

  * Carrot → +1 length
  * Pumpkin Pie → +3 length
  * Golden Apple → Immunity for 10 seconds

* Game over when:

  * Snake hits wall
  * Snake hits itself (if not immune)

Score = Length of snake

---

## UI Requirements

* Start modal:

  * Rules
  * Username input

* Game over modal:

  * Score
  * Cause
  * Duration
  * Timestamp
  * Highest score (session)

* Canvas centered on screen

---

## Score Reporting

Frontend sends score automatically on game over using POST request.

Endpoint:

```
/save_score
```

Example JSON:

```
{
  "name": "Player1",
  "score": 42,
  "cause": "WALL",
  "duration": 85
}
```

JavaScript only sends data — no storage logic.

---

## history.txt Format

Each entry is one line:

```
name,score,cause,duration,timestamp
```

Example:

```
Player1,42,WALL,85,2026-04-16 15:30:00
```

---

## Bash Script (admin.sh)

* Reads and processes history.txt
* Works for empty or multiple entries
* Can use awk, sed, sort

---

## Requirements Checklist

* app.py runs with:

```
python3 app.py
```

* Game runs on:

```
http://127.0.0.1:5000
```

* Scores saved to history.txt
* admin.sh works correctly
* No hardcoded paths

---




---


---
