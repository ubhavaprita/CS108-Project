
const input = document.getElementById('username-input');
const btn = document.getElementById('startBtn');
console.log("JS LOADED");
document.addEventListener("DOMContentLoaded", () => {

//ENTER KEY SUPPORT
input.addEventListener("keydown", (e) => {
  if (e.key === "Enter" && !btn.disabled) {
    btn.click();
  }
});


// VALIDATION
input.addEventListener('input', () => {
  const val = input.value.trim();
  const isValid = val.length >= 3;

  btn.disabled = !isValid;
  btn.classList.toggle('ready', isValid);
});
});

// CLICK EVENT
btn.addEventListener("click", () => {

  // hide entry UI
  document.querySelectorAll(".entry, .instructions").forEach(el => {
    el.style.display = "none";
  });

  // show game UI
  document.querySelectorAll(".game-wrapper").forEach(el => {
    el.style.display = "flex";   // important: keep flex
  });

});
 
// GAME SETUP
const canvas = document.getElementById("gameCanvas");
const ctx = canvas.getContext("2d");

const box = 40; 
const rows = canvas.height / box;
const cols = canvas.width / box;
const timerBar = document.getElementById("timerBar");

let snake = [{
  x: Math.floor(Math.random() * cols) * box,
  y: Math.floor(Math.random() * rows) * box
}];
let direction = "RIGHT";

let food = null;
let immunity = false;
let immunityTimer = null;
let immunityTimeLeft = 0;
let timerInterval = null;
let score = 0;
let growthPending = 0;

// CONTROLS 
document.addEventListener("keydown", (e) => {
  if ((e.key === "ArrowUp" || e.key === "w") && direction !== "DOWN") {
    direction = "UP";
  }

  if ((e.key === "ArrowDown" || e.key === "s") && direction !== "UP") {
    direction = "DOWN";
  }

  if ((e.key === "ArrowLeft" || e.key === "a") && direction !== "RIGHT") {
    direction = "LEFT";
  }

  if ((e.key === "ArrowRight" || e.key === "d") && direction !== "LEFT") {
    direction = "RIGHT";
  }
});

// FOOD
function spawnFood() {
  const types = ["carrot", "pumpkin", "apple"];
  let valid = false;

  while (!valid) {
    const newFood = {
      x: Math.floor(Math.random() * cols) * box,
      y: Math.floor(Math.random() * rows) * box,
      type: types[Math.floor(Math.random() * types.length)]
    };

    valid = !snake.some(seg => seg.x === newFood.x && seg.y === newFood.y);

    if (valid) {
      food = newFood;
    }
  }
}
// ------DRAW------
function drawFood() {
  if (!food) return;

  if (food.type === "carrot") ctx.fillStyle = "orange";
  if (food.type === "pumpkin") ctx.fillStyle = "yellow";
  if (food.type === "apple") ctx.fillStyle = "red";

  ctx.fillRect(food.x, food.y, box, box);
}

function drawSnake() {
  ctx.fillStyle = "white";
  console.log(snake);
  snake.forEach((seg) => {
    ctx.fillRect(seg.x, seg.y, box, box);
  });
}


// ---------GAME LOOP---------- 
function update() {
  let head = { ...snake[0] };

  if (direction === "UP") head.y -= box;
  if (direction === "DOWN") head.y += box;
  if (direction === "LEFT") head.x -= box;
  if (direction === "RIGHT") head.x += box;

  // WALL COLLISION
  if (
    head.x < 0 ||
    head.y < 0 ||
    head.x >= canvas.width ||
    head.y >= canvas.height
  ) {
    if (!immunity) {
      clearInterval(game);
      clearInterval(timerInterval);
      alert("Game Over (Wall Hit)");
      return;
    }
  }

  // SELF COLLISION
  for (let i = 1; i < snake.length; i++) {
    if (snake[i].x === head.x && snake[i].y === head.y) {
      if (!immunity) {
        clearInterval(game);
        clearInterval(timerInterval);
        alert("Game Over (Self Collision)");
        return;
      }
    }
  }

 snake.unshift(head);

// FOOD LOGIC
if (food && head.x === food.x && head.y === food.y) {

  if (food.type === "carrot") {
    score += 1;
    growthPending += 1;
  }

  if (food.type === "pumpkin") {
    score += 3;
    growthPending += 3;
  }

  if (food.type === "apple") {
    score+= 1;

    immunity = true;
    immunityTimeLeft = 10;

    clearInterval(timerInterval);

    timerInterval = setInterval(() => {
      immunityTimeLeft -= 0.1;

      if (immunityTimeLeft <= 0) {
        immunity = false;
        immunityTimeLeft = 0;
        clearInterval(timerInterval);
      }

      timerBar.style.height = (immunityTimeLeft / 10) * 100 + "%";
    }, 100);
  }

  document.getElementById("score").innerText = score;
  spawnFood();
  while (snake[0].x === food.x && snake[0].y === food.y) {
  spawnFood();
}

} else {
  
    snake.pop();
  }
}


//GROW
function growSnake(n) {
  for (let i = 0; i < n; i++) {
    snake.push({ ...snake[snake.length - 1] });
  }
}

//MAIN DRAW
function draw() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  drawFood();
  drawSnake();
  
}

//GAME START
let game;

btn.addEventListener("click", () => {
  spawnFood();

  game = setInterval(() => {
    update();
    draw();
  }, 200);
});