mutable struct Card
    question::AbstractString
    answer::AbstractString
    views::Int64
end
Card(question, answer) = Card(question, answer, 0)

mutable struct Deck
    cards::Vector{Card}
end