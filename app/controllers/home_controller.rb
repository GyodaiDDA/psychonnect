class HomeController < ApplicationController
  def index
    render json: {
      message: "Boas-vindas ao API do Psychonnect"
      docs: "em breve..."
    }
  end
end
