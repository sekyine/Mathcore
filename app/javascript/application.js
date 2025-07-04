import "@hotwired/turbo-rails";
import "controllers";
import "randomizer";
import "gacha_animation";
import { Howl } from "howler";

console.log("【A】application.js スクリプトの評価開始 (フルリロード時に1回だけのはず)");

// --- BGM再生ロジック ---
if (!window.bgm) {
  console.log("【B】BGMオブジェクトが存在しないため、新規作成します。");
  window.bgm = new Howl({
    src: ['/assets/audios/bgm.mp3'], // あなたのBGMファイル名に変更してください
    loop: true,
    volume: 0.3,
    html5: true
  });

  console.log("【C】BGM再生用の初回クリックリスナーを設定します。");
  document.body.addEventListener('click', () => {
    console.log("【D】初回クリックを検知。BGMの再生状態を確認します。");
    if (window.bgm && !window.bgm.playing()) {
      console.log("【E】BGMが再生されていないため、再生します。");
      window.bgm.play();
    } else {
      console.log("【F】BGMは既に再生中です。");
    }
  }, { once: true });
} else {
  console.log("【G】BGMオブジェクトは既に存在します。");
}


// --- SE再生ロジック ---
document.addEventListener('turbo:load', () => {
  console.log("【H】turbo:load イベント発生。SEボタンのリスナーを設定します。");
  
  const clickableButtons = document.querySelectorAll('.se-clickable');
  const clickSound = document.getElementById('click-sound');

  if (clickSound && clickableButtons.length > 0) {
    clickableButtons.forEach(button => {
      if (button.dataset.seListenerAttached) return;
      button.dataset.seListenerAttached = 'true';
      button.addEventListener('click', (event) => {
        event.preventDefault();
        clickSound.currentTime = 0;
        clickSound.play().catch(e => console.error("Audio play failed:", e));
        const destinationUrl = button.href;
        setTimeout(() => {
          Turbo.visit(destinationUrl);
        }, 900); // SEの再生時間を考慮して調整
      });
    });
  }
});