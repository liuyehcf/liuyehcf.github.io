use strict;
use warnings;
use Modern::Perl;
use File::Spec;
use Time::Piece;
use Cwd;

# params
my $filter = '\w+';
$filter = shift if @ARGV > 0;
$filter = qr/$filter/;

my @years = (2017 .. Time::Piece->new()->year);
my $prefix = 'https://liuyehcf.github.io';
my %urls = ();
my $path = File::Spec->rel2abs(__FILE__);
my ($vol, $root, $name) = File::Spec->splitpath($path);

sub num_for($$$) {
    my ($year, $month, $day) = @_;
    return $year * 366 + $month * 31 + $day;
}

opendir my $dirh, "$root/../../public/" or die "dir '$root/../../public/' not exist";

for my $year (@years) {
    opendir my $year_dirh, "$root/../../public/$year/" or next;
    my $exclude = qr/(?:\.|\.\.)/;

    while (my $month = readdir $year_dirh) {
        next if $month =~ $exclude;
        opendir my $month_dirh, "$root/../../public/$year/$month/" or die "dir '$root/../../public/$year/$month/' not exist";
        while (my $day = readdir $month_dirh) {
            next if $day =~ $exclude;
            opendir my $day_dirh, "$root/../../public/$year/$month/$day/" or die "dir '$root/../../public/$year/$month/$day/' not exist";
            my $articles = [];
            while (my $article = readdir $day_dirh) {
                next if $article =~ $exclude;
                next if $article !~ $filter;
                push(@$articles, "$prefix/$year/$month/$day/$article");
            }
            $urls{num_for($year, $month, $day)} = $articles;
            closedir $day_dirh
        }
        closedir $month_dirh;
    }
    closedir $year_dirh;
}

my @sorted_urls = ();
map { push(@sorted_urls, @{$_->[1]}) } # push all articles to sorted_urls
sort { $a->[0] cmp $b->[0] } # sort by hash key
map {[ $_, $urls{$_} ]} keys %urls; # map hash to array

my $out_path = File::Spec->rel2abs("$root/../../url.list");
$out_path = Cwd::abs_path($out_path);
open my $out_fh, '>', $out_path;
say $out_fh $_ for (@sorted_urls);
say "generated finished, filepath: '$out_path'";