#!/usr/bin/python

import sys, os, re

import struct

def unichar(i):
    try:
        return unichr(i)
    except ValueError:
        return struct.pack('i', i).decode('utf-32')

# The Emoji characters are displayed in the CharacterPalette app. It
# contains all the data we'll need, here:
apath = '/System/Library/Input Methods/CharacterPalette.app/Contents/Resources'

#
# Read the mapping from character codes to names into cdb
#

import json
import sqlite3
db = sqlite3.connect(os.path.join(apath, 'CharacterDB.sqlite3'),
                     detect_types=sqlite3.PARSE_DECLTYPES)
c = db.cursor()
c.execute('select * from unihan_dict')
cdb = {}
for code,name in c.fetchall():
  cdb[code] = re.sub(r'[|]*$', '', name)

#
# Read the list of emoji, get names from above db, and output the data
# as Javascript
#

# Current plistlib can't handle binary plists, so you need this one:
# curl -O http://bugs.python.org/file25075/plistlib.py
import plistlib
elist = plistlib.readPlist(os.path.join(apath, 'Category-Emoji.plist'))

# If verbose, prints out the list of emoji which actually displays
VERBOSE = '-v' in sys.argv

categories = [];
emoji = {};

emoji_emoji_keys = {}
emoji_name_keys = {}
emoji_names = []
emoji_to_keywords = {}

with open('emoji.json') as emoji_file:    
    all_emoji = json.load(emoji_file)

    for uni, dict_entry in all_emoji.iteritems():
      name = dict_entry["name"]
      search_entry = name + ' ' + ' '.join(dict_entry["keywords"])

      unicode_sequence = ''.join(map(lambda emoji : unichar(int(emoji, 16)), uni.split("-")))
      # unicode_sequence = "\u{" + all_emoji[emoji_name]["unicode"].replace("-", "}\u{") + "}"

      emoji_emoji_keys[unicode_sequence] = name
      emoji_name_keys[search_entry] = unicode_sequence
      emoji_to_keywords[unicode_sequence] = search_entry
      emoji_names.append(search_entry)

for d in elist['EmojiDataArray']:
  category = d['CVDataTitle'].replace('EmojiCategory-', '');
  if VERBOSE: print category
  for rec in d['CVCategoryData']['Data'].split(','):
    if rec[:2] == '0x':
      rec = (r'\U' + rec[2:].zfill(8)).decode('unicode-escape')
    ntt = re.sub(r"u'(.*)'", r"\1", repr(rec))
    ntt = re.sub(r"\\[xuU]0*([0-9a-fA-F]*)", r"\1-", ntt)
    ntt = ntt[:-1]
    if rec not in cdb:
      # probably a chord or whatever you might call it
      continue

    emoji_name = cdb[rec].lower()

    if rec in emoji_emoji_keys:
      old_search = emoji_to_keywords[rec]
      new_search = old_search + ' ' + emoji_name

      del emoji_name_keys[old_search]
      emoji_names.remove(old_search)

      emoji_names.append(new_search)
      emoji_name_keys[new_search] = rec
    else:
      emoji_names.append(emoji_name)
      emoji_name_keys[emoji_name] = rec

    emoji_emoji_keys[rec] = emoji_name

with open('emoji-emoji-keys.json', 'w') as outfile:
  json.dump(emoji_emoji_keys, outfile)

with open('emoji-name-keys.json', 'w') as outfile:
  json.dump(emoji_name_keys, outfile)

with open('emoji-names.json', 'w') as outfile:
  json.dump(emoji_names, outfile)

