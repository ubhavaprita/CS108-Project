const input = document.getElementById('username-input');
const btn = document.getElementById('startBtn');

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
