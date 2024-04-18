# Creating a flashcard program using the command line
# For formulas I'll provide all variable names in the question
include("structs.jl")
include("functions.jl")

deck = Deck([])
for section in readdir("./decks")
    cards = split(read("./decks/$section", String), "\r\n\r\n")
    for card in cards
        question = match(r"^[^\*]*(?=\r\n)", card).match
        answer = join((x -> x.match).(eachmatch(r"\*.*", card)), "\n")
        push!(deck.cards, Card(question, answer, 1))
    end
end

while length(deck.cards) > 0
    rebase!(deck)
    card = pick_a_card!(deck)
    clear_screen()
    println(card.question)
    readline()
    println(card.answer)
    readline()
    println("Did you get it right? (y/n)")

    response = readline()
    continue_guessing = true
    while continue_guessing
        if response == "n"
            continue_guessing = false
            println("Putting card back into the deck")
            if length(deck.cards) > 0
                # You've just seen this card, so make it less likely
                card.probability = 1 / length(deck.cards) / 5
            end
            push!(deck.cards, card)
            readline()
        elseif response == "y"
            continue_guessing = false
            if length(deck.cards) > 0
                println("Great! Press any key for next flashcard")
                readline()
            elseif length(deck.cards) == 0
                println("Congrats! You've finished the deck :)")
            end
        else
            println("$response is invalid input (must be y or n)")
            response = readline()
        end        
    end
end