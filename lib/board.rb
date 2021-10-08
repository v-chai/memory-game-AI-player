
require_relative "./card.rb"

class Board
    attr_reader :board, :deck
    def initialize(board_size=4)
        @deck = ("A".."Z").to_a + (2..9).to_a + ["@", "$"]
        @board_size = board_size
        @board = self.populate(board_size)
    end

    def render
        system("clear")
        puts "Current Game Board"
        puts
        puts "    #{(0...@board_size).to_a.join('    ')}"
        puts
        @board.each_with_index do |row, idx|
            faces = ["#{idx} "]
            row.each { |card| faces << card.face }
            puts faces.join("")
            puts
        end
    end

    def populate(board_size)
        cards = get_cards.shuffle 
        cards.each_slice(board_size).to_a
    end

    def get_cards
        unique_card_count = @board_size ** 2
        unique_cards = []
        unique_card_count.times do |card| 
            new_card = Card.new(@deck)
            unique_cards << new_card
            @deck.delete(new_card.value)
        end
        unique_cards.each_with_index do |card, idx|
            if idx.odd?
                card.value = unique_cards[idx - 1].value
            end
        end
    end

    def reveal(guessed_position)
        row, col = guessed_position
        @board[row][col].reveal
    end

    def hide(guessed_position)
        row, col = guessed_position
        @board[row][col].hide
    end

    def [](position)
        row, col = position 
        board[row][col]
    end

    def won?
        if @board_size.even?
            return @board.flatten.none? { |card| card.hidden } 
        else
            return @board.flatten.one? { |card| card.hidden }
        end
    end

end