module CSVtoDIC

using CSV, DataFrames

export source, fullspace

function source(name::String = "./src/output/")  
    csv_files = filter(f -> endswith(f, ".csv"), readdir(name))
    n         = length(csv_files)
    dic_df    = Dict()
    dic_tmp   = Dict()
    d         = Dict()
    s         = Dict()

    # Convert dic_df (key => dataframe) into d (key => dictionary) for a dataframe with # column >= 2, and into s (vector) with # column < 2
    for i ∈ 1:n
        str_tmp = csv_files[i][1:end-4]
        dic_df[str_tmp]    = CSV.read(joinpath(name, csv_files[i]), DataFrame, delim=",")
        cols    = names(dic_df[str_tmp])
    
        if ncol(dic_df[str_tmp]) > 2
            dic_tmp = Dict(
                    Symbol.(Tuple(row[cols[1:end-1]])) => row[cols[end]]
                    for row in eachrow(dic_df[str_tmp])
                    )
            d[str_tmp]    = dic_tmp

        elseif ncol(dic_df[str_tmp]) == 2
            dic_tmp = Dict(
                    Symbol.(row[cols[1]]) => row[cols[2]]
                    for row in eachrow(dic_df[str_tmp])
                    )
            d[str_tmp]    = dic_tmp

        else
            s[str_tmp]    = Symbol.(Vector(dic_df[str_tmp][:, 1]))
        end 
    end
    return d, s
end

    # Fill up each missing key element with a (k, 0) 
function fullspace(dict::Dict, args...)
    key_space = collect(Iterators.product(args...))
    for k in key_space
        if !haskey(dict, k)
            dict[k] = 0
        end
    end
    return dict
end
function fullspace(dict::Dict, args)
    key_space = collect(args)
    for k in key_space
        if !haskey(dict, k)
            dict[k] = 0
        end
    end
    return dict
end


end # module CSVtoDIC
