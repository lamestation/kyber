#s/\$/\\$/g      # Escape dollar sign
#s/&/\\\&/g      # Escape ampersand

s/[ \t]*\././g  # Remove leading space to period
s/[ \t]*\,/,/g  # Remove leading space to period

# Fix underscores in titles

# # $ % & ~ _ ^ \ { }
s/#/\\#/g
s/\$/\\$/g
s/%/\\%/g
s/\&amp;/\\\&/g
s/~/\~/g
s/_/\\_/g
s/\^/\\^/g
s/{/\{/g
s/}/\}/g


# Final HTML entities
s/&gt;/>/g
s/&lt;/</g


# Handle 10 special latex characeters
s/((-35-))/#/g
s/((-36-))/$/g
s/((-37-))/%/g
s/((-38-))/\&/g
s/((-92-))/\\/g
s/((-94-))/^/g
s/((-95-))/_/g
s/((-123-))/{/g
s/((-125-))/}/g
s/((-126-))/~/g

