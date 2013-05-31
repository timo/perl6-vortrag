" vim code for setup "  q{ " {{{
:set ft=perl6
:colorscheme wombat
:set ls=0 " no powerline, we don't have enough space.
:chdir ~/work/gpn13/perl6/
:map <leader>x [zV]z:w! foobar.p6<CR>
            \:silent :!tmux -L REPL send-keys
                \ "perl6 -Ilib -MDemonstrate foobar.p6;
                \ i3 focus left >& /dev/null"
                \ "Enter"<CR>
            \ :silent :!i3 focus right<CR>
            \ :redraw!<cr>
            \j
:map <leader>v [zV]z:w! foobar.p6<CR>
            \:silent
            \ :!tmux -L REPL send-keys
                \ "perl6-debug -Ilib -MDemonstrate foobar.p6;
                \ i3 focus left >& /dev/null"
                \ "Enter"<CR>
            \ :silent
            \ :!i3 focus right<CR>
            \ :redraw!<CR>
            \j
:map <leader>l [zV]z:w! foobar.p6<CR>
            \:silent :!tmux -L REPL send-keys
                \ "perl6 -Ilib -MDemonstrate foobar.p6 =inputdialog('flags? ')<CR>;
                \ i3 focus left >& /dev/null"
                \ "Enter"<CR>
            \ :silent :!i3 focus right<CR>
            \ :redraw!<cr>j
:map <leader>start :silent :!tmux -L CNTR send-keys 'Enter'<CR><CR>
:map <leader>clean :silent 
            \ :!killall perl6;
            \ tmux -L CNTR send-keys "C-c";
            \ tmux -L REPL send-keys "C-c";
            \ xkill -id 0x$(xwininfo -root -tree \| grep "flub" \| sed -e 's/^ *0x//' -e 's/ .*$//');
            \ tmux -L CNTR send-keys "C-d" "C-d" "C-d";
            \ tmux -L REPL send-keys "C-d" "C-d" "C-d"<CR><CR>
:map <PageDown> zczjzoj
:map <PageUp> zczkzkzjzoj
:map ,dup [zV]zy]zpkzcj<C-a>
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
:set guifont=Monaco\ 11
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

=item1 Lesbarer
=item1 Mächtiger
=item1 Übersichtlicher

=for Perl5People
    Man kann jederzeit mit :P5 oder :Perl5 PCRE
    stattdessen schreiben.

podpresent;

# }}}
# Gulasch-Regex 1 {{{
say "Heute: Gulasch: 3,50 Euro UNGLAUBLICHES SCHNÄPPCHEN" ~~ rx/
        <produkt=ident> \: <ws>
        $<pre>=[<digit>+] \, $<post>=[<digit> ** 2]
        <ws> Euro/;
# }}}
# Gulasch-Regex 2 {{{
say "weniger unnütze matching groups";
say "Heute: Gulasch: 3,50 Euro UNGLAUBLICHES SCHNÄPPCHEN" ~~ rx/
        <produkt=.ident> \: <.ws>
        $<pre>=[<.digit>+] \, $<post>=[<.digit> ** 2]
        <.ws> Euro/;
# }}}
# Gulasch-Regex 3 {{{
psay "Heute: Gulasch: 3,50 Euro UNGLAUBLICHES SCHNÄPPCHEN" ~~ rx/
        << <produkt=.ident> \: <.ws>
        $<pre>=[<.digit>+] \, $<post>=[<.digit> ** 2]
        <.ws> Euro/;

say("Heute: Gulasch: 3,50 Euro UNGLAUBLICHES SCHNÄPPCHEN" ~~
#     vvv
    rx:P5/\b([a-zA-Z]+): +([0-9]+),([0-9]{2}) +Euro/);
# }}}
# Gulasch-Regex 4 {{{
"Heute: Gulasch: 3,50 Ruble UNGLAUBLICHES SCHNÄPPCHEN" ~~ rx/
        << <produkt=.ident> \: <.ws>
        $<pre>=[<.digit>+] \, $<post>=[<.digit> ** 2]
        <.ws> $<währung>=["Euro"|"Dollar"|"Ruble"]/;

epsay $<produkt>;
epsay $<pre>;
epsay $<post>;
my $preis = $<pre>.Int + $<post>.Int / 100;
say "zwölf {$<produkt>} kosten {$preis * 12} {$<währung>}";
# }}}
# Gulasch-Regex 5 (einschub "comb") {{{
epsay "foo; bar. (quux) ... yoink".comb(/<ident>/).perl;
epsay "boing boing boing".comb().perl;
say "foo:1; bar:2. (quux:3) ... yoink:4".comb(/<ident>\:<digit>/, :match).map({"($_.gist())"});
# }}}
# Gulasch-Regex 6 {{{
my $src = q:to/LISTE/;
    Heute: 
        Gulasch: 3,50 Euro UNGLAUBLICHES SCHNÄPPCHEN
        Börek: 3,00 Euro bla bla
        Limonade: 1,00 Euro foo bar
    Morgen:
        Tschunk: 3,50 Euro  mit mate und rum
        Ameisenbär: 5,00 Euro  mit orange, minze und Erdbeere
    LISTE
psay $src.comb(rx/
        <produkt=.ident> \: <.ws>
        $<pre>=[<.digit>+] \, $<post>=[<.digit> ** 2]
        <.ws> "Euro"/).perl;
# }}}
# Gulasch-Regex 7 {{{
my $src = q:to/LISTE/;
    Heute:
        Gulasch: 3,50 Euro UNGLAUBLICHES SCHNÄPPCHEN
        Börek: 3,00 Euro bla bla
        Limonade: 1,00 Euro foo bar
    Morgen:
        Tschunk: 3,50 Euro  mit mate und rum
        Ameisenbär: 5,00 Euro  mit orange, minze und Erdbeere
    LISTE
my @result = $src.comb(rx/
        <produkt=.ident> \: <.ws>
        $<pre>=[<.digit>+] \, $<post>=[<.digit> ** 2]
        <.ws> "Euro"/, :match);
for @result {
    epsay .<produkt>.Str, .<pre>.Int, .<post>.Int;
}
# }}}

# MAIN sub {{{
multi sub MAIN("foo") {
    say "foo bar baz"
}

multi sub MAIN("blubb", $foo) {
    say "foo is $foo"
}
# }}}
# MAIN sub {{{
say "foo";
p;
say "bar";
# }}}
