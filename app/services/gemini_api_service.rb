# app/services/gemini_api_service.rb
require 'json'
require 'net/http'

class GeminiApiService
  def self.call_gemini_api(prompt)
    api_key = ENV['GEMINI_API_KEY']
    uri = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=#{api_key}")

    request = Net::HTTP::Post.new(uri, { 'Content-Type' => 'application/json' })
    request.body = { contents: [{ role: 'user', parts: [{ text: prompt }] }] }.to_json
    #request.body = { contents: contents }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    JSON.parse(response.body)
  end
end

