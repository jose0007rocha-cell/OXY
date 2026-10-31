case "$SHELL" in
  */zsh)
    if command -v fzf >/dev/null 2>&1 && command -v fd >/dev/null 2>&1; then
      
      export FZF_DEFAULT_OPTS=" \
        --color fg:#ffffff,bg:#222222,hl:#98c379,fg+:#ffffff,bg+:#222222,hl+:#98c379,prompt:#61afef,pointer:#e5c07b,marker:#56b6c2 \
        --ansi --reverse --no-info --no-scrollbar \
        --pointer=' '"

      # =========[ File Insert Widget: Alt+T ]=========
      fzf-file-widget() {
        local result
        result=$(fd -H -t f -E .git | \
          fzf --prompt="Select file ➤ " --exit-0 \
              --height=40% --border --reverse \
              --ansi --no-info --no-scrollbar \
        )
        local ret=$?

        if (( ret == 0 )) && [[ -n "$result" ]]; then
          LBUFFER+="$result"
        fi

        zle reset-prompt
      }
      zle -N fzf-file-widget
      bindkey '^[t' fzf-file-widget

      # =========[ Directory CD Widget: Alt+C ]=========
      fzf-cd-widget() {
        local dir
        dir=$(fd -H -t d -E .git | \
          fzf --prompt="Select directory ➤ " --exit-0 \
              --height=40% --border --reverse \
              --ansi --no-info --no-scrollbar \
        )
        local rc=$?

        if (( rc == 0 )) && [[ -n "$dir" ]]; then
          cd "$dir" || return
        fi

        zle reset-prompt
      }
      zle -N fzf-cd-widget
      bindkey '^[c' fzf-cd-widget

      # =========[ History Search Widget: Ctrl+R ]=========
      fzf-history-widget() {
        local selected
        selected=$(fc -l 1 | \
          fzf --tac --no-sort --reverse \
              --prompt="History ➤ " --exit-0 \
              --height=40% --border \
              --ansi --no-info --no-scrollbar \
          | sed -E 's/^[[:space:]]*[0-9]+\s*//')

        local rc=$?

        if (( rc == 0 )) && [[ -n "$selected" ]]; then
          LBUFFER="$selected"
        fi

        zle reset-prompt
      }
      zle -N fzf-history-widget
      bindkey '^R' fzf-history-widget

    fi
    ;;
esac
# =========[ fzf Completion Setup ]=========

if command -v fzf >/dev/null 2>&1; then
  case "$SHELL" in
    */zsh)
      # Ensure completion system is initialized
      fpath+=~/.zfunc
      autoload -Uz compinit
      compinit

      # Install/update fzf zsh completion if missing
      if [ ! -f ~/.zfunc/_fzf ]; then
        mkdir -p ~/.zfunc
        fzf --zsh > ~/.zfunc/_fzf
      fi
      ;;

    # */bash)
    #   # Load global bash-completion if available
    #   if [ -f $PREFIX/share/fzf/completion.bash ]; then
    #     . $PREFIX/share/fzf/completion.bash
    #   fi
    #
    #   # Load fzf bash completion (inline)
    #   source <(fzf --bash)
    #   ;;
  esac
fi
# =========[ OXY banner ]=========
# O desenho (moldura, logo, letras) vive em: ~/.config/theader/lib/oxybanner
# (instalado como comando global: oxy-banner)
banner() {
  clear
  if command -v oxy-banner >/dev/null 2>&1; then
    oxy-banner
  fi
}
