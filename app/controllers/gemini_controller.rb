class GeminiController < ApplicationController
  protect_from_forgery with: :null_session  # API用にCSRF無効化
  #skip_before_action :verify_authenticity_token
  def generate_content
    prompt = params[:prompt]
    #session[:conversation] ||= []

    if prompt.blank?
      render json: { error: 'プロンプトが空です' }, status: :bad_request
      return
    end

    begin
      #session[:conversation] << { role: 'user', text: prompt }
      contents = session[:conversation].map { |msg| { role: msg[:role], parts: [{ text: msg[:text] }] } }
      result = GeminiApiService.call_gemini_api(prompt)
      #result = GeminiApiService.call_gemini_api(contents)
      #session[:conversation] << { role: 'model', text: result }
      render json: result 
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end


