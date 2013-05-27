use Term::ANSIColor;

START say "";
END say "";

sub farbe($_) { "\e[38;5;{$_}m" };

sub brackify($_) is export {
    sub twofiddy($_) { "\e[38;5;{$_}m" };
    my %parens = '[]{}<>()'.comb;
    my %rparens = Hash.new(%parens.invert);
    my @allp = %parens.keys, %parens.values;
    my $depth = 2;
    my @stack;
    twofiddy(1) ~ (for $_.comb(/@allp||<-[\(\)\<\>\[\]\{\}]>+/) {
        when %parens {
            push @stack, %parens{$_};
            twofiddy(++$depth) ~ $_;
        }
        when %rparens {
            if $_ eq @stack[*-1] {
                @stack.pop;
                twofiddy($depth--) ~ $_ ~ twofiddy($depth);
            } else { $_ }
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
sub psay(**@d) is export {
    say(@d>>.gist>>.trim-trailing.join(", "));
    p
}
sub csay(**@d) is export {
    say(@d>>.gist>>.trim-trailing.join(", "));
}
