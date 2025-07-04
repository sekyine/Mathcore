import { Controller } from "@hotwired/stimulus"

// `data-controller="bgm"`が指定されたHTML要素に接続します
export default class extends Controller {
  // `data-bgm-target`で指定された要素を取得します
  static targets = [ "audio", "toggleButton" ]

  connect() {
    // コントローラーがHTML要素に接続されたときに呼ばれます
    // console.log("BGM controller connected", this.element);
  }

  toggle() {
    // ボタンがクリックされたときに呼ばれるアクションです
    if (!this.hasAudioTarget) return; // audio要素がなければ何もしない

    const bgm = this.audioTarget;
    const icon = this.toggleButtonTarget.querySelector('i');
    
    // mutedプロパティを反転させます
    bgm.muted = !bgm.muted;
    
    // アイコンのクラスを切り替えます
    if (bgm.muted) {
      icon.classList.remove('fa-volume-high');
      icon.classList.add('fa-volume-xmark');
    } else {
      icon.classList.remove('fa-volume-xmark');
      icon.classList.add('fa-volume-high');
      // 念のため再生も試みます
      bgm.play().catch(e => console.error("BGMの再生に失敗:", e));
    }
  }
}