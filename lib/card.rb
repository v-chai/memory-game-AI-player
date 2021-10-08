

class Card

    attr_reader :face
    attr_accessor :hidden, :value

    

    def initialize(deck)
        @value = deck.sample.to_s
        @hidden = true
        @face = "  *  "
    end

    def reveal
        @hidden = false
        @face = "  #{self.value}  "
    end

    def hide
        @hidden = true
        @face = "  *  "
    end

    def ==(other_card)
        self.value == other_card.value
    end


end