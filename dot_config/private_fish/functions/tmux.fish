function tmux --wraps=tmux --description 'Tmux wrapper: pick or create a session with fzf'
    if test (count $argv) -eq 0
        # Get existing sessions
        set -l sessions (command tmux list-sessions -F "#{session_name}" 2>/dev/null)

        if test (count $sessions) -gt 0
            # Existing sessions: let user pick one or type a new name
            set -l choice (begin
                echo ":: new session ::"
                for s in $sessions
                    echo $s
                end
            end | fzf --prompt="pick a session homie: " --height=40%)

            if test -z "$choice"
                return 1
            end

            if test "$choice" = ":: new session ::"
                read -P "wus the session name homie? " session_name
                if test -z "$session_name"
                    echo "Session name cannot be empty" >&2
                    return 1
                end
                command tmux new-session -s "$session_name"
            else
                command tmux attach-session -t "$choice"
            end
        else
            # No sessions: prompt for a name
            read -P "wus the session name homie? " session_name
            if test -z "$session_name"
                echo "Session name cannot be empty" >&2
                return 1
            end
            command tmux new-session -s "$session_name"
        end
    else
        command tmux $argv
    end
end
