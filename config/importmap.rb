# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "bootstrap" # @5.3.7
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8

pin "randomizer", to: "randomizer.js"
pin "gacha_animation", to: "gacha_animation.js"

# ↓↓↓ "gacha_animation"の行と改行されていることを確認してください ↓↓↓
pin "howler" # @2.2.4