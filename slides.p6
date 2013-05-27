" vim code for setup "  q{ " {{{
:set ft=perl6
:set ls=0 " no powerline, we don't have enough space.
:chdir ~/work/gpn13/perl6/
:map <leader>x [zV]z:w! foobar.p6<CR>
            \:silent :!tmux -L REPL send-keys
                \"perl6 -Ilib -MDemonstrate foobar.p6;
                \i3 focus left >& /dev/null"
                \"Enter"<CR>
            \:silent :!i3 focus right<CR>
            \:redraw!<cr>
            \j
:map <leader>v [zV]z:w!
            \foobar.p6<CR>:silent
            \:!tmux -L REPL send-keys
                \"perl6-debug -Ilib -MDemonstrate foobar.p6;
                \i3 focus left >& /dev/null"
                \"Enter"<CR>
            \:silent
            \:!i3 focus right<CR>
            \:redraw!<cr>
            \j
:map <leader>l [zV]z:w! foobar.p6<CR>
            \:silent :!tmux -L REPL send-keys
                \"perl6 -Ilib -MDemonstrate foobar.p6 =inputdialog('flags? ')<CR>;
                \i3 focus left >& /dev/null"
                \"Enter"<CR>
            \:silent :!i3 focus right<CR>
            \:redraw!<cr>j
:map <leader>start :silent :!tmux -L CNTR send-keys 'Enter'<CR><CR>
:map <leader>clean :silent 
            \:!killall perl6;
            \tmux -L CNTR send-keys "C-c";
            \tmux -L REPL send-keys "C-c";
            \xkill;
            \tmux -L CNTR send-keys "C-d" "C-d" "C-d";
            \tmux -L REPL send-keys "C-d" "C-d" "C-d"<CR><CR>
:map <PageDown> zczjzoj
:map <PageUp> zczkzkzjzoj
:silent :!i3 border 1pixel; i3 split v
:silent :!./counter_start.sh
:silent :!sleep 0.25
:silent :!i3 border 1pixel
:silent :!i3 resize shrink height 1 px or 50 ppt
:silent :!i3 focus up; i3 split h
":silent :!gnome-terminal --hide-menubar -t "Perl Output" -x tmux -L REPL &
:silent :!bterm  -e tmux -L REPL &
:silent :!sleep 0.25; i3 border 1pixel
:silent :!tmux -L REPL send-keys 'cd ~/work/gpn13/perl6' 'Enter'
:silent :!tmux -L REPL send-keys 'ulimit -m 819200' 'Enter'
:silent :!tmux -L REPL send-keys 'export PS1="C:\Perl6\Vortrag\Slides> "' 'Enter'
:silent :!tmux -L REPL send-keys 'export RPS1=""' 'Enter'
:silent :!tmux -L REPL send-keys 'clear' 'Enter'
:silent :!tmux -L REPL send-keys 'yes " " | head -n 1000' 'Enter'
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
my Timo $me = Timo.new;
psay brackify($me.perl);
say Timo.WHY;

# }}}
# Meta: Regexes {{{

=for Starters
    In perl6 wurde eine neue Regex syntax eingeführt.
    Diese ist

=item Lesbarer
=item Mächtiger
=item Übersichtlicher

=for Perl5People
    Man kann jederzeit mit :P5 oder :Perl5 PCRE
    stattdessen schreiben.

=for Clarity
    Warum man das aber eigentlich garnicht mehr will
    sehen wir später vielleicht noch.

for $=pod {
    when Pod::Item { print " - " }
    default { print "\n" }
    KEEP {
        print .content>>.content;
        p;
    }
}

# }}}
# Regexes 1a {{{
psay "Foo Bar" ~~ m:P5/(...)(?:\ (...))+/;
psay "Foo Bar" ~~ /(...)+ % " "/;
# }}}
# Regexes 1b {{{
say "Auf Ergebnisse zugreifen";

say "Foo Bar" ~~ m:P5/(...)(?:\ (...))+/;
psay $0, $1;

say "Foo Bar" ~~ /(...)+ % " "/;
psay $0, $1;

psay $0.WHAT, $0.elems, $0[0].WHAT;
# }}}
# Regexes 1c {{{
psay "p5: ", 'Foo Bar \o/ Qux' ~~ m:P5/(...)(?:\ (...))+/;
psay "p6: ", 'Foo Bar \o/ Qux' ~~ /(...)+ % " "/;
psay "oops";
# }}}
# Regexes 2a {{{
my $r = "Foo123" ~~ /<ident>/;
$r = "Foo123" ~~ /<alnum> ** 4/;
$r = "Foo123" ~~ /(<.alpha> ** 2..5)/;
# }}}
# Regexes 2b {{{
say brackify("foo(bar, baz, quux(barbaz, abc))");
# }}}
