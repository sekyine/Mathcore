# app/services/gemini_api_service.rb
require 'json'
require 'net/http'

class GeminiApiService
  def self.call_gemini_api(prompt, session_id)
    api_key = ENV['GEMINI_API_KEY']
    uri = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=#{api_key}")

    # 初期条件（システムプロンプト）
    system_instruction = "あなたは優秀な数学者です。"
    
    # キャッシュから過去の会話履歴を取得（例：ユーザーと AI 両方の発話を保持している）
    # 保存形式は例として ["ユーザー: １＋１は？", "AI: 1 + 1 = 2 です。", ...] としているものとする
    conversation_history = Rails.cache.fetch("conversation_#{session_id}", expires_in: 10.minutes) || []
    aggregated_context = conversation_history.join("\n")
    
    # 新たなユーザー発話を文脈に追加する
    combined_prompt_text = if aggregated_context.empty?
                               "#{system_instruction}\nユーザー: #{prompt}"
                             else
                               "#{system_instruction}\n#{aggregated_context}\nユーザー: #{prompt}"
                             end

    contents = [
      { role: 'user', parts: [ { text: combined_prompt_text } ] }
    ]

    # リクエスト作成
    request = Net::HTTP::Post.new(uri, { 'Content-Type' => 'application/json' })
    request.body = {
      model: "gemini-1.5-flash",
      contents: contents
    }.to_json
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    # API からの返答パース
    api_result = JSON.parse(response.body)
    response_text = if api_result.dig("candidates")
                      candidate = api_result["candidates"].first
                      candidate.dig("content", "parts", 0, "text")
                    else
                      api_result["text"] || api_result.to_s
                    end
                    
    formatted_text = response_text.strip.gsub(/\s+/, "")
    Rails.logger.debug("Gemini API raw response: #{response.body}")
    conversation_history << "ユーザー: #{prompt}"
    conversation_history << "AI: #{formatted_text}"
    # 必要に応じて、最新の10ターン程度だけ保持
    conversation_history = conversation_history.last(10)
    Rails.cache.write("conversation_#{session_id}", conversation_history, expires_in: 10.minutes)

    { text: formatted_text }
  end
end
