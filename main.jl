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
        push!(deck.cards, Card(question, answer))
    end
end

while length(deck.cards) > 0
    card = pick_a_card!(deck)
    clear_screen()
    println(card.question)
    readline()
    println(card.answer)
    readline()
    println("Did you get it right? (y/n)")

    response = readline()
    is_valid_input = false
    while !is_valid_input
        if response == "n"
            is_valid_input = true
            println("Putting card back into the deck")
            card.views += 1
            push!(deck.cards, card)
            readline()
        elseif response == "y"
            is_valid_input = true
            if length(deck.cards) > 0
                println("Great! Press any key for next flashcard")
                readline()
            elseif length(deck.cards) == 0
                println("Congrats! You've finished the deck :)")
                println("Press any key to close")
                readline()
            end
        else
            println("$response is invalid input (must be y or n)")
            println("Did you get it right? (y/n)")
            response = readline()
        end        
    end
end