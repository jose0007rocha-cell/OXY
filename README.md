# OXY — banner e prompt personalizados para o Termux

Base: T-Header (Remo773), reformulado.

```
▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
▌  [logo]            ██████ ██  ██ ██  ██       ▐
▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

┏━━[ Termux ]·····[ Oxy ]━━━>
┗━━❯❯❯
```

## O que mudou
- Logos novos: **escudo, espada, caveira, dragão** (`logo/*.txt`). Os antigos (melancia etc.) foram removidos.
- Moldura **grossa** (meio-bloco) e letras em **blocos grossos**, sem depender de figlet/boxes/lolcat.
- Prompt: `┏━━[ Termux ]·····[ Oxy ]━━━>` com traços grossos; a pasta e a data ficam à direita.
- Novo comando **`cname`** para trocar o nome do prompt (`Oxy`).
- **Correções** (por que o nome não entrava):
  - o `fzf` sai com código 1 e o `set -e` do `bin/theader` matava o script antes de salvar → agora é tratado;
  - nomes com `& | \ /` quebravam o `sed` que gravava o config → agora grava sem `sed`;
  - o antigo `pixelfont` ignorava letras minúsculas/acentos → fonte própria (A–Z, 0–9, acentos viram letra simples);
  - o nome do prompt (`TNAME`) não tinha como ser alterado e vinha dentro de `%{ %}` (quebrava o cursor);
  - o tema nunca era ativado (`ZSH_THEME` ficava no padrão) → agora o instalador ativa `oxy`;
  - `remove_theader` era chamada mas não existia; `cp dotfile/.*` copiava `.` e `..`; `exit` dentro de funções fechava o menu.

## Instalação
```bash
pkg update && pkg upgrade -y
pkg install git fzf -y
unzip OXY-master.zip && cd OXY-master
bash t-header.sh        # 1. Install packages  →  2. Setup → Zsh → ...
```
Depois abra uma nova sessão (ou `source ~/.zshrc`).

## Comandos
| Comando  | Função                                   |
|----------|------------------------------------------|
| `theader`| menu geral                               |
| `clogo`  | trocar o logo (escudo/espada/caveira/dragão) |
| `ctitle` | trocar as letras grandes do banner (ex.: OXY) |
| `cname`  | trocar o nome do prompt (ex.: Oxy)       |
| `ctpro`  | trocar o termux.properties               |
| `cztheme`| trocar o tema do zsh                     |

Config: `~/.config/theader/theader.cfg` (`title=`, `TNAME=`, `logo=`, `indent=`).
Teste rápido do banner: `oxy-banner`.
