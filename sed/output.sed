#s/\$/\\$/g      # Escape dollar sign
#s/&/\\\&/g      # Escape ampersand

s/[ \t]*\././g  # Remove leading space to period
s/[ \t]*\,/,/g  # Remove leading space to period

#s/_\([^{]\)/\\_\1/g   # Escape underscore
#s/\^\([^{]\)/\\^\1/g  # Escape caret
#s/#\([^{]\)/\\#\1/g   # Escape hash

# HTML entities
s/\&amp;/\\\&/g
s/&gt;/>/g
s/&lt;/</g
