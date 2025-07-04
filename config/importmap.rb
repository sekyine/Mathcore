pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# BootstrapとPopper.jsをバンドル版でCDNから読み込みます
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"

# application.jsからimportしている他のファイルをpinします
pin "randomizer", to: "randomizer.js"
pin "gacha_animation", to: "gacha_animation.js"