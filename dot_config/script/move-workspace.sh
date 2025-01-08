all_workspaces=$(echo "1 2 3 4 5 6 7 8 9 0 B D" | tr " " "\n")
workspace_to_move=$(echo -e $all_workspaces | fzf) 


