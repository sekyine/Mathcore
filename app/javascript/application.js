// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "randomizer"
import "gacha_animation"


document.addEventListener('turbo:load', () => {
  const gachaButton = document.getElementById('gacha-button');
  const clickSound = document.getElementById('click-sound');

  if (gachaButton && clickSound) {
    // ページ遷移のたびにイベントが重複して登録されるのを防ぎます
    if (gachaButton.dataset.listenerAttached) return;
    gachaButton.dataset.listenerAttached = 'true';

    gachaButton.addEventListener('click', (event) => {
      // 1. リンクのデフォルト動作（ページ遷移）を停止
      event.preventDefault();

      // 2. 音声を再生
      clickSound.currentTime = 0;
      clickSound.play().catch(e => console.error("Audio play failed:", e));

      // 3. 遷移先のURLを取得し、指定時間後に手動でページ遷移
      const destinationUrl = gachaButton.href;
      
      setTimeout(() => {
        Turbo.visit(destinationUrl);
      }, 3000); // 0.3秒後に遷移 (クリック音ならこのくらいで十分です)
    });
  }
});
