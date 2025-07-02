def show
    @card = Card.find(params[:id])
end

def solve
    @card = Card.find(params[:id])
    user_answer = param[:answer].to_s.strip

    if user_answer == @card.answer
        render plain: "正解！"
    else
        render plain: "不正解...正解は#{@card.answer}です"
    end
end