" Date Create: 2015-02-13 15:51:11
" Last Change: 2015-03-01 12:58:21
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:Plugin = vim_lib#sys#Plugin#
let s:File = vim_lib#base#File#
let s:System = vim_lib#sys#System#.new()
let s:Publisher = vim_lib#sys#Publisher#.new()

let s:p = s:Plugin.new('vim_start', '1', {'plugins': ['vim_prj']})
"" {{{
" @var array|function Массив строк, которые будут записаны перед выводом меню. Если в качестве значения используется функция, ее результат будет записан перед выводом меню.
"" }}}
let s:p.header = []
"" {{{
" @var array|function Массив строк, которые будут записаны после вывода меню. Если в качестве значения используется функция, ее результат будет записан после вывода меню.
"" }}}
let s:p.footer = []
"" {{{
" @var string Абсолютный адрес до файла меню.
"" }}}
let s:p.plugDir = expand('<sfile>:p:h')

function! s:p.run() " {{{
  let self.info = self.plugDir . s:File.slash . 'vim_start' . s:File.slash . 'info'
  call s:System.au('VimEnter', function('vim_start#render'))

  call s:Publisher.listen('VimPrjCreate', function('vim_start#_addNewPrj'))
endfunction " }}}

call s:p.reg()
