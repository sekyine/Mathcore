class GeminiController < ApplicationController
  protect_from_forgery with: :null_session  # API用にCSRF無効化

  def generate_content
    prompt = params[:prompt]
    #session[:conversation] ||= []

    if prompt.blank?
      render json: { error: 'プロンプトが空です' }, status: :bad_request
      return
    end

    begin

      result = GeminiApiService.call_gemini_api(prompt)

      # AIの応答を履歴に追加
      #session[:conversation] << { role: 'model', text: result }
      #session[:conversation] = session[:conversation].last(10)
      render json: { response: result, conversation_history: session[:conversation] }
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end



