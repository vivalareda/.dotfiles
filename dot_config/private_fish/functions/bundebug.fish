function bundebug --description "Run bun --inspect-brk on a file and open the debugger URL in browser"
    if test (count $argv) -eq 0
        echo "Usage: bundebug <file>"
        return 1
    end

    set file $argv[1]

    if not test -f $file
        echo "Error: file '$file' not found"
        return 1
    end

    echo "Starting bun debugger for $file..."

    set -l opened 0

    bun --inspect-brk $file 2>&1 &| while read -l line
        echo $line
        if test $opened -eq 0; and string match -q -- "*https://debug.bun.sh/*" $line
            set url (string match -r -- 'https://debug\.bun\.sh/#[^\s]+' $line)
            if test -n "$url"
                echo "Opening: $url"
                open $url
                set opened 1
            end
        end
    end
end
