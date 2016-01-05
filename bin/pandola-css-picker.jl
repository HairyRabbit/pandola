#!/usr/bin/env julia

str = """
<div class="u-clearfix s-sb1 s-red-100">
  <div class="o-col o-col-2"></div>
  <div class="o-col o-col-3"></div>
  <div class="o-col o-col-4"></div>
</div>
"""
str = open(readall, "index.html")
    
re = r"class=\"?\'?([\w-\s]+)\"?\'?"

function pick_class(rm, acc = [])
    if rm == nothing
        return acc;
    else
        pick_class(match(re, str, rm.offset + 1), push!(acc, rm.match))
    end
end

res = pick_class(match(re, str, 1))

res1 = map(x -> x.captures[1], map(x -> match(re, x), res))
println(res1)
