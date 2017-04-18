import json
import struct

def unichar(i):
    try:
        return unichr(i)
    except ValueError:
        return struct.pack('i', i).decode('utf-32')


with open('emoji.json') as emoji_file:    
    all_emoji = json.load(emoji_file)

    emoji_emoji_keys = {}
    emoji_name_keys = {}
    emoji_names = []

    for emoji_name in all_emoji:
        unicode_sequence = ''.join(map(lambda emoji : unichar(int(emoji, 16)), all_emoji[emoji_name]["unicode"].split("-")))
        # unicode_sequence = "\u{" + all_emoji[emoji_name]["unicode"].replace("-", "}\u{") + "}"

    	emoji_emoji_keys[unicode_sequence] = emoji_name
    	emoji_name_keys[emoji_name] = unicode_sequence
    	emoji_names.append(emoji_name)

    with open('emoji-emoji-keys.json', 'w') as outfile:
    	json.dump(emoji_emoji_keys, outfile)

    with open('emoji-name-keys.json', 'w') as outfile:
    	json.dump(emoji_name_keys, outfile)

    with open('emoji-names.json', 'w') as outfile:
    	json.dump(emoji_names, outfile)
