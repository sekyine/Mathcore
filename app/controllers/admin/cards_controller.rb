require 'csv'

class Admin::CardsController < ApplicationController
  def index
    @cards = Card.all
  end

  def import_csv
    file = params[:csv_file]
    if file.present?
      begin
        # 強制的にShift_JISをUTF-8に変換
        csv_text = file.read.encode("UTF-8", "Shift_JIS", invalid: :replace, undef: :replace)
        csv = CSV.parse(csv_text, headers: true)

        csv.each do |row|
          Card.create!(
            image: row["image"],
            st: row["st"],
            bunya: row["bunya"],
            ans: row["ans"],
            imans1: row["imans1"],
            imans2: row["imans2"],
            imans3: row["imans3"],
            effect_type: row["effect_type"],
            power: row["power"],
            question: row["question"]
          )
        end

        redirect_to admin_cards_path, notice: "CSVインポートに成功しました"
      rescue => e
        Rails.logger.error("CSV読み込みエラー: #{e.message}")
        redirect_to admin_cards_path, alert: "CSV読み込みエラー: #{e.message}"
      end
    else
      redirect_to admin_cards_path, alert: "CSVファイルが選択されていません"
    end
  end
end