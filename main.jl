# Creating a flashcard program using the command line
# For formulas I'll provide all variable names in the question
include("structs.jl")
include("functions.jl")

deck = Deck([])
for section in readdir("./decks")
    cards = split(read("./decks/$section", String), "\r\n\r\n")
    for card in cards
        question_regex = match(r"^[^\*]*(?=\r\n)", card)
        if !isnothing(question_regex)
            question = question_regex.match
        else
            println("Check $section for improperly formatted flashcard(s)")
            readline()
        end
        answer = join((x -> x.match).(eachmatch(r"\*.*", card)), "\n")
        push!(deck.cards, Card(question, answer))
    end
end

while length(deck.cards) > 0
    card = pick_a_card!(deck)
    clear_screen()
    printstyled("$(card.question)\n", color=:light_cyan)
    readline()
    printstyled("$(card.answer)\n", color=:yellow)
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
                printstyled("Great! :)\n Press any key for next flashcard\n",
                    color=:light_green)
                readline()
            elseif length(deck.cards) == 0
                printstyled("Congrats, you've finished the deck! :)
                    \nPress enter to close", color=:light_green)
                readline()
            end
        else
            println("$response is invalid input (must be y or n)")
            println("Did you get it right? (y/n)")
            response = readline()
        end
    end
end