class HumanPlayer
    attr_reader :size

    def initialize
        @human = "human"
    
    end

    def get_guess
        puts "To flip a card, enter the desired card by its row number and column number"
        puts "(e.g., `1,0`)"
        guess = nil
        until guess && valid_guess?(guess)
            input = gets.chomp
            guess = input.split(",").map(&:to_i)
        end
        guess
    end

    def prompt_board_size
        puts "Choose board size: from 2 to 6"
        @size = gets.chomp.to_i
        if valid_board_size?(@size)
            return @size
        else
            prompt_board_size
        end
    end 

    def valid_board_size?(board_size)
        board_size > 1 && board_size < 7
    end

    def play_again?
        puts "Play again? [y/n]"
        response = gets.chomp
        if ["y", "yes", "Y", "Yes", "YES"].include?(response)
            new_game = Game.new
            new_game.play
        end
    end


    def valid_guess?(guess)
        guess.is_a?(Array) &&
        guess.length == 2 &&
        guess.all? { |idx| idx.between?(0, @size - 1) }
    end
end