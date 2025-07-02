// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "randomizer"
import "gacha_animation"

import { Turbo } from "@hotwired/turbo-rails";

document.addEventListener('turbo:load', () => {
  const gachaButton = document.getElementById('gacha-button');
  const clickSound = document.getElementById('click-sound');

  if (gachaButton && clickSound) {
    // 同じ要素にイベントが重複して登録されるのを防ぐ
    if (gachaButton.dataset.listenerAttached) return;
    gachaButton.dataset.listenerAttached = 'true';

    gachaButton.addEventListener('click', (event) => {
      // 1. リンクのデフォルト動作（ページ遷移）を一旦停止します。
      event.preventDefault();

      // 2. 音声を再生します。
      clickSound.currentTime = 0;
      clickSound.play().catch(e => console.error("Audio play failed:", e));

      // 3. 遷移先のURLを取得し、指定時間後に手動でページ遷移を実行します。
      const destinationUrl = gachaButton.href;
      
      setTimeout(() => {
        // このアプリケーションではTurbo Driveが使われているため、
        // Turbo.visitを使うと画面遷移がスムーズになります。
        Turbo.visit(destinationUrl);
      }, 30000); // SEの長さに応じて調整してください。
    });
  }
});