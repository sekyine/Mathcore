# app/controllers/gemini_controller.rb
class GeminiController < ApplicationController
  protect_from_forgery with: :null_session  # API用にCSRF無効化

  def generate_content
    prompt = params[:prompt]
    if prompt.blank?
      render json: { error: 'プロンプトが空です' }, status: :bad_request
      return
    end

    begin
      session_id = session.id
      result = GeminiApiService.call_gemini_api(prompt, session_id)
      render json: { response: result, conversation_history: Rails.cache.read("conversation_#{session_id}") }
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end




