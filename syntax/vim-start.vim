syntax sync fromstart
syntax match NumberPoint /^\[\zs\d\+\ze\]/
syntax match ProjectName /[^\/\\]\+$/

highlight ProjectName term=bold ctermfg=DarkRed

highlight default link NumberPoint Number
