require 'io/console'
require 'timeout'
Dir["./resources/*"].each do |file|
  require file
end

def serpentine
    game = Game.new(20)
    game.play
    if game.lost == true
      game.board
      game.scoreline
      quitter
    end
end

def quitter
  puts "Oops! Play again? (y/n)"
  response = gets.chomp
  if response.downcase == "y"
    Cell.reset
    serpentine
  elsif response.downcase == "n"
    puts "\nGoodbye! Sssee you sssooon..."
    sleep(1)
    exit
  else
    quitter
  end
end

if __FILE__ == $0
  serpentine
end