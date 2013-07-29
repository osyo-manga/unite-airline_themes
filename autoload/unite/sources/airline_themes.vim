scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#airline_themes#define()
	return s:source
endfunction


let s:source = {
\	"name" : "airline_themes",
\	"description" : ":AirlineTheme {word}",
\	"default_action" : "execute",
\	"hooks" : {},
\	"action_table" : {
\		"preview" : {
\			"description" : "preview :AirlineTheme {word}",
\			"is_quit" : 0,
\		}
\	}
\}


function! s:source.hooks.on_init(args, context)
	let self.prev_theme = g:airline_theme
endfunction


function! s:source.hooks.on_close(args, context)
	if self.prev_theme == g:airline_theme
		return
	endif
	execute "AirlineTheme" self.prev_theme
endfunction


function! s:source.action_table.preview.func(candidate)
	execute a:candidate.action__command
endfunction


function! s:source.gather_candidates(args, context)
	let themes = map(split(globpath(&rtp, 'autoload/airline/themes/*'), "\n"), '[v:val, fnamemodify(v:val, ":t:r")]')
	return map(themes, '{
\		"word" : v:val[1],
\		"kind" : ["file", "command"],
\		"action__command" : "AirlineTheme " . v:val[1],
\		"action__path": v:val[0],
\		"action__directory": fnamemodify(v:val[0], ":h"),
\	}')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
