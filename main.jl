# Creating a flashcard program using the command line
using REPL.TerminalMenus
include("structs.jl")
include("functions.jl")

deck_files = readdir("./decks")
#selected_decks = request("Please select from the following decks:", MultiSelectMenu(deck_files))
selected_decks = deck_files
deck = union(read_cards_from_deck_file.(selected_decks)...) |> Deck

while length(deck.cards) > 0
    card = pick_a_card!(deck)
    clear_screen()
    printstyled("$(card.question)\n", color=:light_cyan)
    readline()
    printstyled("$(card.answer)\n", color=:yellow)
    readline()
    println("Did you get it right? (y/n)")

    response = readline()
    while true
        if response == "n"
            println("\nPutting card back into the deck")
            card.views += 1
            push!(deck.cards, card)
            readline()
            break
        elseif response == "y"
            is_valid_input = true
            if length(deck.cards) > 0
                printstyled("\nGreat! :)\nPress enter for next flashcard\n",
                color=:light_green)
                readline()
            elseif length(deck.cards) == 0
                printstyled("Congrats, you've finished the deck! :)
                \nPress enter to close", color=:light_green)
                readline()
            end
            break
        else
            println("\"$response\" is invalid input (must be y or n)")
            println("Did you get it right? (y/n)")
            response = readline()
        end
    end
end