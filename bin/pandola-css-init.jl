#!/usr/bin/env julia

home = homedir()
namespace = "pandola"
target = pwd()

# Main call.
main() = begin
    file_name = "index.css"
    pcs_dist_path = "$home/$namespace/pcs/dist/$file_name"
    target_file = "$target/$file_name"
    
    if target_file |> isfile |> !
        println("\nOK, Checked done.\n")
        println("Make Link:\n$pcs_dist_path ->\n$target_file")
        symlink(pcs_dist_path, target_file)
        println("\nOK!\n")
    else
        println("\nSorry, Files existed. Please use pandola-css-clear remove files.\n")
    end
end

main()
