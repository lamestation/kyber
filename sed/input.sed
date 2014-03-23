# Remove meta tag from HTML because NOTHING
# can process it.
/<META/d

# Remove spurious newlines because what good
# are they? Although my stylesheet probably
# takes care of this now.
s/&nbsp;//g
