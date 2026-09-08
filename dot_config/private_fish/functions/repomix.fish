function repomix
  if test (count $argv) -eq 0
    command repomix --global; and rm -f ignore/repomix-output.xml 2>/dev/null
    if test -z "$(ls -A './ignore' 2>/dev/null)"
      command rm -rf ignore/
    end
  else
    command repomix $argv
  end
end
