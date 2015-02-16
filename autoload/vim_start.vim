" Date Create: 2015-02-13 15:53:16
" Last Change: 2015-02-16 17:28:09
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:Buffer = vim_lib#sys#Buffer#
let s:Content = vim_lib#sys#Content#.new()
let s:System = vim_lib#sys#System#.new()
let s:File = vim_lib#base#File#
let s:Publisher = vim_lib#sys#Publisher#.new()

function! vim_start#render() " {{{
  " Не отображать окно в файле. {{{
  if bufname('%') != '' || s:Content.line(1) != ''
    syntax on " Иначе подсветка синтаксиса отключена
    return
  endif
  " }}}
  let l:buf = s:Buffer.current()
  call l:buf.temp()
  call l:buf.option('filetype', 'vim-start')
  let l:buf.info = s:File.absolute(g:vim_start#.info).read()
  let l:i = 0
  for l:address in l:buf.info
    call s:Content.add(l:i + 1, '[' . l:i . ']' . "\t" . l:address)
    let l:i += 1
  endfor
  normal Gdd
  call s:Content.pos({'l': 1, 'c': 2})

  call l:buf.map('n', '<Enter>', 'select')
  call l:buf.map('n', 'e', 'edit')
  call l:buf.map('n', 'h', 'null')
  call l:buf.map('n', 'l', 'null')
  call l:buf.map('n', 'w', 'null')
  call l:buf.map('n', 'e', 'null')
  call l:buf.map('n', 'b', 'null')
  call l:buf.map('n', 'W', 'null')
  call l:buf.map('n', 'E', 'null')
  call l:buf.map('n', 'B', 'null')
  call l:buf.map('n', '^', 'null')
  call l:buf.map('n', '$', 'null')

  function! l:buf.null() " {{{
  endfunction " }}}
  function! l:buf.select() " {{{
    let l:prj = self.info[expand('<cword>')]
    " Формирование истории проектов. {{{
    call remove(self.info, index(self.info, l:prj))
    call insert(self.info, l:prj, 0)
    call s:File.absolute(g:vim_start#.info).rewrite(self.info)
    " }}}
    exe 'cd ' . l:prj
    enew
    call self.delete()
    do BufNewFile
    call g:vim_prj#.run()
    call vim_prj#loadSession()
    call s:Publisher.fire('VimStartSelect', {'address': l:prj})
  endfunction " }}}
  function! l:buf.edit() " {{{
    enew
    call self.delete()
    do BufNewFile
    call s:Publisher.fire('VimStartEdit')
  endfunction " }}}
  call l:buf.active()
endfunction " }}}

function! vim_start#_addNewPrj(event) " {{{
  call vim_start#add(a:event['dirprj'])
endfunction " }}}

function! vim_start#add(dir) " {{{
  let l:info = s:File.absolute(g:vim_start#.info)
  call l:info.write(a:dir)
endfunction " }}}
