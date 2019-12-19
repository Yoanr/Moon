function printSolution(sol::Solution)
    for a in 1:sol.inst.n
        print(a)
        print(" ")
        if (sol.la[a] == nothing)
            print("/")
        else
            print(sol.la[a])
        end
        print(" ")
        if (sol.ca[a] == nothing)
            print("/")
        else
            print(sol.ca[a])
        end
        println("")
    end

    print("Profit ")
    print(profit(sol))
    println("")
end