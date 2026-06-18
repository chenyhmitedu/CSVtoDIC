module CSVtoDIC

using CSV, DataFrames

"""
    source(name::String)

Read the source CSV files in path "name" and return dictionaries.

In the example below, each CSV file in ./data is a parameter or set of GTAP 9. The data are
filtered and aggregated by GTAPinGAMS and are converted from GDX to CSV format outside this
package.

source("./data")[1] returns parameters, 
and source("./data")[2] returns sets. 



# Arguments
- `name::String`: the path to CSV files using slash rather than backslash.

# Examples
```julia-repl
julia> using CSVtoDIC

julia> source
source (generic function with 1 method)

julia> source("./data")
(Dict{Any, Any}("esubd" => Dict(:omt => 4.40000009536743, ... ), ..., "set_f" => [:lnd, :lab, :cap, :fix]))

julia> source("./data")[1]
Dict{Any, Any} with 22 entries:
  "esubd"   => Dict(:omt=>4.4, :ofi=>1.9, :ppp=>2.95, :mil=>3.65, :gro=>1.3, :c_b=>2.7, …)
  "vfm"     => Dict((:lab, :osd, :USA)=>7.40317, ..., (:lab, :fsh, :USA)=>1.133, …)
[...]

julia> source("./data")[2]
Dict{Any, Any} with 4 entries:
  "set_i" => [:isr, :obs, :ros, :osg, :dwe, :pdr, :wht, :gro, :v_f, :osd  …  :ofi]
  "set_r" => [:USA, :ROW]
  "set_g" => [:isr, :obs, :ros, :osg, :dwe, :pdr, :wht, :gro, :v_f, :osd  …  :i]
  "set_f" => [:lnd, :lab, :cap, :fix]

```
"""
function source(name::String)  
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

export source, fullspace

end # module CSVtoDIC
