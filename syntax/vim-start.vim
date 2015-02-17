syntax sync fromstart
syntax match NumberPoint /^\zs[qie0-9]\+\ze\]/
syntax match NumberPoint /^\zs\ze\]/
syntax match ProjectName /\/\zs[^\/\\]\+\ze$/
syntax match ProjectName /\\\zs[^\/\\]\+\ze$/

highlight ProjectName term=bold ctermfg=DarkRed

highlight default link NumberPoint Number
