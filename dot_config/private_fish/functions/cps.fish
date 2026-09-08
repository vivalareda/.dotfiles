function cps
    set host lilflare@192.168.2.29

    ssh $host 'cliphist list | head -n1 | cliphist decode' | pbcopy

    if test $pipestatus[1] -eq 0
        echo "Remote clipboard copied to Mac clipboard!"
    else
        echo "Failed to read remote clipboard."
        return 1
    end
end
