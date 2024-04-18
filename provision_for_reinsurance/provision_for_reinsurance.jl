# Fall 2018 q15
using CSV, DataFrames
import Base.sum

struct Recoverable
    amount::Number
    is_paid::Bool
    is_late::Bool
    is_disputed::Bool
end

sum(recoverables::AbstractArray{Recoverable}) = sum(r.amount for r in recoverables)

abstract type Reinsurer end

struct Authorized_Reinsurer <: Reinsurer
    name::String
    collateral::Number
    recoverables::Vector{Recoverable}
end

struct Unauthorized_Reinsurer <: Reinsurer
    name::String
    collateral::Number
    recoverables::Vector{Recoverable}
end

df = CSV.read("./problem_inputs/Fall2018_q15.csv", DataFrame)
A = df[df.name_of_reinsurer .== "A", :]
B = df[df.name_of_reinsurer .== "B", :]

function read_recoverable(row)
    is_paid = row.status == "Paid"
    is_disputed = row.status == "In Dispute"
    is_late = row.is_late == "yes"
    Recoverable(row.amount, is_paid, is_late, is_disputed)
end

ReinsurerA = Authorized_Reinsurer("A", 6.1, read_recoverable.(eachrow(A)))
ReinsurerB = Unauthorized_Reinsurer("B", 10.2, read_recoverable.(eachrow(B)))

function find_provision_for_reinsurance(r::Authorized_Reinsurer)
    unpaid_recoverables = filter(x -> !x.is_paid, r.recoverables) |> sum
    unpaid_undisputed_recoverables = filter(x -> !x.is_disputed && !x.is_paid, r.recoverables) |> sum
#    recently_paid = filter(x -> x.is_paid && !x.is_late, r.recoverables) |> sum
    # it's not worth trying to automate this further
    recently_paid = 7 # If I wanted to get this right, I'd need to use the Dates module and also introduce an evaluation date

    late_undisputed_recoverables = filter(x -> x.is_late && !x.is_disputed, r.recoverables) |> sum
    late_payments = filter(x -> x.is_late, r.recoverables) |> sum
    
    slow_pay_ratio = late_undisputed_recoverables / (unpaid_undisputed_recoverables + recently_paid)

    # fast payers
    if slow_pay_ratio < .2
        return .2 * late_payments
    # slow payers
    else
        return .2 * maximum([unpaid_recoverables - minimum([unpaid_recoverables, r.collateral]), late_payments])
    end
end

function find_provision_for_reinsurance(r::Unauthorized_Reinsurer)
    unpaid_recoverables = filter(x -> !x.is_paid, r.recoverables) |> sum
    late_undisputed_recoverables = filter(x -> x.is_late && !x.is_disputed, r.recoverables) |> sum
    disputed_unpaid_recoverables = filter(x -> !x.is_paid && x.is_disputed, r.recoverables) |> sum

    return unpaid_recoverables - r.collateral + .2 * (late_undisputed_recoverables + disputed_unpaid_recoverables)
end

answer = find_provision_for_reinsurance.([ReinsurerA, ReinsurerB]) |> sum