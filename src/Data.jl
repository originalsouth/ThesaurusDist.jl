const data = let
    using JSON
    datafile = joinpath(@__DIR__, "en_thesaurus.jsonl")
    retval = Dict{String, Vector{Word}}()
    for jl in JSON.parse.(eachline(datafile))
        if haskey(retval, jl["word"])
            push!(retval[nrm(jl["word"])], Word(nrm(jl["word"]), nrm.(jl["synonyms"]), nrm(jl["pos"])))
        else
            push!(retval, nrm(jl["word"]) => Word[Word(nrm(jl["word"]), nrm.(jl["synonyms"]), nrm(jl["pos"]))])
        end
    end
    retval
end

