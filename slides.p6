" vim code for setup " q{ " {{{
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
                \ "perl6 -Ilib -MDemonstrate foobar.p6 =inputdialog('flags?')<CR>;
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
:map <PageDown> zczjzoj1<C-e>
:map <PageUp> zczkzkzjzoj1<C-y>
:map ,dup [zV]zy]zpkzcj<C-a>
:map ,ns O# =inputdialog('titel?')<CR> {{{<ESC>o# }}}<ESC>k
:silent :!i3 border 1pixel; i3 split v
:silent :!./counter_start.sh
:silent :!sleep 0.25
:silent :!i3 border 1pixel
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
# eichhörnchen-geführt {{{

image "eichhoernchen.jpg";

# }}}
# "wolpertinger typing" {{{

image "Wolpertinger.jpg";

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
        « <produkt=.ident> \: <.ws>
        $<pre>=[<.digit>+] \, $<post>=[<.digit> ** 2]
        <.ws> Euro/;

say("Heute: Gulasch: 3,50 Euro UNGLAUBLICHES SCHNÄPPCHEN" ~~
#     vvv
    rx:P5/\b(\w+): +([0-9]+),([0-9]{2}) +Euro/);
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
 Gulasch-Regex 5 (einschub "comb") {{{
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

# OOP 1 {{{
class Produkt {
    has $.preis;
    has $.name;
    has $.kategorie;
}

epsay Produkt.new();
# }}}
# OOP 2 {{{
class Produkt {
    has $.preis;
    has $.name;
    has $.kategorie;
}

epsay Produkt.new(preis=>3.50, name=>"gulasch", kategorie=>"gestern");
# }}}
# OOP 3 erzwungene argumente {{{
class Produkt {
    has $.preis;
    has $.name;
    has $.kategorie;

    method new(:$preis!, :$name!, :$kategorie!) {
        return self.bless(*, :$preis, :$name, :$kategorie);
    }
}

epsay Produkt.new();
# }}}
# OOP 4 erzwungene argumente II {{{
class Produkt {
    has $.preis = die "ein preis muss angegeben werden";
    has $.name = die "ein name muss angegeben werden";
    has $.kategorie = die "eine kategorie muss angegeben werden";
}

epsay Produkt.new();
# }}}
# OOP 5 erzwungene argumente III {{{
class Produkt {
    has $.preis = die "ein preis muss angegeben werden";
    has $.name = die "ein name muss angegeben werden";
    has $.kategorie = die "eine kategorie muss angegeben werden";
}

epsay Produkt.new(name=>"gulasch", preis=>3.50, kategorie=>"gestern");
# }}}
# OOP 6 typisierte attribute {{{
class Produkt {
    has Real $.preis = die "ein preis muss angegeben werden";
    has Str $.name = die "ein name muss angegeben werden";
    has Str $.kategorie = die "eine kategorie muss angegeben werden";
}

epsay Produkt.new(name=>"hallo", preis=>3.50, kategorie=>"gestern");
# }}}

# Roles/Mix-ins 1 {{{
role Geöffnet {
    method konsumieren { say "Mh, lecker $.name! nomnomnom"; }
}
class Produkt {
    has Str $.name = die "ein name muss angegeben werden";

    method öffnen {
        self does Geöffnet;
    }
}

my $mate = Produkt.new(name=>"Club-Mate");

try { $mate.konsumieren }; epsay $!;

epsay $mate ~~ Geöffnet, $mate.WHAT; # vor dem öffnen
$mate.öffnen;
epsay $mate ~~ Geöffnet, $mate.WHAT; # nach dem öffnen

$mate.konsumieren;
# }}}
# Roles/Mix-ins 2 {{{
role Geöffnet {
    method konsumieren { say "Mh, lecker $.name! nomnomnom"; }
}
class Produkt {
    has Str $.name = die "ein name muss angegeben werden";

    method öffnen {
        self but Geöffnet;
    }   #    ███
}

my $mate = Produkt.new(name=>"Club-Mate");

try { $mate.konsumieren }; epsay $!;

epsay $mate ~~ Geöffnet, $mate.WHAT; # vor dem öffnen
$mate.öffnen;
epsay $mate ~~ Geöffnet, $mate.WHAT; # nach dem öffnen

$mate.konsumieren;
# }}}
# Roles/Mix-ins 3 {{{
role Geöffnet {
    method konsumieren { say "Mh, lecker $.name! nomnomnom"; }
}
class Produkt {
    has Str $.name = die "ein name muss angegeben werden";

    method öffnen {
        self but Geöffnet;
    }
}

my $mate = Produkt.new(name=>"Club-Mate");

try { $mate.konsumieren }; epsay $!;

epsay $mate ~~ Geöffnet, $mate.WHAT; # vor dem öffnen
$mate .= öffnen;
#██████████████
epsay $mate ~~ Geöffnet, $mate.WHAT; # nach dem öffnen

$mate.konsumieren;
# }}}

# Inheritance 1 {{{
class BaseCommand {
    method execute { ... }
}
try { BaseCommand.new().execute }; epsay $!;
# }}}
# Inheritance 2 {{{
class BaseCommand {
    method execute { ... }
}
class FormatCCommand is BaseCommand {
    method execute {
        shell "format c:"
    }
}
class OverwriteHardDriveCommand is BaseCommand {
    method execute {
        shell "dd if=/dev/random of=/dev/disk0"
    }
}
OverwriteHardDriveCommand.new().execute;
# }}}
# Inheritance 2 {{{
class BaseCommand {
    method execute { shell $.shellcommand }
}
class FormatCCommand is BaseCommand {
    has $.shellcommand = "rm -rf /"
}
class OverwriteHardDriveCommand is BaseCommand {
    has $.shellcommand = "dd if=/dev/random of=/dev/sda"
}
OverwriteHardDriveCommand.new().execute;
# }}}
# Inheritance 3 {{{
class BaseCommand {
    method execute { shell $.shellcommand }
}
class FormatCCommand is BaseCommand {
    has $.shellcommand = "rm -rf /"
}
class OverwriteHardDriveCommand is BaseCommand {
    has $.shellcommand = "dd if=/dev/random of=/dev/sda"
}
# }}}

# "Interfaces" 1 {{{
say "blaber";
role Pbzznaq {
    method execute { ... } # "stub code"
}

class Dog does Pbzznaq {
    method bark() { say "woof" }
}

# }}}
# "Interfaces" 2 {{{
role Command {
    method execute { ... } # "stub code"
}

class EchoCommand does Command {
    method execute(Str $echostring) { shell "echo '$echostring'" }
}
EchoCommand.new().execute("foobar");
# }}}
# "Interfaces" 3 - 'Cool' {{{
my ($cool, $all);
my @coolclassnames;
for OUTER::OUTER::.kv -> $k, $v {
    if $k ~~ /^<upper>/ {
       if $v ~~ Cool {
           $cool++;
           @coolclassnames.push: $k;
       }
       $all++
   }
}
say "$cool / $all der Klassen sind Cool.";
say "Eine kleine Auswahl: " ~ @coolclassnames.pick(10);
# }}}
# "Interfaces" 4 - 'Cool' {{{
=for Reals-Yo
    Cool - "Perl6 Convenient OO Loopbacks"

=item1 Alle möglichen Konversionsmethoden
=item1 "stringy" und "numerische" methoden
=item2   .Str, .Num, .Rat, .set, ...
=item1 "Vereinigung" derer Methoden
=item2   .abs, .conj, .sqrt, ...
=item2   .chars, .codes, .substr, .uc, .lc, ...
=item1 Und 'sub' formen
=item2   abs(-10), sqrt(2), ...
=item2   lc($str), ords($str), ...

podpresent
# }}}

# Grammatiken 1 {{{
my $src = q:to/LISTE/;
    Heute:
        Gulasch: 3,50 Euro bla bla
        Börek: 3,00 Euro bla bla
        Limonade: 1,00 Euro foo bar
    Morgen:
        Tschunk: 3,50 Euro  mit mate und rum
        Ameisenbär: 5,00 Euro  mit gemüse
    LISTE
grammar Produktliste {
    regex TOP {
        <kategorie>+
    }
    regex kategorie {
        ^^ <kat-name=.ident> \: \n
        [\ + <produkt> .*? \n]+
    }
    regex produkt {
        << <name=.ident> \: <.ws>
        $<pre>=[<.digit>+] \, $<post>=[<.digit> ** 2]
        <.ws> "Euro"
    }
}
epsay Produktliste.parse($src);
# }}}
# Grammatiken 2 {{{
use produktgrammatik;
my $src = slurp("gulaschliste.txt");

my $result = Produktliste.parse($src);
epsay $result<kategorie>[0]<kat-name>;
epsay $result<kategorie>[0]<produkt>[0]<name>;
epsay $result<kategorie>[0]<produkt>[1]<name>;
# }}}
# Grammatiken - einschub 1 {{{
grammar Frob {
    regex TOP {
        ^ [<tuple> <.ws>]+ $
    }
    regex tuple {
        <der-name=.ident> \: $<die-zahl>=[<digit>+]
    }
}
epsay Frob.parse("Foo:10    Bar:99   Yoink:5")
# }}}
# Grammatiken - einschub 2 {{{
grammar Frob {
    regex TOP {
        ^ [<tuple> <.ws>]+ $
    }
    regex tuple {
        <der-name=.ident> \: $<die-zahl>=[<.digit>+]
        { make ($<der-name>.Str, $<die-zahl>.Int) }
    }
}
epsay brackify(Frob.parse("Foo:10    Bar:99   Yoink:5").perl)
# }}}
# Grammatiken - einschub 3 {{{
grammar Frob {
    regex TOP {
        ^ [<tuple> <.ws>]+ $
        {
            make $<tuple>>>.ast;
        }
    }
    regex tuple {
        <der-name=.ident> \: $<die-zahl>=[<.digit>+]
        { make ($<der-name>.Str, $<die-zahl>.Int) }
    }
}
epsay brackify(Frob.parse("Foo:10    Bar:99   Yoink:5").ast.perl)
# }}}
# Grammatiken 3 {{{
use produktgrammatik;
my $src = slurp("gulaschliste.txt");

class ProduktActions {
    has $.kategorie;

    method TOP($/) { make $<kategorie>>>.ast }

    method kategorie($/) {
        my @result = $<produkt>>>.ast;
        for @result { $_<kategorie> = $<kat-name>.Str };
        make @result;
    }

    method produkt($/) {
        make {
            name=>$<name>.Str,
            preis=>$<pre>.Int + $<post>.Int * 0.01
        }
    }
}

my $result = Produktliste.parse($src, actions=>ProduktActions.new);
for $result.ast.list {
    .perl.say;
}
# }}}
# Grammatiken 4 {{{
use produktgrammatik;
my $src = slurp("gulaschliste.txt");

class Produkt is rw { has Real $.preis; has Str $.name; has Str $.kategorie; }
class ProduktActions {
    has $.kategorie;

    method TOP($/) { make $<kategorie>>>.ast }

    method kategorie($/) {
        my @result = $<produkt>>>.ast;
        for @result { $_.kategorie = $<kat-name>.Str };
        make @result;
    }

    method produkt($/) {
        make Produkt.new(
            name=>$<name>.Str,
            preis=>$<pre>.Int + $<post>.Int * 0.01
        )
    }
}

my $result = Produktliste.parse($src, actions=>ProduktActions.new);
for $result.ast.list {
    .perl.say;
}
# }}}

# Eichhörnchen! {{{
image "eichhoernchen.jpg"
# }}}

# MAIN sub 1 {{{
multi sub MAIN("foo") {
    say "foo bar baz"
}

multi sub MAIN("blubb", $foo) {
    say "foo is $foo"
}
# }}}
# MAIN sub 2 {{{
multi sub MAIN(Str $foo, Int $bar) {
    say "$foo, $bar, str, int"
}

multi sub MAIN(Int $foo, Int $bar) {
    say "$foo, $bar, int int"
}
# }}}
# MAIN sub 3 {{{
sub fibonacci($n) {
    return (1, 1, * + * ... *)[$n];
}

multi sub MAIN(Int $foo) {
    say "fibonacci von $foo ist ", fibonacci $foo
}
multi sub MAIN("test") {
    use Test;
    plan 4;
    is fibonacci(0), 1, "erste zahl";
    is fibonacci(1), 1, "zweite zahl";
    is fibonacci(2), 2, "dritte zahl";
    is fibonacci(-1), Nil, "negativer index";
}
# }}}

# Series Operator 1 {{{
epsay 1, 2 ... 10;    # einfache sequenz
epsay 1, 2, 4 ... 16; # 2 ** n
epsay 10, 9 ... 0;    # negative steps
# }}}
# Series Operator 2 {{{
epsay 1, 2, 4 ...^ * > 10;
for ^10 {
    say 1, 2, 4 ... { [False, False, False, False, True].pick };
}
# }}}
# Series Operator 3 {{{
epsay 10, 11 ... -> $a { (state $primes)++ if $a.is-prime; $primes > 5 }
# }}}
# Series Operator 4 {{{
use graphdata;
my %parents = parents;
my $start = "D2";
my $end = "B4";
epsay %parents;
epsay %parents{$end};
epsay %parents{%parents{$end}};
epsay %parents{%parents{%parents{$end}}};
# Series Operator 5 {{{
use graphdata;
my %parents = parents;
my $start = "D2";
my $end = "B4";
epsay ($end, -> $node { %parents{$node} } ... $start);
# }}}
# Series Operator 6 {{{
epsay 1, 1, *+* ... * > 100;
# }}}
# Series Operator 7 {{{

sub hailstone($start) {
    $start, -> $num { $num %% 2 ?? $num / 2 !! $num * 3 + 1 } ... 1;
}
epsay hailstone(51);
epsay hailstone(52);
# }}}

# multi 1 {{{
multi faktorial($foo where * <= 0) { 1 }
multi faktorial($foo) { faktorial($foo - 1) * $foo }

epsay faktorial(-5);
epsay faktorial(0);
epsay faktorial(1);
epsay faktorial(2);
epsay faktorial(10);
# }}}
# multi 2 {{{
proto faktorial($foo) { * }
multi faktorial($foo where * <= 0) { 1 }
multi faktorial($foo) { faktorial($foo - 1) * $foo }

epsay faktorial(1);
epsay faktorial(2);
epsay faktorial(10);
# }}}
# multi 3 {{{
proto faktorial($foo) is cached { * }
multi faktorial($foo where * <= 0) { 1 }
multi faktorial($foo) { faktorial($foo - 1) * $foo }

epsay faktorial(1);
epsay faktorial(2);
epsay faktorial(10);
# }}}

# sortimo 1 {{{
my @names = <ich du er sie es wir ihr sie_2>;
my %singular = bag <ich du er sie es>;

epsay @names.sort;
epsay @names.sort({ $_.flip });
epsay @names.sort({ %singular{$_}:exists, $_ });
# }}}
# sortimo 2 {{{
my @names = <ich du er sie es wir ihr sie_2>;
my %singular = bag <ich du er sie es>;

epsay @names.sort;
epsay @names.sort({ $_.flip });
epsay @names.sort({ %singular{$_}:exists, $_ });
# }}}
# sortimo 3 {{{
epsay (1 ... 10).sort({ $_.is-prime, $_ });
epsay (1 ... 10).classify({ $_.is-prime ?? "prim" !! "nichtprim" });
# }}}



# felher 1 {{{
sub diese-sub-ist-toll() { say "yay" }

diese_sub_ist_toll();
# }}}
# felher 2 {{{
say String ~~ Cool;
# }}}
# felher 3 {{{
if 10 < 5 { say "wat" } else if { say "yay" }
# }}}
# felher 4 {{{
sub do-it(Str $foo) {
    say $foo;
}
say "es ist ausgeführt";
do-it(prompt("hallo"));
do-it(100);

# }}}

# {{{

sub teste-den-scheiß() {
    LEAVE say "eins";
    LEAVE say "zwei";
    LEAVE say "drei";
    ENTER say "PSYCHE!";
}
teste-den-scheiß;

# }}}

