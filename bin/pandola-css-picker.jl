#!/usr/bin/env julia

home = homedir()
namespace = "pandola"

find_file(x) = begin
    (root, dirs, files) = x
    map(a -> "$root/$a", files)
end

ff = map(find_file, walkdir("$home/$namespace/bin/testdir"))

#strArr = reduce(append!, [], ff) |> println

strArr = map(x -> open(readall, x), reduce(append!, [], ff))
    
re = r"class=\"?\'?([\w-\s]+)\"?\'?"

pick_class(re, str) = begin
    next_class(rm, acc = []) = begin
        if rm == nothing
            return acc;
        else
            next_class(match(re, str, rm.offset + 1), push!(acc, rm.match))
        end
    end

    next_class(match(re, str, 1))
end
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
            push!(acc, x)
        end
    end
    foreach(y -> fill_acc(acc, y), x)
    acc
end

res = pick_class(re, reduce(string, strArr))
res1 = reduce(reduce_class, [], map(find_class, res)) |> sort #|> println
println("\nFound $(length(res1)) roles.")

map(x -> println(x), res1)


css = open(readall, "index.css")
css_content = "a-z0-9\"\'"
css_symbol = "#\\(\\)\\!π\\.%-:,;"
css_comment = "\\*\\/"
css_space = "\\n\\t\\s"
cons_re(classname) = begin
    role = "\\.$classname[:a-z,\\s]*.*\\s*"
    content = "{[$css_content$css_symbol$css_comment$css_space]*}"
    Regex("$role$content", "i")
end 
#res2 = map(x -> cons_re(x), res1)
res2 = map(x -> match(cons_re(x), css, 1), res1)
println("\n")
map(x -> println(x), res2)

concat_style(acc, curr) = begin
    if curr != nothing
        acc * curr.match * "\n\n"
    else
        acc
    end
end
reduce(concat_style, "", res2) |> println

