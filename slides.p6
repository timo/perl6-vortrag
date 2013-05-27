" vim code fore setup "  q{ # {{{
:set ft=perl6
:set ls=0 " no powerline, we don't have enough space.
:chdir ~/work/gpn13/perl6/
:map <leader>x [zV]z:w! foobar.p6<CR>:silent :!tmux -L REPL send-keys "perl6 -Ilib -MDemonstrate foobar.p6; i3 focus left" "Enter"<CR>:silent :!i3 focus right<CR>:redraw!<cr>j
:map <leader>v [zV]z:w! foobar.p6<CR>:silent :!tmux -L REPL send-keys "perl6-debug -Ilib -MDemonstrate foobar.p6; i3 focus left" "Enter"<CR>:silent :!i3 focus right<CR>:redraw!<cr>j
:map <PageDown> zczjzoj
:map <PageUp> zczkzkzjzoj
:silent :!i3 border 1pixel
:silent :!gnome-terminal --hide-menubar -t "Perl Output" -x tmux -L REPL &
:sleep 1
:silent :!i3 border 1pixel
:silent :!tmux -L REPL send-keys 'cd ~/work/gpn13/perl6' 'Enter'
:silent :!tmux -L REPL send-keys 'export PS1="C:\Perl6\Vortrag\Slides> "' 'Enter'
:silent :!tmux -L REPL send-keys 'export RPS1=""' 'Enter'
:silent :!tmux -L REPL send-keys 'clear' 'Enter'
:silent :!tmux -L REPL set-option -g status off
:set foldmethod=marker
:set guifont=Monaco\ 14
:silent :!i3 focus left
:redraw!
:finish
"" } # }}}
# Einleitung {{{

#= A student at the Karlsruhe Institute of Technology
class Timo {
    has $.Python-knowledge = True;
    has $.Perl5-knowledge = False;
    has %.handles = {
        github=>"timo",
        irc=>(freenode=>"timotimo", hackint=>"timo")
        };
    has @.h-spaces = "chaosdorf", "entropia";
}
my Timo $me .= new;
say $me.gist;
say Timo.WHY;

# }}}
# Regexes 1 {{{

=item Lesbarer
=item Mächtiger
=item Übersichtlicher

say $=pod.perl;
say "";
for $=pod -> $piece {
    print " - ", $piece.content>>.content;
    prompt("");
}

# }}}
# Regexes 1a {{{
say "Foo Bar" ~~ m:P5/(...)(?:\ (...))+/;
say "Foo Bar" ~~ /(...)+ % " "/;
# }}}
# Regexes 1b {{{
say "p5: ", 'Foo Bar \o/ Qux' ~~ m:P5/(...)(?:\ (...))+/;
say "p6: ", 'Foo Bar \o/ Qux' ~~ /(...)+ % " "/;
say "oops";
# }}}
# Regexes 2a {{{
my $r = "Foo123" ~~ /<ident>/;
$r = "Foo123" ~~ /<alnum> ** 4/;
$r = "Foo123" ~~ /(<.alpha> ** 2..5)/;
# }}}
# Regexes 2b {{{

# }}}
