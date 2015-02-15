######################################### 	
#    CSCI 305 - Programming Lab #1		
#										
#  < Brandon Sladek >
#  < brandonsladek@gmail.com >
#										
#########################################

# Replace the string value of the following variable with your names.
my $name = "<Brandon Sladek>";
my $partner = "<Drew Antonich>";
print "CSCI 305 Lab 1 submitted by $name and $partner.\n\n";

# Checks for the argument, fail if none given
if($#ARGV != 0) {
    print STDERR "You must specify the file name as the argument.\n";
    exit 4;
}

# Opens the file and assign it to handle INFILE
open(INFILE, $ARGV[0]) or die "Cannot open $ARGV[0]: $!.\n";


# YOUR VARIABLE DEFINITIONS HERE...
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

print "-----------------------------------------\n";
print "The number of valid tracks is: $numTracks\n";
print "-----------------------------------------\n";

# This is how you insert and reference values in the hash of hashes

# my %yeah;
# $yeah{"Hey"}{"You"} = 5;
# $yeah{"What's"}{"Up"} = 7;

# foreach my $first ( sort keys %yeah) {
#    foreach my $second (keys %{ $yeah{$first} }) {
#        print "$first, $second: $yeah{$first}{$second}\n";
#    }
# }

# Close the file handle
close INFILE; 

# At this point (hopefully) you will have finished processing the song 
# title file and have populated your data structure of bigram counts.
print "File parsed. Bigram model built.\n\n";

# For debugging purposes ---------------------------------------------
print "The words following love are:\n";
my $count = 0;
foreach my $second_word (keys %{ $hoh{love} }) {
    print "$second_word: $hoh{love}{$second_word}\n";
    $count++;
}
print "$count\n\n";
# ---------------------------------------------------------------------

# User control loop
print "Enter a word [Enter 'q' to quit]: ";
$input = <STDIN>;
chomp($input);
print "\n";

while ($input ne "q"){
	# Replace these lines with some useful code
    print "The most common word following $input is: ", mcw($input) ,"\n";
    print make_song_title($input), "\n\n";
	print "Enter a word [Enter 'q' to quit]: ";
	$input = <STDIN>;
    chomp($input);
    print "\n";
}

print "Goodbye.\n";

# USER CONTROL FUNCTIONS HERE....

# Return the most common word following the word passed in as an argument to mcw
sub mcw{
    my $word = shift;
    $mcw;
    my $freq = 0;
    
    # Check the frequency of each word that follows $word and return word with highest frequency
    foreach $second_word (keys %{ $hoh{$word} } ) {
        if ($hoh{$word}{$second_word} > $freq) {
            $mcw = "$second_word";
            $freq = $hoh{$word}{$second_word};
        }
    }
    return $mcw;
} # End of mcw function

# Return song title
sub make_song_title{
    my $next_word = shift;
    my $title = "";
    my @title_words;
    
    # Add first word to array
    push @title_words, $next_word;
    
    # Use array for title words in order to keep track of number of words
    while ((defined mcw($next_word) and length mcw($next_word)) && @title_words <= 20) {
        $next_word = mcw($next_word);
        push @title_words, $next_word;
    }
    
    # Create string with words in title_words array
    for ($counter = 0; $counter < @title_words; $counter++) {
        $title .= "$title_words[$counter] ";
    }
    
    return $title;
} # End of make_song_title function
