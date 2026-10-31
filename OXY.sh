#!/data/data/com.termux/files/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"
szf="File Size of"
tsize=$(stty size | cut -d ' ' -f 2)
pkgsize=$(apt-cache pkgnames | wc -l)

FILES=(pbanner progress fmenu confzsh)

for f in "${FILES[@]}"; do
  if [[ -f "$LIB_DIR/$f" ]]; then
    . "$LIB_DIR/$f"
  else
    echo "Warning: $LIB_DIR/$f not found"
  fi
done
# ===== Parse Termux color theme from ~/.termux/colors.properties =====
conf() {
  export FZF_DEFAULT_OPTS=""
  COLOR_FILE="$HOME/.termux/colors.properties"

  if [[ -f "$COLOR_FILE" ]]; then
    declare -A color
    while IFS='=' read -r key value; do
      [[ $key =~ ^#.*$ || -z $key ]] && continue
      color[$key]="$value"
    done <"$COLOR_FILE"

    export FZF_DEFAULT_OPTS="--color=fg:${color[foreground]},bg:${color[background]},hl:${color[color4]},fg+:${color[foreground]},bg+:${color[color0]},hl+:#98c379,prompt:#61afef,pointer:#e5c07b,marker:#56b6c2  --reverse --height=10 --no-info --pointer=' '"
  else
    export FZF_DEFAULT_OPTS="--color=hl+:#98c379,prompt:#61afef,pointer:#e5c07b,marker:#56b6c2 --reverse --height=10 --no-info --pointer=' '"
  fi
}

install_packages() {
  # lista de pacotes (o banner OXY agora usa so bash + tput, sem figlet/boxes/lolcat)
  packages=(curl fd gum bat logo-ls eza zsh ncurses-utils git unzip)

  echo -e "\n[🔧] Instalando pacotes necessarios...\n"

  for pkg in "${packages[@]}"; do
    # ncurses-utils fornece o tput; o comando de teste e diferente do nome do pacote
    case "$pkg" in
      ncurses-utils) cmd=tput ;;
      *) cmd="$pkg" ;;
    esac
    if command -v "$cmd" >/dev/null 2>&1; then
      echo "[✔] $pkg ja instalado"
    else
      echo "[➕] Instalando $pkg ..."
      pkg install -y "$pkg"
    fi
  done

  # Nerd Font (UbuntuMono) para os icones do prompt
  nerdflink="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/UbuntuMono.zip"
  FONT_DIR="$HOME/.termux"
  mkdir -p "$FONT_DIR"
  TMPD=$(mktemp -d)

  echo "[➕] Baixando Nerd Font (UbuntuMono)..."
  if curl -fL "$nerdflink" -o "$TMPD/UbuntuMono.zip"; then
    unzip -p "$TMPD/UbuntuMono.zip" "UbuntuMonoNerdFontMono-Regular.ttf" >"$FONT_DIR/font.ttf"
    echo "[✔] Fonte instalada em $FONT_DIR/font.ttf"
    echo "[ℹ] Reinicie o app Termux para aplicar a fonte."
  else
    echo "[✘] Falha ao baixar a fonte (sem internet?). O prompt funciona, so os icones podem faltar."
  fi
  rm -rf "$TMPD"
}

# Run function
menu_main() {

  while true; do
    conf
    banner > ${user}
    cat "${user}"
    echo ""
    choice=$(
      printf "1. Install packages\n2. Setup\n3. Exit" |
        fzf --prompt="Use ↑/↓ to navigate, Enter to select: " --exit-0
    )

    case $choice in
      "1. Install packages")
        echo -e "\033[1;32m[✔] Installing packages...\033[0m"
        install_packages
        sleep 1
        ;;
      "2. Setup")
        menu_setup
        ;;
      "3. Exit")
        echo -e "\033[1;31m[✘] Exiting...\033[0m"
        break
        ;;
      *)
        break
        ;;
    esac
  done
}

menu_setup() {
  choice=$(
    printf "1. Zsh\n2. Fish (coming soon)" |
      sed 's/2\. Fish (coming soon)/2. Fish \x1b[31m(\x1b[33mcoming soon\x1b[31m)\x1b[0m/' |
      fzf --prompt="Setup option ➤ " --ansi --exit-0
  )

  case $choice in
    "1. Zsh")
      menu_zsh_setup
      # echo -e "\033[1;34m[ℹ] Setting up Zsh...\033[0m"
      sleep 1
      ;;
    "2. Fish (coming soon)")
      echo -e "\033[1;33m[⚠] Fish setup is coming soon!\033[0m"
      sleep 1
      ;;
  esac
}

menu_zsh_setup() {
  # Check if oh-my-zsh is installed
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    # Not installed → only show setup option
    local subchoice
    subchoice=$(
      printf "1. Install Oh-my-zsh" |
        fzf --prompt="Zsh Setup ➤ " --ansi --exit-0
    )
    case $subchoice in
      "1. Install Oh-my-zsh")
        echo -e "\033[1;32m[✔] Installing Oh-my-zsh...\033[0m"
        install_oh_my_zsh
        chsh -s zsh
        ;;
    esac
  else
    # Already installed → show main options
    local main_options="1. Oh-my-zsh (Plugins Manager)\n2. Theader setup"

    local subchoice
    subchoice=$(
      printf "%b" "$main_options" |
        fzf --prompt="Zsh Options ➤ " --ansi --exit-0
    )

    case $subchoice in
      "1. Oh-my-zsh (Plugins Manager)")
        # Plugins Manager submenu
        local plugin_line
        plugin_line=$(sed -n 's/^plugins=(\(.*\))/\1/p' "$ZSHRC" | tr -d ' ')

        local pm_options="1. Add Zsh Plugins"
        # Show remove option only if plugins exist
        if [[ -n "$plugin_line" ]]; then
          pm_options+="\n2. Remove Plugins"
        fi

        local pm_choice
        pm_choice=$(
          printf "%b" "$pm_options" |
            fzf --prompt="Plugins Manager ➤ " --ansi --exit-0
        )

        case $pm_choice in
          "1. Add Zsh Plugins")
            echo -e "\033[1;34m[ℹ] Opening Add Plugins...\033[0m"
            fzf_add_plugin
            ;;
          "2. Remove Plugins")
            echo -e "\033[1;31m[⚠] Removing Zsh Plugins...\033[0m"
            remove_zsh_plugin
            ;;
        esac
        ;;
      "2. Theader setup")
        echo -e "\033[1;36m[ℹ] Running Theader setup...\033[0m"
        # Your Theader setup logic
        menu_theader_setup
        ;;
    esac
  fi
}

# t-header setup
menu_theader_setup() {
  local theader_dir="$HOME/.config/theader"

  # Check if Theader is installed (directory exists)
  if [[ ! -d "$theader_dir" ]]; then
    # Not installed → only show setup option
    local subchoice
    subchoice=$(
      printf "1. Setup Theader" |
        fzf --prompt="Theader Setup ➤ " --ansi --exit-0
    )
    case $subchoice in
      "1. Setup Theader")
        echo -e "\033[1;32m[✔] Setting up Theader...\033[0m"
        setup_theader
        ;;
    esac
  else
    # Already installed → show options
    local main_options="1. Change Logo\n2. Change Title\n3. Change Keyboard\n4. Change ZSH Theme\n5. Change Prompt Name\n6. Change Colors\n7. Remove Theader"

    local subchoice
    subchoice=$(
      printf "%b" "$main_options" |
        fzf --prompt="Theader Options ➤ " --ansi --exit-0
    )

    case $subchoice in
      "1. Change Logo")
        echo -e "\033[1;34m[ℹ] Changing Logo...\033[0m"
        c_logo
        ;;
      "2. Change Title")
        echo -e "\033[1;34m[ℹ] Changing Title...\033[0m"
        type_title
        ;;
      "3. Change Keyboard")
        echo -e "\033[1;34m[ℹ] Changing Keyboard Layout...\033[0m"
        key_properties
        ;;
      "4. Change ZSH Theme")
        echo -e "\033[1;34m[ℹ] Changing ZSH Theme...\033[0m"
        c_theme
        ;;
      "5. Change Prompt Name")
        echo -e "\033[1;34m[ℹ] Changing prompt name...\033[0m"
        c_name
        ;;
      "6. Change Colors")
        echo -e "\033[1;34m[ℹ] Changing gradient colors...\033[0m"
        c_cor
        ;;
      "7. Remove Theader")
        echo -e "\033[1;31m[⚠] Removing Theader...\033[0m"
        remove_theader
        ;;
    esac
  fi
}
# theader setup function
setup_theader() {
  theader_dir="$HOME/.config/theader"
  TEMPLATE="$ZSH/templates/zshrc.zsh-template"

  if [ -f "$ZSHRC" ]; then
    # line count check
    line_count=$(wc -l <"$ZSHRC")
    line_104=$(sed -n '104p' "$ZSHRC")

    if [ "$line_count" -gt 104 ] && [[ "$line_104" != *"oh-my-zsh"* ]]; then
      echo "⚠️  .zshrc tem $line_count linhas e a 104 nao tem 'oh-my-zsh', criando backup..."
      cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d%H%M%S)"

      old_plugins=$(grep "^plugins=" "$ZSHRC" | head -n1)

      cp "$TEMPLATE" "$ZSHRC"
      if [ -n "$old_plugins" ]; then
        echo "🔗 Plugins antigos mantidos: $old_plugins"
        sed -i "s/^plugins=(git)/$old_plugins/" "$ZSHRC"
      fi
    else
      echo ".zshrc ok, sem necessidade de reset."
    fi
  else
    cp "$TEMPLATE" "$ZSHRC"
    sed -i 's/plugins=(git)/plugins=()/' "$ZSHRC"
    echo "✅ .zshrc padrao criado"
  fi

  # --- arquivos de configuracao do OXY ---
  mkdir -p "$theader_dir"
  rm -rf "$theader_dir/logo" # tira os logos antigos (melancia, dragao...)
  for d in bin logo tpt lib; do
    if [[ -e "$SCRIPT_DIR/$d" ]]; then
      cp -r "$SCRIPT_DIR/$d" "$theader_dir/"
    else
      echo "Aviso: faltando $SCRIPT_DIR/$d"
    fi
  done
  # nao sobrescreve o nome/titulo que a pessoa ja escolheu
  if [[ ! -f "$theader_dir/theader.cfg" ]]; then
    cp "$SCRIPT_DIR/theader.cfg" "$theader_dir/theader.cfg"
  fi

  # se o logo escolhido antes nao existe mais, volta para o padrao
  cur_logo=$(sed -n 's/^logo=//p' "$theader_dir/theader.cfg" | tail -n1)
  if [[ ! -f "$theader_dir/logo/$cur_logo" ]]; then
    sed -i '/^logo=/d' "$theader_dir/theader.cfg"
    printf 'logo=losango.txt\n' >>"$theader_dir/theader.cfg"
  fi

  # banner como comando global
  install -Dm755 "$theader_dir/lib/oxybanner" "$PREFIX/bin/oxy-banner"

  # tema (cria e ja ativa ZSH_THEME="oxy")
  create_custom_theme oxy

  # dotfiles (arquivos explicitos: o antigo "cp .*" copiava . e ..)
  cp "$SCRIPT_DIR/dotfile/.profile" "$HOME/.profile"
  cp "$SCRIPT_DIR/dotfile/.aliases" "$HOME/.aliases"

  # abrir mais rapido: desliga a checagem de update do oh-my-zsh (faz git/rede na abertura)
  if ! grep -q "^zstyle.*omz:update" "$ZSHRC"; then
    sed -i '0,/^source \$ZSH\/oh-my-zsh.sh/s//zstyle ":omz:update" mode disabled\nsource $ZSH\/oh-my-zsh.sh/' "$ZSHRC"
  fi

  # linhas do .zshrc: so uma vez, sempre em linha nova
  if ! grep -q "oxy-banner" "$ZSHRC"; then
    {
      printf '\n# --- OXY ---\n'
      printf 'HISTSIZE=100000\nSAVEHIST=100000\nexport USER=$(whoami)\n'
      printf '[[ -o interactive ]] && command -v oxy-banner >/dev/null 2>&1 && { clear; oxy-banner; }\n'
    } >>"$ZSHRC"
  fi
  if ! grep -qs "profile source" "$HOME/.zprofile"; then
    printf '\n# profile source\nsource "$HOME/.profile"\n' >>"$HOME/.zprofile"
  fi

  mkdir -p "$HOME/.termux"
  if [[ -f $SCRIPT_DIR/colors.properties ]]; then
    cp "$SCRIPT_DIR/colors.properties" "$HOME/.termux/"
  fi

  if [[ -f $theader_dir/bin/theader ]]; then
    install -Dm700 "$theader_dir/bin/theader" "$PREFIX/bin/theader"
    for i in clogo ctitle cname ccor ctpro cztheme; do
      ln -sfr "$PREFIX/bin/theader" "$PREFIX/bin/$i"
    done
    echo "theader instalado ✅  (comandos: clogo ctitle cname ccor ctpro cztheme)"
  else
    echo "Erro: $theader_dir/bin/theader nao encontrado!"
  fi
  termux-reload-settings 2>/dev/null || true
}
remove_theader() {
  rm -rf "$HOME/.config/theader"
  rm -f "$PREFIX/bin/theader" "$PREFIX/bin/oxy-banner"
  for i in clogo ctitle cname ccor ctpro cztheme; do rm -f "$PREFIX/bin/$i"; done
  rm -f "$ZSH_CUSTOM/themes/oxy.zsh-theme"
  if [[ -f "$ZSHRC" ]]; then
    sed -i '/^# --- OXY ---$/,/oxy-banner/d' "$ZSHRC"
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' "$ZSHRC"
  fi
  echo -e "\033[1;32m[✔] OXY removido.\033[0m"
}
# packages list must above 2000
if ((pkgsize < 2000)); then
  echo -ne "\033[31m\r[*] \033[4;32mPackage Update and Upgrade or change repo \e[0m\n"
  exit 1
fi
# ✅ Check fzf installed or not
if ! command -v fzf >/dev/null 2>&1; then
  echo -e "\033[31m\r[*] \033[4;32mfzf command not found!\033[0m"
  echo -e "\033[1;33mPlease install fzf:\033[0m pkg install fzf -y\n"
  exit 1
fi

# Run main menu
menu_main
