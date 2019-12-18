function copySolution(sol::Solution)
    newSol = Solution(sol.inst)
    for a in 1:sol.inst.n
        newSol.la[a] = sol.la[a]
        newSol.ca[a] = sol.ca[a]
    end
    return newSol
end