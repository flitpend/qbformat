#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use open ':std', ':encoding(utf8)';
use File::Basename;

my ($h1, $h2, $h3, $h4) = (1, 1, 1, 1);
my @part1 = qw{十 二十 三十 四十 五十 六十 七十 八十 九十};
my @part2 = qw{一 二 三 四 五 六 七 八 九};
unshift(@part1, '');
unshift(@part2, '');


sub get_heading_text {
    my ($arg) = @_;
    my $quotient = int($arg / 10);
    my $remainder = $arg % 10;

    return $part1[$quotient] . $part2[$remainder];
}


sub process_file {
    open my $rfh, '<:encoding(utf8)', @_;
    my @lines = <$rfh>;
    close $rfh;

    my $wfilename = basename(@_, '.txt') . '_temp.txt';
    open my $wfh, '>>', $wfilename;
    for my $line (@lines) {
        chomp($line);
        $line =~ s/^\s+|\s+$//g;

        # Ignore empty lines
        next if ($line =~ m/^$/);

        # Headings
        if ($line =~ m/^#\s+/) {
            print $wfh join('', $&, get_heading_text($h1), '、', "$'\n\n");
            $h1++;
            ($h2, $h3, $h4) = (1, 1, 1);
            next;
        }
        if ($line =~ m/^##\s+/) {
            print $wfh join('', $&, '（', get_heading_text($h2), '）', "$'\n\n");
            $h2++;
            ($h3, $h4) = (1, 1);
            next;
        }
        if ($line =~ m/^###\s+/) {
            print $wfh join('', $&, $h3, '.', "$'\n\n");
            $h3++;
            $h4 = 1;
            next;
        }
        if ($line =~ m/^####\s+/) {
            print $wfh join('', $&, '（', $h4, '）', "$'\n\n");
            $h4++;
            next;
        }

        # Attachments
        if ($line =~ m/^######\s+附件：/) {
            print $wfh "$line\n\n";
            next;
        }
        if ($line =~ m/^######\s+(?!附件：)/) {
            print $wfh join('', '######## ', "$'\n\n");
            next;
        }

        print $wfh "$line\n\n";
    }
    close $wfh;
}


sub main() {
    # Remove existing temp files
    my @tempfiles = glob('*_temp.txt');
    for my $tempfile (@tempfiles) {
        unlink $tempfile or warn "Could not unlink file $tempfile: $!\n";
    }

    my @txtfiles = glob('*.txt');
    for my $file (@txtfiles) {
        ($h1, $h2, $h3, $h4) = (1, 1, 1, 1);
        process_file($file);
        
        my $filename = basename($file, '.txt');
        system("pandoc -o ${filename}.docx ${filename}_temp.txt --reference-doc t.docx");
        unlink "${filename}_temp.txt" or warn "Could not unlink temp file ${filename}_temp.txt: $!\n";
    }
}


main();
