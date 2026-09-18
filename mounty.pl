use strict;
use warnings;

# Each entry is [ menu label, smb:// URL ]. A URL of undef makes a
# non-clickable section header, shown via Platypus's "DISABLED|" syntax.
#
# The entries below are placeholders - replace them with your own
# organization's shares, then run ./build.sh to rebuild the app. The menu
# and the mount action are both generated from this one list, so there's
# only one place to edit.
my @shares = (
    ["Example Share",    "smb://fileserver.example.com/share"],
    ["Example Projects",  "smb://fileserver.example.com/projects"],

    ["=== Example Section ===", undef],
    ["Example Archive", "smb://nas.example.com/archive"],
);

# If 0 arguments, we show the menu
if (!scalar(@ARGV)) {
    for my $share (@shares) {
        my ($label, $url) = @$share;
        print defined($url) ? "$label\n" : "DISABLED|$label\n";
    }
    print "----\n";
    print "Mount Custom Share...\n";
} else {
    # We get the menu title as an argument
    my $menu_choice = $ARGV[0];

    # Handle custom mount option
    if ($menu_choice eq "Mount Custom Share...") {
        # Try to run the bash script
        system('bash ./miniMounty.sh 2>&1');
        exit 0;
    }

    my %url_for = map { $_->[0] => $_->[1] } grep { defined $_->[1] } @shares;

    if (my $url = $url_for{$menu_choice}) {
        system("open", $url);
    } else {
        print "Unknown menu choice: $menu_choice\n";
    }
}
