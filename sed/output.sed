#s/\$/\\$/g      # Escape dollar sign
#s/&/\\\&/g      # Escape ampersand
s/\$/\\$/g      # Escape dollar sign

s/[ \t]*\././g  # Remove leading space to period
s/[ \t]*\,/,/g  # Remove leading space to period

#s/_\([^{]\)/\\_\1/g   # Escape underscore
#s/\^\([^{]\)/\\^\1/g  # Escape caret
#s/#\([^{]\)/\\#\1/g   # Escape hash

# Fix underscores in titles

#/\\section/s/_/\\_/g
s/%/\\%/g
s/<div>//g
s/<\/div>//g
s/_/\\_/g

# Final HTML entities
s/#/\\#/g        # Escape hash
s/\&amp;/\\\&/g
s/&gt;/>/g
s/&lt;/</g
s/{%95%}/_/g

