mutable struct Card
    question::AbstractString
    answer::AbstractString
    probability::Float64
end

mutable struct Deck
    cards::Vector{Card}
end