class Card
  attr_accessor :suit, :name, :value

  def initialize(suit, name, value)
    @suit, @name, @value = suit, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITS = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITS.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end
end

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suit_is_correct
    assert_equal @card.suit, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    includes_card = @deck.playable_cards.include?(card)
    assert(includes_card == false)
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class GameTest < Test::Unit::TestCase
  def setup
    @game = Game.new
  end
  
  def game_starts_with_winner_as_nil
    assert_equal @game.winner, nil
  end

  def players_and_dealers_add_cards_using_draw_card_method
    player_draw = @game.player.draw_card
    assert_instance_of Card, player_draw

    dealer_draw = @game.dealer.draw_card
    assert_instance_of Card, dealer_draw

    #reset player and dealer hands for next test
    @game.player.hand = []
    @game.dealer.hand = []

  end

  def player_eval_hand_returns_sum_if_not_blackjack_or_bust
    first_card = @game.player.draw_card
    second_card = @game.player.draw_card
    sum = first_card.value + second_card.value
    return_val = @game.player.eval_hand
    if return_val == 21
      assert_equal @game.winner, @game.player
    elsif return_val > 21
      assert_equal @game.winner, @game.dealer
    else
      assert_equal return_val, sum
    end
  end

  def game_continues_if_hand_equals_or_is_greater_than_17
    first_card = @game.deck.deal_card
    second_card = @game.deck.deal_card
    sum = first_card.value + second_card.value
    return_val = @game.player.eval_hand
    if return_val == 21
      assert_equal @game.winner, @game.player
    elsif return_val > 21
      assert_equal @game.winner, @game.dealer
    else
      assert_equal return_val, sum
    end

  end

    
end