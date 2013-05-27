START say "";
END say "";

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
