# app/controllers/gemini_controller.rb
class GeminiController < ApplicationController
  protect_from_forgery with: :null_session

  def test
    # チャットページを初めて開く際に、前の会話履歴をクリアする
    session_id = session.id || SecureRandom.uuid
    Rails.cache.delete("conversation_#{session_id}")

    # このアクションはビューを表示するだけにする
    # @question や @api_response は不要になる
  end

  def generate_content
    prompt = params[:prompt]
    if prompt.blank?
      render json: { error: 'プロンプトが空です' }, status: :bad_request
      return
    end

    begin
      session_id = session.id || SecureRandom.uuid
      result = GeminiApiService.call_gemini_api(prompt, session_id)
      # レスポンスに会話履歴も含めて、デバッグしやすくする
      render json: { response: result, conversation_history: Rails.cache.read("conversation_#{session_id}") }
    rescue => e
      # エラーハンドリングをより詳細に
      Rails.logger.error "Gemini API Error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: "APIとの通信中にエラーが発生しました: #{e.message}" }, status: :internal_server_error
    end
  end
end