#!/usr/bin/env julia

home = homedir()
namespace = "pandola"
pcs_dist_path = "$home/$namespace/pcs/dist/"
pcs_build_in = readdir(pcs_dist_path)
target = pwd()

function check_exist(f)
    target_path = "$target/$f"
    return isfile(target_path)
end

function make_link(f)
    file_path = basename(f)
    from = "$pcs_dist_path$file_path"
    to = "$target/$file_path"
    println("Make Link:\n$from ->\n$to")
    symlink(from, to)
    println("OK\n")
end

function main()   
    
    result_checked = all(map(check_exist, pcs_build_in))
    
    if !result_checked
        println("OK, Checked done. Begin make links.\n")
        foreach(make_link, pcs_build_in)
    else
        println("Sorry, Files existed. Please use pandola-css-clear rm files.")
    end
end

# Main
main()
