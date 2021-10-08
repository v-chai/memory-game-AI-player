require_relative "./card.rb"
require_relative "./board.rb"
require_relative "./human_player.rb"
require_relative "./computer_player.rb"
require "byebug"

class Game 
    attr_reader :board_size, :previous_guess, :guess, :all_positions, :computer
    attr_accessor :current_player, :players, :gameboard
    def initialize
        @player = HumanPlayer.new
        @board_size = @player.prompt_board_size
        @gameboard = Board.new(@board_size)
        @gameboard.render
        
        
        @computer = ComputerPlayer.new(@board_size)
        @players = [@player, @computer]
        @player_points = {@player => 0, @computer => 0}
        @current_player = @players[0]

        @previous_guess = nil
    end

    def play
        until self.game_over?
            system("clear")
            @gameboard.render
            guess = self.make_guess
            flip(guess)
            self.check_guess(guess)
            sleep 1
        end
        puts "Game over!"
        puts "You made #{@player_points[@player]} matches."
        puts "Computer made #{@player_points[@computer]} matches."
        @player.play_again?
    end 

    def game_over?
        @gameboard.won?
    end

    def flip(guess)
        @gameboard.reveal(guess)
        @gameboard.render
    end

    def hide(guess)
        @gameboard.hide(guess)
        @gameboard.render
    end

    def make_guess
        guess = @current_player.get_guess
        if !computer.checked_positions.include?(guess) 
            computer.checked_positions << guess
            computer.receive_revealed_card(guess, @gameboard[guess])
        end
        return guess
    end

    def check_guess(guess)
        if !@previous_guess
            @previous_guess = guess
        else
            if @gameboard[guess] == @gameboard[@previous_guess]
                puts "Match found!"
                @player_points[@current_player] += 1
                sleep 2
                @previous_guess = nil
            else
                print "Not a match. Better luck next turn."
                sleep 2
                [guess, @previous_guess].each { |g| self.hide(g) }
                self.next_player!
                @previous_guess = nil
            end
        end
    end   

    def next_player!
        @current_player = @players.rotate![0]
        if @current_player == @player
            print "Your turn!"
        else
            print "Computer's turn"
        end
        sleep 1
    end




end

if __FILE__ == $PROGRAM_NAME
    game = Game.new
    game.play
end