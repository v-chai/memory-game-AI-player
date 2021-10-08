require "byebug"
class ComputerPlayer
    attr_reader :known_positions, :known_matches, :board_size, :not_guessed; :possibles
    attr_accessor :known_cards, :checked_positions, :first_guess
    def initialize(board_size)
        @board_size = board_size
        @known_cards = Hash.new {|position, card_value| @known_cards[position] = card_value}
        @checked_positions = Array.new
        @first_guess = nil
    end

    def possible_guesses
        @possibles = @known_cards.select {|position, card| card.hidden }
        if @first_guess
            @possibles[@first_guess] = @known_cards[@first_guess]
        end
        @possibles
    end

    def known_positions
        self.possible_guesses.each_with_object({}){|(k,v),o|(o[v.value]||=[])<<k}
    end

    def known_matches
        self.known_positions.select { |card_value, positions | positions.length > 1 } 
    end

    def get_guess
        if @first_guess == nil
            self.first_guess
        else
            self.second_guess
        end  
    end

    def first_guess
        known_matches = self.known_matches
        guesses = self.known_guess(known_matches)
        if guesses    
            @first_guess = guesses[0]
        else 
            @first_guess = self.random_guess
        end
        @first_guess
    end

    def second_guess
        match = self.check_for_match
        return match if match
        self.random_guess
    end

    def check_for_match
        positions = self.known_positions 
        new_match_value = @known_cards[@first_guess].value
        matched_positions = positions[new_match_value]
        prior_match = @first_guess.dup
        @first_guess = nil
        p @first_guess
        p prior_match
        match = matched_positions.reject {|position| position == prior_match } if matched_positions
        match[0]
    end
    
    def known_guess(known_matches)
        if known_matches.length == 0
            return nil
        else
            known_matches.values.first
        end
        
    end

    def random_guess
        guess = nil
        until guess && !@checked_positions.include?(guess)
            row = rand(0...@board_size)
            col = rand(0...@board_size)
            guess = [row, col]
        end
        guess
    end

    def receive_revealed_card(pos, value)
        @known_cards[pos] = value
    end


end
