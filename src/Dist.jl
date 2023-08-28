function dist(str1::String, str2::String)::Union{Int64, Missing, Nothing}
    if cmp(str1, str2)
        return 0
    elseif all(haskey.(Ref(data), (str1, str2)))
        blocklist::Vector{String} = []
        targets::Vector{String} = synonyms(str1)
        filter!(x -> haskey(data, x), targets)
        retval = 1
        while true
            if cin(str2, targets)
                return retval
            else
                blocklist = union(targets, blocklist)
                targets = setdiff(union(synonyms.(targets)..., []), blocklist)
                filter!(x -> haskey(data, x), targets)
                if isempty(targets)
                    return nothing
                else
                    retval += 1
                end
            end
        end
    else
        return missing
    end
end

function wordspace(str1::String, str2::String)::Union{Vector{String}, Missing, Nothing}
    if cmp(str1, str2)
        return 0
    elseif all(haskey.(Ref(data), (str1, str2)))
        blocklist::Vector{String} = []
        targets::Vector{String} = synonyms(str1)
        filter!(x -> haskey(data, x), targets)
        while true
            if cin(str2, targets)
                return sort(union([str1], targets, blocklist))
            else
                blocklist = union(targets, blocklist)
                targets = setdiff(union(synonyms.(targets)..., []), blocklist)
                filter!(x -> haskey(data, x), targets)
                if isempty(targets)
                    return nothing
                end
            end
        end
    else
        return missing
    end
end

function distmetric(str1::String, str2::String)::Union{Tuple{Matrix{Union{Int64, Missing, Nothing}}, Vector{String}}, Missing, Nothing}
    ws = wordspace(str1, str2)
    if ws isa Vector{String}
        retval::Matrix{Union{Int64, Missing, Nothing}} = Array{Union{Int64, Missing, Nothing}}(undef, length(ws), length(ws))
        for i in 1:length(ws)
            retval[i, i] = 0
            for j in 1:i-1
                value = dist(ws[i], ws[j])
                retval[i, j] = value
                retval[j, i] = value
            end
        end
        return (retval, ws)
    else
        return ws
    end
end
