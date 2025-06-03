# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Card.create(image: 'test1.png', st: 1, bunya: "連立方程式", ans:234 ,imans1:345 ,imans2:567 ,imans3:678)
Card.create(image: 'test2.png', st: 1, bunya: "整数", ans:234 ,imans1:345 ,imans2:567 ,imans3:678)
Card.create(image: 'test3.png', st: 2, bunya: "二次方程式", ans:234 ,imans1:345 ,imans2:567 ,imans3:678)
Card.create(image: 'test4.png', st: 1, bunya: "引き算", ans:234 ,imans1:345 ,imans2:567 ,imans3:678)
Card.create(image: 'test5.png', st: 3, bunya: "連立方程式", ans:234 ,imans1:345 ,imans2:567 ,imans3:678)