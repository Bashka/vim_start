set syntax=vim_lib-tmp

syntax sync fromstart
syntax match NumberPoint /^\zs[qieE0-9]\+\ze\]/
syntax match NumberPoint /^\zs\ze\]/
syntax match ProjectName /\/\zs[^\/\\]\+\ze$/
syntax match ProjectName /\\\zs[^\/\\]\+\ze$/

highlight default link ProjectName String
highlight default link NumberPoint Number
