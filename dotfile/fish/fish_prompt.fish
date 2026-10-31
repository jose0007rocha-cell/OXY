function fish_prompt
    # prompt com degrade vindo de: oxy-banner --prompt ansi (montado 1 vez por sessao)
    if not set -q __oxy_prompt
        if type -q oxy-banner
            set -g __oxy_prompt (command oxy-banner --prompt ansi 2>/dev/null | string collect)
        end
        if test -z "$__oxy_prompt"
            set -g __oxy_prompt (printf '\n┏━━[ Termux ]·····[ Oxy ]━━━>\n┗━━❯❯❯')
        end
    end
    printf '%s ' $__oxy_prompt
end
