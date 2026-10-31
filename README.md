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
- Logos em blocos (`logo/*.txt`), todos pintados pelo **degradê** na hora (o `clogo` mostra a prévia colorida):
  - monogramas **JR**: `jr-escudo2`, `jr-coroa`, `jr-circulo`, `jr-v`, `jr-hex`, `jr-emblema`, `jr-chevron`;
  - formas: `losango` (padrão), `chama-a`, `gota-q`, `gota-a`;
  - escudos: `cyber`, `escudo-s`, `pico`, `asas`.
  Para criar o seu, faça um `.txt` de até 16 colunas x 8 linhas com blocos `▀▄▌▐▘▝▖▗▛▜▙▟█`.
- Moldura **mais fina** (3/8 de célula) com **degradê**, logo, letras, **prompt** e **selo de data/dia** (à direita) com degradê — tudo na mesma paleta (`neon` por padrão; também `fogo`, `verde`, `oceano`, `roxo`).
- Prompt: `┏━━[ Termux ]·····[ Oxy ]━━━>` / `┗━━❯❯❯` — os dois textos dos colchetes são editáveis (`cterm` e `cname`).
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
| `clogo`  | trocar o logo (escudos)                  |
| `ctitle` | trocar as letras grandes do banner (ex.: OXY) |
| `cname`  | trocar o nome do prompt (ex.: Oxy)       |
| `cterm`  | trocar o 1º rótulo do prompt (ex.: Termux) |
| `ctpro`  | trocar o termux.properties               |
| `ccor`   | trocar a paleta do degradê               |
| `cztheme`| trocar o tema do zsh                     |

Config: `~/.config/theader/theader.cfg` (`title=`, `TNAME=`, `TLABEL=`, `logo=`, `indent=`, `paleta=`, `frame=mid|thick|thin`).
Teste rápido do banner: `oxy-banner`.
