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

$numTracks = 0;
@words;
%hash;

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
    
    # Filter titles with non-English characters
    if($line =~ m{^[[:ascii:]]+$}) {
        $numTracks = $numTracks + 1;
    }
    
    # Split each title into words and add each unique word to hash mapped to frequency
    @words = split(' ', $line);
    for $key (@words) {
        $hash{$key}++;
    }
    
	# YOUR CODE BELOW...
    
    # Hash of Hashes
    # Found this: http://perldoc.perl.org/perldsc.html
    #
    # %HashOfHash = (
    #                something => {
    #                     word1 => word2
    #                     },
    #                nothing => {
    #                     word3 => word4
    #                     },
    #                );
}

# End while loop, done parsing file

# Print the frequency of each unique word in the list of song titles
for $key (keys %hash) {
    print "$key: ", $hash{$key}, "\n";
}

print "-----------------------------------\n";
print "The number of tracks is: $numTracks\n";
print "-----------------------------------\n";

# Close the file handle
close INFILE; 

# At this point (hopefully) you will have finished processing the song 
# title file and have populated your data structure of bigram counts.
print "File parsed. Bigram model built.\n\n";


# User control loop
print "Enter a word [Enter 'q' to quit]: ";
$input = <STDIN>;
chomp($input);
print "\n";	
while ($input ne "q"){
	# Replace these lines with some useful code
	print "Not yet implemented.  Goodbye.\n";
	$input = 'q';
}

# MORE OF YOUR CODE HERE....
