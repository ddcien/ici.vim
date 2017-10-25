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
try:
    from urllib.request import urlopen
except ImportError:
    from urllib2 import urlopen
from xml.dom import minidom

KEY = 'E0F0D336AF47D3797C68372A869BDBC5'
URL = 'http://dict-co.iciba.com/api/dictionary.php'


def get_response(word):
    return urlopen(URL + '?key=' + KEY + '&w=' + word)


def read_xml(xml):
    dom = minidom.parse(xml)
    return dom.documentElement


def show(node):
    if not node.hasChildNodes():
        if node.nodeType == node.TEXT_NODE and node.data != '\n':
            tag_name = node.parentNode.tagName
            content = node.data.replace('\n', '')
            if tag_name == 'ps':
                print(content)
                print('---------------------------')
            elif tag_name == 'orig':
                print(content)
            elif tag_name == 'trans':
                print(content)
                print('---------------------------')
            elif tag_name == 'pos':
                print(content)
            elif tag_name == 'acceptation':
                print(content)
                print('---------------------------')
    else:
        for e in node.childNodes:
            show(e)


show(read_xml(get_response(vim.eval("l:word"))))
EOF
endfunction

command! -nargs=* Ici     :call Ici(<q-args>)
command! -nargs=0 IciFrom :call Ici(<q-args>)
