function fish_prompt
    set -l config_file ~/.config/theader/theader.cfg
    set -l TNAME Oxy
    if test -f $config_file
        set -l name_from_cfg (string match -r '^TNAME=.*' (cat $config_file) | cut -d'=' -f2-)
        if test -n "$name_from_cfg"
            set TNAME $name_from_cfg
        end
    end

    set -l red (set_color -o red)
    set -l blue (set_color -o blue)
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l gray (set_color brblack)
    set -l reset (set_color normal)

    # linha 1:  ┏━━[ Termux ]·····[ Nome ]━━━>
    echo
    echo -n $red"┏━━["$cyan" Termux "$red"]"$gray"·····"$red"["$blue" $TNAME "$red"]━━━"$yellow">"$reset
    echo
    # linha 2:  ┗━━❯❯❯
    echo -n $red"┗━━❯"$blue"❯"$gray"❯"$reset" "
end
