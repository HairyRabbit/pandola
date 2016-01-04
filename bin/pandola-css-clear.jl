#!/usr/bin/env julia

home = homedir()
namespace = "pandola"
pcs_dist_path = "$home/$namespace/pcs/dist/"
pcs_build_in = readdir(pcs_dist_path)
target = pwd()

target_path = f -> "$target/$f"

function clear_file(path)
    rm(path)
    println("Clear \"$path\" done.")
end

function main()
    map(clear_file, filter(isfile, map(target_path, pcs_build_in)))
    println("Clear done.")    
end

main()
 
