use Term::ANSIColor;

START say "";
END say "";

my %colorscheme = (0..*) Z=>
    (171, 4, 5, 6, 10, 11, 21, 57, 69, 93, 112, 160, 184, 220);

sub farbe($_) {
    "\e[38;5;{%colorscheme{"$_"}}m"
}

sub brackify($_) is export {
    my %parens = '[]{}<>()'.comb;
    my %rparens = Hash.new(%parens.invert);
    my @allp = %parens.keys, %parens.values;
    my $depth = 0;
    my @stack;
    farbe(1) ~ (for $_.comb(/@allp||<-[\(\)\<\>\[\]\{\}\"]>+||\"<-[\"]>+\"/) {
        when /^\".*\"$/ {
            farbe(10) ~ $_ ~ farbe($depth);
        }
        when %rparens {
            if $_ eq @stack[*-1] {
                @stack.pop;
                farbe($depth--) ~ $_ ~ farbe($depth);
            } else { $_ }
        }
        when %parens {
            push @stack, %parens{$_};
            farbe(++$depth) ~ $_;
        }
        default {
            $_
        }
    }).join("") ~ RESET;
}

sub pause is export {
    say "";
    prompt("-- More --");
    say "";
}
sub p is export {
    $*IN.getc()
}
my %files;
sub epsay(**@d) is export {
    my ($f, $l);
    for 1..* {
        my $fr = callframe($_);
        if $fr.file ne 'src/gen/CORE.setting'|'lib/Demonstrate.pm6' {
            $f = $fr.file;
            $l = $fr.line;
            last;
        }
    };
    my $code = %files{$f} //= $f.IO.lines;
    my $codeline = $code[$l - 1].trim-leading.subst(/^epsay /, "");
    $codeline ~~ m/$<code>=[<-[\#]>+]$<comment>=[.*]/;
    say colored($l ~ ":", "cyan") ~ " " ~ colored($<code>.Str, "blue") ~ colored($<comment>.Str, "cyan");
    psay(|@d);
}
sub psay(**@d) is export {
    say((map *.gist.trim-trailing, @d).join(", "));
    p
}
sub csay(**@d) is export {
    say(@d>>.gist>>.trim-trailing.join(", "));
}

sub podpresent() is export {
    for CALLER::<$=pod> {
        when Pod::Item { print "  " x $_.level ~ "- " }
        default { print "\n" }
        KEEP {
            print .content>>.content;
            p;
        }
    }
}

sub image(Str $filename) is export {
    die "$filename does not exist" unless $filename.IO.e;
    shell "feh -F $filename &";
}
