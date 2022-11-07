 lsof | awk '{print $2}' | grep -Ei '[0-9]' | xargs kill -9
