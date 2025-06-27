import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "form", "input"]

  connect() {
    this._scrollToBottom();
    this.inputTarget.focus();
  }

  async sendMessage(event) {
    event.preventDefault();
    const prompt = this.inputTarget.value.trim();

    if (prompt === "") {
      return;
    }

    this._addMessage(prompt, "user");
    this.inputTarget.value = "";
    this._addLoadingIndicator();
    this._scrollToBottom();

    try {
      const csrfToken = document.querySelector("meta[name='csrf-token']").content;

      const response = await fetch('/gemini', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ prompt: prompt })
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || `HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      this._removeLoadingIndicator();
      this._addMessage(data.response.text, "ai");
      this._scrollToBottom();

    } catch (error) {
      console.error("Error:", error);
      this._removeLoadingIndicator();
      this._addMessage(`エラーが発生しました: ${error.message}`, "ai-error");
      this._scrollToBottom();
    }
  }

  _addMessage(content, role) {
    const messageRow = document.createElement("div");
    messageRow.className = `message-row ${role}-message`;

    const messageBubble = document.createElement("div");
    messageBubble.className = 'message-bubble';
    
    // 改行を <br> タグに変換
    const formattedContent = content.replace(/\n/g, '<br>');
    messageBubble.innerHTML = `<p>${formattedContent}</p>`;

    messageRow.appendChild(messageBubble);
    this.messagesTarget.appendChild(messageRow);
  }

  _addLoadingIndicator() {
    const loadingRow = document.createElement("div");
    loadingRow.className = "message-row ai-message";
    loadingRow.id = "loading-indicator";
    
    const bubble = document.createElement("div");
    bubble.className = "message-bubble loading";
    bubble.innerHTML = '<span>.</span><span>.</span><span>.</span>';
    
    loadingRow.appendChild(bubble);
    this.messagesTarget.appendChild(loadingRow);
  }

  _removeLoadingIndicator() {
    const indicator = this.messagesTarget.querySelector("#loading-indicator");
    if (indicator) {
      indicator.remove();
    }
  }

  _scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }
}