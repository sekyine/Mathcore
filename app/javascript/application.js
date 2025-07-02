// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "randomizer"
import "gacha_animation"

document.addEventListener('turbo:load', () => {
  // IDでボタンを取得するように修正
  const button = document.getElementById('gacha-button');
  const sound = document.getElementById('click-sound');

  if (button && sound) {
    button.addEventListener('click', () => {
      // play()はPromiseを返すため、エラーハンドリングを追加するとより安全です
      sound.play().catch(error => console.log("Audio play failed:", error));
      // 再生位置をリセット
      sound.currentTime = 0;
    });
  }
});