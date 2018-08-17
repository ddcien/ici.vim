let s:python_until_eof = "python3 << EOF"
if !has("python3")
  let s:python_until_eof = "python << EOF"
  if !has("python")
    echohl WarningMsg
    echom  "Ici requires py >= 2.7 or py3"
    echohl None
    unlet s:python_until_eof
    finish
  endif
endif

function! Ici(args)
    let l:word = empty(a:args) ? expand("<cword>") : a:args

  exec s:python_until_eof
import vim
import requests

KEY = 'E0F0D336AF47D3797C68372A869BDBC5'
URL = 'http://dict-co.iciba.com/api/dictionary.php'

def get_response(word: str):
    return requests.get(url=URL, params={'type': 'json', 'key': KEY, 'w': word.lower()}).json()

def show(res: dict):
    if 'word_name' not in res:
        return

    print('---------------------------------------')
    print("{}".format(res.get('word_name')))
    for symbol in res.get('symbols'):
        print('---------------------------------------')
        if 'word_symbol' in symbol:
            print('[{}]'.format(symbol.get('word_symbol')))
            for part in symbol.get('parts'):
                if 'means' not in part:
                    continue

                if not part.get('part_name'):
                    for i in part.get('means'):
                        print('    {}'.format(i.get('word_mean')))
                else:
                    print('    {} {}'.format(
                        part.get('part_name'),
                        '; '.join(p['word_mean'] for p in part.get('means'))))

        else:
            print('US:[{}] UK:[{}]'.format(
                symbol.get('ph_am'),
                symbol.get('ph_en'),
            ))
            for part in symbol.get('parts'):
                print('    {} {}'.format(
                    part.get('part'),
                    '; '.join(part.get('means')),
                ))
    print('---------------------------------------')
    print()

show(get_response(vim.eval("l:word")))
EOF
endfunction

command! -nargs=* Ici     :call Ici(<q-args>)
command! -nargs=0 IciFrom :call Ici(<q-args>)
