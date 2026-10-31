# OXY — banner e prompt personalizados para o Termux

Base: T-Header (Remo773), reformulado.
Repositório: https://github.com/jose0007rocha-cell/OXY.git

```
▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜
▌  [logo]            ██████ ██  ██ ██  ██       ▐
▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟

┏━━[ Termux ]·····[ Oxy ]━━━>
┗━━❯❯❯
```

## O que mudou
- Logos novos: **escudo, espada, caveira, dragão** (`logo/*.txt`).
- Moldura **mais fina** (3/8 de célula) com **degradê**, letras de bloco com degradê e **prompt com degradê** — tudo na mesma paleta (`neon` por padrão; também `fogo`, `verde`, `oceano`, `roxo`).
- Prompt: `┏━━[ Termux ]·····[ Oxy ]━━━>` / `┗━━❯❯❯`.
- **Abre rápido**: o banner não faz nenhum `fork` e escreve tudo de uma vez (antes levava ~4 s por causa de um padrão `extglob` lento); o prompt é montado uma vez por sessão; a checagem de update do oh-my-zsh é desligada.
- **Teclado**: após trocar, o Termux recarrega as configurações e oferece reiniciar o app (algumas opções só valem depois disso).
- **Correções** (por que o nome não entrava): `fzf` retornando 1 + `set -e`; `sed` quebrando com `& | \ /`; fonte antiga sem minúsculas/acentos; `TNAME` sem comando para alterar; tema nunca ativado; `remove_theader` inexistente.

## Instalação
```bash
pkg update && pkg upgrade -y
pkg install git fzf -y
git clone https://github.com/jose0007rocha-cell/OXY.git
cd OXY
bash OXY.sh        # 1. Install packages  →  2. Setup → Zsh → ...
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
| `ccor`   | trocar a paleta do degradê               |
| `cztheme`| trocar o tema do zsh                     |

Config: `~/.config/theader/theader.cfg` (`title=`, `TNAME=`, `logo=`, `indent=`, `paleta=`, `frame=mid|thick|thin`).
Teste rápido do banner: `oxy-banner`.
