function pick_a_card!(deck::Deck)
    # The minimum views ensures that you don't see a card again until you've
    # gone through the rest of the deck
    min_views = minimum(card.views for card in deck.cards)
    min_views_deck = filter((c -> c.views == min_views), deck.cards)
    # pick a card
    card = rand(min_views_deck)
    # remove the card from the deck
    deck.cards = filter((c -> c != card), deck.cards)
    return card
end

clear_screen() = print("\033c")