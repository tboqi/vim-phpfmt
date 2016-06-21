"=============================================================================
" File: phpfmt.vim
" Author: Carlos Cirello
" Inspired by: vim-php-cs-fixer

if exists("g:vim_phpfmt") || &cp
    finish
endif
let g:vim_phpfmt = 1


let g:phpfmt_update_on_open = get(g:, 'phpfmt_update_on_open', 1)
let g:phpfmt_on_save = get(g:, 'phpfmt_on_save', 1)
let g:phpfmt_php_path = get(g:, 'phpfmt_php_path', 'php')
let g:phpfmt_enable_default_mapping = get(g:, 'phpfmt_enable_default_mapping', '1')

let g:phpfmt_command = g:phpfmt_php_path.' '.expand('<sfile>:p:h').'/fmt.phar --no-backup'

if exists('g:phpfmt_config')
  let g:phpfmt_command = g:phpfmt_command.' --config='.g:phpfmt_config
endif

fun! PhpFmtFix(path)
    let command = g:phpfmt_command

    if exists('g:phpfmt_passes_list')
        let command = command.' --passes='.g:phpfmt_passes_list
    endif

    if exists('g:phpfmt_prepasses_list')
        let command = command.' --prepasses='.g:phpfmt_prepasses_list
    endif

    if exists('g:phpfmt_exclude_list')
        let command = command.' --exclude='.g:phpfmt_exclude_list
    endif

    if exists('g:phpfmt_indent_with_space')
        let command = command.' --indent_with_space='.g:phpfmt_indent_with_space
    endif

    if exists('g:phpfmt_enable_auto_align')
        let command = command.' --enable_auto_align'
    endif

    if exists('g:visibility_order')
        let command = command.' --visibility_order'
    endif

    if exists('g:smart_linebreak_after_curly')
        let command = command.=' --smart_linebreak_after_curly'
    endif
    
    let command = command.' '.a:path

    let s:lint = system(g:phpfmt_php_path.' -l '.a:path)
    if v:shell_error
        echohl Error | echo s:lint | echohl None
    else
        let s:output = system(command)
        if v:shell_error
            echohl Error | echo s:output | echohl None
        else
            exec 'edit!'
            :set syntax=php
        endif
    endif
endfun

fun! PhpFmtFixDirectory()
    call PhpFmtFix(expand('%:p:h'))
endfun

fun! PhpFmtFixFile()
    call PhpFmtFix(expand('%:p'))
endfun

if(g:phpfmt_enable_default_mapping == 1)
    nnoremap <silent><leader>pcd :call PhpFmtFixDirectory()<CR>
    nnoremap <silent><leader>pcf :call PhpFmtFixFile()<CR>
endif

if(g:phpfmt_on_save == 1)
    :autocmd BufWritePost *.php :call PhpFmtFixFile()
endif

" vim: foldmethod=marker
