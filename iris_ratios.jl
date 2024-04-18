"""
IRIS 1: Gross written premium to policyholder surplus
Normal range: <= 900%
"""
function iris_1(direct_written_premium, assumed_reinsurance, policyholder_surplus)
    (direct_written_premium + assumed_reinsurance) / policyholder_surplus
end

"""
IRIS 2: Net written premium to policyholder surplus
Normal range: <= 300%
"""
function iris_2(net_written_premium, policyholder_surplus)
    net_written_premium / policyholder_surplus
end

"""
IRIS 3: Change in net written premium
Normal range: -33% to 33%
"""
function iris_3(net_written_premium₀, net_written_premium₋₁)
    (net_written_premium₀ - net_written_premium₋₁) / net_written_premium₋₁
end

"""
IRIS 4: Change in net written premium
Normal range: < 15%
ceded_reinsurance_premiums includes affiliates and non-affiliates
unearned_premiums includes authorized, unauthorized, foreign, domestic, etc.
"""
function iris_4(ceded_commissions, ceded_contingent_commissions,
    ceded_reinsurance_premiums, unearned_premiums, policyholder_surplus)

    surplus_aid = (
        (ceded_commissions + ceded_contingent_commissions) * unearned_premiums
        / ceded_reinsurance_premiums
    )
    surplus_aid / policyholder_surplus
end

"""
IRIS 5: Two year operating ratio
Normal range: < 100%
Every variable in IRIS 5 is current year + prior year
"""
function iris_5(loss_and_lae, policyholder_dividends, earned_premium,
    other_underwriting_expenses, other_income, written_premium, investment_income) 
    
    loss_ratio = (loss_and_lae + policyholder_dividends) / earned_premium
    expense_ratio = (other_underwriting_expenses + other_income) / written_premium
    income_ratio = investment_income / earned_premium

    loss_ratio + expense_ratio - income_ratio
end

"""
IRIS 6: Investment yield
Normal range: 2% to 5.5%
This ratio measures two year (current + prior) investment yield
"""
function iris_6(net_investment_income_earned, cash, two_year_invested_assets,
    two_year_invested_income_due_and_accrued, two_year_borrowed_money)
    
    2 * net_investment_income /
    (cash + two_year_invested_assets + two_year_invested_income_due_and_accrued
        + two_year_borrowed_money - net_investment_income_earned)
end

"""
IRIS 7: Gross change in policyholder surplus
Normal range: -10% to 50% 
"""
function iris_7(policyholder_surplus₀, policyholder_surplus₋₁)
    (policyholder_surplus₀ - policyholder_surplus₋₁) / policyholder_surplus₋₁
end

"""
IRIS 8: Change in adjusted policyholder surplus
Normal range: -10% to 25%
"""
function iris_8(policyholder_surplus0, policyholder_surplus1, change_in_surplus_notes,
    capital_paid_or_transferred, surplus_paid_or_transferred)
    (policyholder_surplus0 - change_in_surplus_notes - capital_paid_or_transferred - surplus_paid_or_transferred - policyholder_surplus1) / abs(policyholder_surplus1)
end
    
"""
IRIS 9: Adjusted liabilities to liquid assets
Normal range: < 100%
cash_equivalents includes short term invesetments
investments_in_affiliates includes parents & subsidiaries as well
"""
function iris_9(total_liabilities, deferred_agents_balances, bonds, stocks,
    cash, cash_equivalents, receivables_for_securities,
    investment_income_due_and_accrued, investments_in_affiliates)
    numerator = total_liabilities - deferred_agents_balances
    denominator = bonds + stocks + cash + cash_equivalents + receivables_for_securities + investment_income_due_and_accrued - investments_in_affiliates 

    numerator / denominator
end

"""
IRIS 10: Gross agents balances to policyholder surplus
Normal range: < 40%
"""
function iris_10(gross_agents_balances_in_collection, policyholder_surplus)
    gross_agents_balances_in_collection / policyholder_surplus
end

"""
IRIS 11: One year loss reserve development
Normal range: < 20%
"""
function iris_11(one_year_reserve_development, policyholder_surplus)
    one_year_reserve_development / policyholder_surplus
end

"""
IRIS 12: Two year loss reserve development
Normal range: < 20%
"""
function iris_12(two_year_reserve_development, policyholder_surplus)
    two_year_reserve_development / policyholder_surplus
end

"""
IRIS 13: Estimated current reserve deficiency to policyholder surplus
Normal range: < 25%
loss_reserves includes LAE
"""
function iris_13(loss_reserves₋₂, loss_reserves₋₁, loss_reserves₀, 
    earned_premium₋₂, earned_premium₋₁, earned_premium₀,
    loss_reserve_development₋₂, loss_reserve_development₋₁,
    policyholder_surplus)

    developed_reserves_to_premium_ratio₋₂ = (loss_reserves₋₂ + loss_reserve_development₋₂) / earned_premium₋₂ 
    developed_reserves_to_premium_ratio₋₁ = (loss_reserves₋₁ + loss_reserve_development₋₁) / earned_premium₋₁ 

    estimated_loss_reserve_deficiency = earned_premium₀ * (developed_reserves_to_premium_ratio₋₂ + developed_reserves_to_premium_ratio₋₁) / 2 - loss_reserves₀

    estimated_loss_reserve_deficiency / policyholder_surplus
end
