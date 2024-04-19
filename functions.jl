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

function parse_card_text(text::AbstractString, deck_file::AbstractString)
    question_regex = match(r"^[^\*]*(?=\r\n)", text)
    if !isnothing(question_regex)
        question = question_regex.match
    else
        println("Check ./deck/$deck_file for improperly formatted flashcard(s)")
        readline()
    end
    answer = join((x -> x.match).(eachmatch(r"\*.*", text)), "\n")
    return Card(question, answer)
end
function parse_card_text(texts::Vector{SubString{String}}, deck_file::AbstractString)
    return [parse_card_text(text, deck_file) for text in texts]
end

function read_cards_from_deck_file(deck_file)
    card_texts = split(read("./decks/$deck_file", String), "\r\n\r\n")
    cards = parse_card_text(card_texts, deck_file)
end