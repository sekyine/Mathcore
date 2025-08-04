require 'csv'

class Admin::CardsController < ApplicationController
#   def index
#     @cards = Card.all
#   end

#   def import_csv
#     file = params[:csv_file]
#     if file.present?
#       begin
#         # データ置き換えモードなら削除
#         if params[:replace_data] == "1"
#           SolvedCard.delete_all
#           UserCard.delete_all
#           Card.delete_all
#         end
#         if params[:replace_data2] == "1"
#           Battle.delete_all
#           BattleInvestigate.delete_all
#         end
#         #文字コード...encode("変換後", "変換前", inva... の形にする 現在はUTF-8で読み込み
#         csv_text = file.read.encode("UTF-8", "UTF-8", invalid: :replace, undef: :replace)
#         csv = CSV.parse(csv_text, headers: true)

#         csv.each do |row|
#           Card.create!(
#             image: row["image"],
#             st: row["st"],
#             bunya: row["bunya"],
#             ans: row["ans"],
#             imans1: row["imans1"],
#             imans2: row["imans2"],
#             imans3: row["imans3"],
#             effect_type: row["effect_type"],
#             power: row["power"],
#             question: row["question"],
#           )
          
#         end

#         redirect_to admin_cards_path, notice: "CSVインポートに成功しました"
#       rescue => e
#         Rails.logger.error("CSV読み込みエラー: #{e.message}")
#         redirect_to admin_cards_path, alert: "エラーが発生しました: #{e.message}"
#       end
#     else
#       redirect_to admin_cards_path, alert: "CSVファイルを選択してください"
#     end
#   end
end