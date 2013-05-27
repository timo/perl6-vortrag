use Term::ANSIColor;

START say "";
END say "";

constant @twofiddy is export := ("\e[38;5;{$_}m" for ^256);

sub brackify($_) is export {
    my $depth = 2;
    my @stack;
    @twofiddy[1] ~ (for $_.comb(/<[,(\{\[\<\>\]\}\)]>||<-[\,\(\{\[\<\>\]\}\)]>*/) {
        when ',' {
            @twofiddy[$depth] ~ ",";
        }
        when /'('|'{'|'['|'<'/ {
            @twofiddy[++$depth] ~ $_;
            push @stack, $_;
        }
        when /')'|'}'|']'|'>'/ {
            if $_ eq @stack[*-1] {
                @twofiddy[$depth--] ~ $_;
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

sub bracketize(Str $in) {

}
