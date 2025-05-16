class ApplicationController < ActionController::Base
  include SessionsHelper 
  allow_browser versions: :modern
end
