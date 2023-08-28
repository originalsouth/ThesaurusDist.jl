module ThesaurusDist

include("Word.jl")
include("Data.jl")

synonyms(str::String) = union(synonyms.(haskey(data, nrm(str)) ? data[nrm(str)] : [])..., [])
function synonyms(str::String, n::Integer)
    retval = synonyms(str)
    buffer = retval
    for _ in 1:n-1
        buffer = vcat(synonyms.(buffer)...)
        append!(retval, buffer)
    end
    return retval
end

include("Dist.jl")

end
