# app/controllers/gemini_controller.rb
class GeminiController < ApplicationController
  protect_from_forgery with: :null_session  

  def test
    # URL のクエリパラメーターから question を受け取る
    @question = params[:question]
    # セッションに一意な値を与える（例: session.id または SecureRandom.uuid）
    session_id = session.id || SecureRandom.uuid
    # question の値を GeminApiService にそのまま渡す
    @api_response = GeminiApiService.call_gemini_api(@question, session_id)
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
      render json: { response: result, conversation_history: Rails.cache.read("conversation_#{session_id}") }
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
