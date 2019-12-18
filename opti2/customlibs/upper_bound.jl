function hasUnsoldCase(placedMap)
    h = length(placedMap[1:end, 1])
    w = length(placedMap[1, 1:end])
    for l in 1:h
        for c in 1:w
            if (placedMap[l, c] == 0)
                return true
            end
        end
    end

    return false
end

function paidByAdv(sol, a, placedMap)
    total = 0
    for l in 1:sol.inst.h
        for c in 1:sol.inst.w
            if (placedMap[l, c] == a)
                total += sol.inst.ω[l][c]
            end
        end
    end

    return total
end

function hasFreeAdv(sol, placedMap)
    for a in 1:sol.inst.n
        # print("=== ")
        # print(a)
        # print(" ")
        # print(countCaseForAdv(a, placedMap))
        # print(" ")
        # print(sol.inst.ha[a] * sol.inst.wa[a])
        # println("")
        if (!is_placed(sol, a) &&
            paidByAdv(sol, a, placedMap) < sol.inst.ma[a] &&
            countCaseForAdv(a, placedMap) < sol.inst.ha[a] * sol.inst.wa[a])
            # print("@@@@@ ")
            # print(a)
            # println("")
            return true
        end
    end

    return false
end

function countCaseForAdv(a, placedMap)
    count = 0
    h = length(placedMap[1:end, 1])
    w = length(placedMap[1, 1:end])
    for l in 1:h
        for c in 1:w
            if (placedMap[l, c] == a)
                count += 1
            end
        end
    end

    return count
end

function upperBound(sol::Solution)
    placedMap = zeros(Int, sol.inst.h, sol.inst.w)
    for a in 1:sol.inst.n
        posA = place_of(sol, a)
        if (posA != (nothing, nothing))
            for la in 1:sol.inst.ha[a]
                for ca in 1:sol.inst.wa[a]
                    placedMap[posA[1] + la - 1, posA[2] + ca - 1] = a
                end
            end
        end
    end

    println("=================")
    for l in 1:sol.inst.h
        for c in 1:sol.inst.w
            print(placedMap[l, c])
            print(" ")
        end
        println("")
    end

    bound = 0
    while (hasFreeAdv(sol, placedMap) && hasUnsoldCase(placedMap))
        best = 0
        bestA = nothing
        bestL = nothing
        bestC = nothing

        for a in 1:sol.inst.n
            for l in 1:sol.inst.h
                for c in 1:sol.inst.w
                    if (countCaseForAdv(a, placedMap) < sol.inst.ha[a] * sol.inst.wa[a] && placedMap[l, c] == 0)
                        budgetUsed = paidByAdv(sol, a, placedMap)
                        newBest = min(sol.inst.ma[a] - budgetUsed, sol.inst.ω[l][c])
                        if newBest > best
                            # println("< BEST")
                            # println(newBest)
                            # println(a)
                            # println(l)
                            # println(c)
                            # println("BEST >")
                            best = newBest
                            bestA = a
                            bestL = l
                            bestC = c
                        end
                    end
                end
            end
        end
        # println("< PLACE ")
        # println(best)
        # println(bestA)
        # println(bestL)
        # println(bestC)
        # println("PLACE >")
        placedMap[bestL, bestC] = bestA
        bound += best
    end

    println("°°°°°°°°°°°°°°°°°")
    for l in 1:sol.inst.h
        for c in 1:sol.inst.w
            print(placedMap[l, c])
            print(" ")
        end
        println("")
    end
    println("°°°°°°°°°°°°°°°°°")
    for l in 1:sol.inst.h
        for c in 1:sol.inst.w
            print(sol.inst.ω[l][c])
            print(" ")
        end
        println("")
    end
    println("°°°°°°°°°°°°°°°°°")
    println(bound + profit(sol))
    println("=================")

    return bound + profit(sol)
end