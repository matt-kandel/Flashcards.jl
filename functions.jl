using StatsBase

# Normalize a Deck so that all card probabilities add to 1
function rebase!(deck::Deck)
    factor = sum(card.probability for card in deck.cards)
    for card in deck.cards
        card.probability /= factor
    end
    if round(sum(card.probability for card in deck.cards), digits=5) != 1
        error("Check normalization calculation (sum of probabilities != 1)")
    end
end

# Take a card from the deck, and modify the deck to remove that card
function pick_a_card!(deck::Deck)
    card = sample(deck.cards, Weights([c.probability for c in deck.cards]))
    deck.cards = filter((c -> c != card), deck.cards)
    return card
end

clear_screen() = print("\033c")