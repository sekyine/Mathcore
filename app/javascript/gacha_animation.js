document.addEventListener('turbo:load', () => {
  const pullButton = document.getElementById('pull-gacha-button');
  const overlay = document.getElementById('animation-overlay');

  if (pullButton && overlay) {
    pullButton.addEventListener('click', (event) => {
      // 1. 本来のリンク遷移を一旦停止
      event.preventDefault();

      // 2. オーバーレイとGIFを表示
      overlay.style.display = 'flex';

      // 3. アニメーションの時間だけ待機 (例: 3秒 = 3000ミリ秒)
      const animationDuration = 3000; // ご自身のGIFの再生時間に合わせて調整してください

      setTimeout(() => {
        // 4. 結果ページへ遷移
        window.location.href = pullButton.href;
      }, animationDuration);
    });
  }
});