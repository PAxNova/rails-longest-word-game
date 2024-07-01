# app/controllers/games_controller.rb
require 'httparty'

class GamesController < ApplicationController
  include HTTParty

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split

    @valid = valid_word?(@word, @letters)
    @english_word = english_word?(@word)

    if !@valid
      @message = "Le mot ne peut pas être créé à partir de la grille d'origine."
    elsif !@english_word
      @message = "Le mot n'est pas un mot anglais valide."
    else
      @message = "Félicitations! Le mot est valide."
      @score = @word.length
      session[:score] = (session[:score] || 0) + @score
    end
  end

  private

  def valid_word?(word, letters)
    word.chars.all? { |char| word.count(char) <= letters.count(char) }
  end

  def english_word?(word)
    response = self.class.get("https://dictionary.lewagon.com/#{word}")
    response.parsed_response["found"]
  end
end
