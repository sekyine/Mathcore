// app/javascript/randomizer.js

export function fixedShuffleElements() {
  const boxes = document.querySelectorAll('.fixed_random-box');

  boxes.forEach(box => {
    const items = Array.from(box.querySelectorAll('.random_item'));

    for (let i = items.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [items[i], items[j]] = [items[j], items[i]];
    }

    box.innerHTML = '';
    items.forEach(item => box.appendChild(item));
  });
}

document.addEventListener('DOMContentLoaded', fixedShuffleElements);
