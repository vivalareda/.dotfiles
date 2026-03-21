function killport --description 'Kill process on a given port'
    if test (count $argv) -eq 0
        echo "Usage: killport <port>" >&2
        return 1
    end

    set -l port $argv[1]
    set -l pids (lsof -ti:"$port" 2>/dev/null)

    if test (count $pids) -eq 0
        echo "No process found on port $port" >&2
        return 1
    end

    if test (count $pids) -eq 1
        kill -9 $pids[1]
        echo "Killed PID $pids[1] on port $port"
    else
        set -l choice (for pid in $pids
            set -l info (ps -p $pid -o pid=,comm=,args= 2>/dev/null)
            echo $info
        end | fzf --multi --prompt="Select process(es) to kill on port $port: " --height=40%)

        if test -z "$choice"
            return 1
        end

        for line in $choice
            set -l pid (string trim (string sub -l 10 -- $line))
            kill -9 $pid
            echo "Killed PID $pid"
        end
    end
end
