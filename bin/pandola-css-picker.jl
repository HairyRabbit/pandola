#!/usr/bin/env julia

#Pkg.add("AnsiColor")

str = open(readall, "index.html")
    
re = r"class=\"?\'?([\w-\s]+)\"?\'?"
#
function pick_class(rm, acc = [])
    if rm == nothing
        return acc;
    else
        pick_class(match(re, str, rm.offset + 1), push!(acc, rm.match))
    end
end

res = pick_class(match(re, str, 1))

match_class(x) = match(re, x).captures[1]
split_class(x) = split(x, r"\s")
find_class(x) = x |> match_class |> split_class
reduce_class(acc, x) = begin    
    fill_acc(acc, x) = begin
        if x == "" || x ∈ acc
            print("OK, find -> \"$x\". But existed. ")
            print("\e[0;33;49mSkip\e[0m\n")
            acc
        else
            print("OK, find -> \"$x\". ")
            print("\e[0;32;49mThunk\e[0m\n")
            push!(acc, x);
        end
    end
    foreach(y -> fill_acc(acc, y), x)
    acc
end

res1 = reduce(reduce_class, [], map(find_class, res)) |> sort # |> println
