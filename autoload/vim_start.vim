" Date Create: 2015-02-13 15:53:16
" Last Change: 2015-03-16 19:07:49
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:Buffer = vim_lib#sys#Buffer#
let s:Content = vim_lib#sys#Content#.new()
let s:File = vim_lib#base#File#
let s:Publisher = vim_lib#sys#Publisher#.new()

function! vim_start#render() " {{{
  " Не отображать окно в файле. {{{
  if !s:Content.isEmpty() || bufname('%') != ''
    syntax on " Иначе подсветка синтаксиса отключена
    return
  endif
  " }}}
  let l:buf = s:Buffer.current()
  call l:buf.temp()
  call l:buf.option('filetype', 'vim-start')
  function! l:buf.render() " {{{
    let l:result = ['" Start menu (Press ? for help) "']
    " Заголовок. {{{
    if type(g:vim_start#.header) != 3 || g:vim_start#.header != []
      if type(g:vim_start#.header) == 2
        let l:headerRes = g:vim_start#.header()
        if type(l:headerRes) == 1
          let l:header = split(l:headerRes, "\n")
        else
          let l:header = l:headerRes
        endif
      else
        let l:header = g:vim_start#.header
      endif
      let l:result += l:header
    endif
    " }}}
    " Тело. {{{
    let self.info = s:File.absolute(g:vim_start#.info).read()
    let l:i = 1
    for l:address in self.info
      call add(l:result, l:i . ']' . "\t" . l:address)
      let l:i += 1
    endfor
    let l:specialComm = [
                       \ '', 
                       \ 'e]' . "\t" . 'Open new buffer',
                       \ 'i]' . "\t" . 'Open new buffer and start insert mode',
                       \ 'E]' . "\t" . 'Edit menu',
                       \ 'q]' . "\t" . 'Quit',
                       \]
    let l:result += l:specialComm
    " }}}
    " Подвал. {{{
    if type(g:vim_start#.footer) != 3 || g:vim_start#.footer != []
      if type(g:vim_start#.footer) == 2
        let l:footerRes = g:vim_start#.footer()
        if type(l:footerRes) == 1
          let l:footer = split(l:footerRes, "\n")
        else
          let l:footer = l:footerRes
        endif
      else
        let l:footer = g:vim_start#.footer
      endif
      let l:result += l:footer
    endif
    " }}}
    return l:result
  endfunction " }}}

  call l:buf.map('n', '<Enter>', 'select')
  call l:buf.map('n', 'e', 'edit')
  call l:buf.map('n', 'i', 'insert')
  call l:buf.map('n', 'a', 'insert')
  call l:buf.map('n', 'E', 'editMenu')
  call l:buf.map('n', 'q', 'quit')
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
    let l:prj = self.info[expand('<cword>') - 1]
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
  function! l:buf.editMenu() " {{{
    enew
    exe 'e ' . g:vim_start#.info
    call self.delete()
    do BufNewFile
  endfunction " }}}
  function! l:buf.insert() " {{{
    enew
    call self.delete()
    do BufNewFile
    call s:Publisher.fire('VimStartEdit')
    startinsert
  endfunction " }}}
  function! l:buf.quit() " {{{
    q
  endfunction " }}}

  call l:buf.map('n', '?', 'showHelp')
  " Подсказки. {{{
  let l:buf.help = ['" Manual "',
                  \ '',
                  \ '" Enter - open project',
                  \ ''
                  \]
  " }}}
  function! l:buf.showHelp() " {{{
    if s:Content.line(1) != self.help[0]
      let self.pos = s:Content.pos()
      call s:Content.add(1, self.help)
    else
      call self.active()
      call s:Content.pos(self.pos)
    endif
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
