#!/usr/bin/env julia

home = homedir()
namespace = "pandola"
target = pwd()

# Main call.
main() = begin
    file_name = "index.css"
    pcs_dist_path = "$home/$namespace/pcs/dist/$file_name"
    target_file = "$target/$file_name"

    if target_file |> isfile
        rm(target_file)
        println("\nOK, Clear done.\n")
    else
        println("\nOK, No need to clear.\n")
    end
end

main()
 
