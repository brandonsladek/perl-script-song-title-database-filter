################################################
#    CSCI 305 Concepts of Programming Languages
#              Programming Lab #1
#										
#  < Brandon Sladek >
#  < brandonsladek@gmail.com >
#										
################################################

# Names
my $name = "<Brandon Sladek>";
my $partner = "<Drew Antonich>";

print "------------------------------------------------------------------\n";
print "CSCI 305 Lab 1 submitted by $name and $partner.\n";

# Checks for the argument, fail if none given
if($#ARGV != 0) {
    print STDERR "You must specify the file name as the argument.\n";
    exit 4;
}

# Opens the file and assign it to handle INFILE
open(INFILE, $ARGV[0]) or die "Cannot open $ARGV[0]: $!.\n";


# VARIABLE DEFINITIONS HERE...
$lastline;
$numTracks = 0;
@words;
%hoh;
$word1;
$word2;

# This loops through each line of the file
while($line = <INFILE>) {

    # Replace strings of 18 characters (letters and numbers) with nothing
    $line =~ s/[A-Z0-9]{18}//g;
    
    # Replace first and second sep with nothing
    $line =~ s/<SEP>//;
    $line =~ s/<SEP>//;
    
    # Replace everything before > with nothing
    $line =~ s/[^>]*>//;
    
    # Replace everything after the first ( with nothing
    $line =~ s/\(.*//;
    
    # Replace everything after the first [ with nothing
    $line =~ s/\[.*//;
    
    # Replace brackets and punctuation marks
    $line =~ s/\\//g;
    $line =~ s/\///g;
    $line =~ s/_//g;
    $line =~ s/-//g;
    $line =~ s/://g;
    $line =~ s/\"//g;
    $line =~ s/\'//g;
    $line =~ s/\+//g;
    $line =~ s/=//g;
    $line =~ s/\*//g;
    $line =~ s/feat.//g;
    $line =~ s/\;//g;
    $line =~ s/\^//g;
    $line =~ s/\?//g;
    $line =~ s/!//g;
    $line =~ s/\.//g;
    $line =~ s/&//g;
    $line =~ s/\$//g;
    $line =~ s/\@//g;
    $line =~ s/%//g;
    $line =~ s/\|//g;
    
    # Convert every word to lowercase
    $line = lc $line;
    
    # Filter titles with non-English characters
    if($line =~ m{^[[:ascii:]]+$}) {
        $numTracks = $numTracks + 1;
        
        # Split each title into words
        @words = split(' ', $line);
        
        # Create references to each pair of words in the words array
        while (@words > 1) {
            # Bigram consists of word1 and word2
            $word2 = pop @words;
            $word1 = pop @words;
            push @words, $word1;
            
            # Increment bigram count if there are no stop words present
            if ($word1 ne "a" && $word1 ne "an" && $word1 ne "and" && $word1 ne "by" && $word1 ne "for"
                && $word1 ne "from" && $word1 ne "in" && $word1 ne "of" && $word1 ne "on" && $word1 ne "or"
                && $word1 ne "out" && $word1 ne "the" && $word1 ne "to" && $word1 ne "with") {
                    if ($word2 ne "a" && $word2 ne "an" && $word2 ne "and" && $word2 ne "by" && $word2 ne "for"
                        && $word2 ne "from" && $word2 ne "in" && $word2 ne "of" && $word2 ne "on" && $word2 ne "or" && $word2 ne "out" && $word2 ne "the" && $word2 ne "to" && $word2 ne "with") {
                            $hoh{$word1}{$word2}++;
                        }
                }
            
        } # End while loop
    } # End if loop
    
} # End while loop, done parsing file

print "------------------------------------------------------------------\n";
print "After using regular expressions to filter through the text";
print " file,\nThe number of valid tracks in $ARGV[0] is: $numTracks\n";
print "------------------------------------------------------------------\n";

# Close the file handle
close INFILE; 

# At this point (hopefully) you will have finished processing the song 
# title file and have populated your data structure of bigram counts.
print "File parsed. The bigram model has been built.\n\n";

# NOTE to user
print "NOTE: To find the most probable song title\nbased on a word, please enter a word below.\n\n";

# User control loop
print "Enter a word [Enter 'q' to quit]: >>> ";
$input = <STDIN>;
chomp($input);
print "\n";

while ($input ne "q"){
    
    # Print everything to standard output
    print "---------------------------------------------------------------------------------\n";
    print "Most common word following the word $input: ", mcw($input) ,"\n";
    print "Number of distinct words that follow the word $input: ", num_trailing_words($input), "\n\n";
    print "Most probable song title based on the word $input: \n\n\t", make_song_title($input), "\n\n";
    print "---------------------------------------------------------------------------------\n\n";
    print "Would you like the full bigram stats on the word? (Enter yes or no) >>> ";
    $answer = <STDIN>;
    chomp($answer);
    print "\n";
    
    if ($answer eq "yes") {
        print "---------------------------------------------------------------------------------\n";
        print "Here is a list of the frequency of each unique word that follows $input:\n\n";
        print bigram_stats($input);
        print "---------------------------------------------------------------------------------\n";
        print "\n\n";
    }
    
    print "Enter a word [Enter 'q' to quit]: >>> ";
	$input = <STDIN>;
    chomp($input);
    print "\n";
}

print "Goodbye.\n";

# USER CONTROL FUNCTIONS HERE....

# Return the most common word following the word passed in as an argument to mcw
sub mcw{
    my $word = shift;
    $mcw = "";
    my $freq = 0;
    
    # Only check for most common word if there actually is a word that follows $word
    if (exists($hoh{$word})) {
        
    # Check the frequency of each word that follows $word and return word with highest frequency
        foreach $second_word (keys %{ $hoh{$word} } ) {
        if ($hoh{$word}{$second_word} > $freq) {
            $mcw = "$second_word";
            $freq = $hoh{$word}{$second_word};
        }
      }
    } # End if loop
    
    return $mcw;
} # End of mcw function

# Return song title
sub make_song_title{
    my $next_word = shift;
    my $title = "";
    my %used_words;
    my $break = 1;
    
    # Append the next most common word to the string while there is a word
    while ($break == 1 && $next_word =~ m/[a-z]/) {
        $used_words{$next_word}++;
        foreach $word (keys %used_words) {
            if ($next_word eq $word) {
                $break = 0;
            }
        }
        $title .= "$next_word ";
        $next_word = mcw($next_word);
    }
    
    return $title;
} # End of make_song_title function

# Return the number of distinct words that follow the input argument word
sub num_trailing_words{
    my $input_word = shift;
    my $count = 0;
    foreach my $second_word (keys %{ $hoh{$input_word} }) {
        $count++;
    }
    return $count;
} # End of num_trailing_words function

# Print the frequency of every unique word that follows the input argument word
sub bigram_stats{
    my $input_word = shift;
    foreach my $second_word (keys %{ $hoh{$input_word} }) {
        print "$second_word : $hoh{$input_word}{$second_word}\n";
    }
} # End of bigram_stats function
