import os
import xml.etree.ElementTree
import json
from typing import List, Dict, Tuple
import re
import hashlib

R_FILE_NAME = 'Strings.swift'
LOCALIZED_FUNCTION = 'EDLocalizedString'
ASSET_LOG_FILE = 'assets_log.txt'

# Code Generation Template

R_TEMPLATE_PART1 = '''
extension R {
    class Strings {'''
    
R_TEMPLATE_PART2 = '''\n    }
}
'''

TEMPLATE_SINGLE_ENTRY = \
"""
\t\tstatic var {}: String {{
\t\t\treturn {}("{}", comment: "{}")
\t\t}}"""

TEMPLATE_SINGLE_ENTRY_WITH_ARGS = \
"""
\t\tstatic func {}({}) -> String {{
\t\t\treturn String(format: {}("{}", comment: "{}"), {})
\t\t}}"""

TEMPLATE_PLURALS = \
"""
\t\tstatic func {}(quantity: Int{}) -> String {{
\t\t\t{}
\t\t}}"""

TEMPLATE_IF = \
"""if quantity == {} {{
\t\t\t\treturn {}{}
\t\t\t}}
"""

DEFAULT_LANGUAGE = 'en'
PLIST_FILE = "Localizable.plist"
STRING_FILE = "Localizable.strings"
PLIST_STRING_FILE = "InfoPlist.strings"
STRING_DICT_FILE = "Localizable.stringsdict"


class StringEntry:
    key: str
    value: str
    has_arg: bool
    args: List[Tuple[str, str]]

    def __init__(self, key: str, value: str):
        self.key = key
        self.value = value
        self.args = []
        self._process()

    def extract_placeholder(s: str, index: int) -> Tuple[str, int]:
        '''
        >>> StringEntry.extract_placeholder("%1$d %2$d", 0)
        ('%1$d', 4)
        >>> StringEntry.extract_placeholder("%1$d %2$d", 5)
        ('%2$d', 4)
        >>> StringEntry.extract_placeholder("Count: %d", 7)
        ('%d', 2)
        '''
        i = index
        skip = 0
        placeholder = ''
        while True:
            placeholder += s[i]
            if i >= len(s) or s[i].isalpha():
                break
            i += 1
        return placeholder, i - index + 1

    def _process(self) -> List[Tuple[str, str]]:
        '''
        >>> e = StringEntry('test1', 'simple')
        >>> e._process()
        []

        >>> e = StringEntry('test2', 'number is %1$d, %1$d')
        >>> e._process()
        [('arg1', 'Int')]

        >>> e = StringEntry('test3', 'string %s number %d float %f')
        >>> e._process()
        [('arg1', 'String'), ('arg2', 'Int'), ('arg3', 'Float')]
        '''
        self.args = []
        if '%' in self.value:
            # with arg
            self.has_arg = True
            index = 0
            arg_count = 0
            while True:
                found = self.value.find('%', index)
                if found == -1:
                    break
                next = self.value[found + 1]
                # ignore %%
                if next == '%':
                    index = found + 2
                    continue

                extracts = StringEntry.extract_placeholder(self.value, found)
                placeholder = extracts[0]
                skip = extracts[1]

                if "$" in placeholder:
                    arg_index = int(placeholder.split("$")[0].strip('%'))
                    if arg_index <= arg_count:
                        index = found + skip
                        continue
                arg_count += 1
                arg_type = placeholder[-1]
                if arg_type == 'd':
                    self.args.append(('arg' + str(arg_count),\
                                      'Int'))
                elif arg_type == 's':
                    self.args.append(('arg' + str(arg_count),\
                                      'String'))
                elif arg_type == 'f':
                    self.args.append(('arg' + str(arg_count),\
                                      'Float'))
                index = found + skip
        else:
            # without arg
            self.has_arg = False
        return self.args

    def __repr__(self):
        return '<{}, {} {}>'.format(self.key, self.value, self.args)

    def get_string_entries(self) -> List[Tuple[str, str]]:
        # This is pretty hacky
        # but good for now
        return [(self.key, clean_string_placeholder(self.value))]

    def get_function_name(self) -> str:
        return self.key.replace('.', '_')

    def get_function_string(self) -> List[str]:
        func_name = self.key.replace('.', '_')
        value = clean_string_placeholder(self.value)
        if self.has_arg:
            params = ", ".join("_ " + x[0] + ": " + x[1] for x in self.args)
            args = ", ".join(x[0] for x in self.args)
            return [TEMPLATE_SINGLE_ENTRY_WITH_ARGS.format(func_name, params, LOCALIZED_FUNCTION, self.key, value, args)]
        else:
            return [TEMPLATE_SINGLE_ENTRY.format(func_name, LOCALIZED_FUNCTION, self.key, value)]


class PluralStringEntry:
    key: str
    entries: Dict[str, StringEntry]

    def __init__(self, key: str, text: str):
        if key.endswith('_plural'):
            key = key[:-7]
        self.key = key
        self.entries = {}
        raw = json.loads(text)
        for quantity_key in raw:
            self.entries[quantity_key] = StringEntry(key + "_" + quantity_key, raw[quantity_key])

    def __repr__(self):
        return self.key

    def get_string_entries(self) -> List[Tuple[str, str]]:
        result = []
        for e in self.entries.values():
            result.extend(e.get_string_entries())
        return result

    def get_function_string(self) -> List[str]:
        result = []
        for e in self.entries.values():
            result.extend(e.get_function_string())

        other_entry = self.entries["other"]
        params = ", " + ", ".join("_ " + x[0] + ": " + x[1] for x in other_entry.args)
        args = "(" + ", ".join(x[0] for x in other_entry.args) + ")"
        if other_entry.args == []:
            params = ""
            args = ""

        function_content = ""
        for key in self.entries:
            if key == "other":
                continue
            if key == "zero":
                body = TEMPLATE_IF.format(0, self.key + "_zero", args)
                function_content += body
            if key == "one":
                body = TEMPLATE_IF.format(1, self.key + "_one", args)
                function_content += body
        function_content += "\t\t\treturn {}{}".format(self.key + "_other", args)
        function = TEMPLATE_PLURALS.format(self.key, params, function_content)
        result.append(function)
        return result


def find_locales(target_path) -> List[str]:
    '''return all available locales by scanning the file sy
    '''
    os.chdir(os.path.join(os.getcwd(), target_path))
    locales = []
    for name in os.listdir():
        if name.endswith('.lproj'):
            locale_key = name[:name.find('.')]
            locales.append(locale_key)
    return locales


def process_locale(loc_name: str) -> List[StringEntry]:
    '''Find the file indicated by locale name and parse the entries
    inside.
    '''
    print("Prcessing {}".format(loc_name))
    entries = []
    plist_file = os.path.join(os.getcwd(), "{}.lproj".format(loc_name), PLIST_FILE)
    root = xml.etree.ElementTree.parse(plist_file).getroot()
    for element in root:
        if element.tag == 'dict':
            it = iter(element)
            for key in it:
                value = next(it)
                if value.text is None:
                    value.text = ""
                if value.text.startswith('{'):
                    entries.append(PluralStringEntry(key.text, value.text))
                else:
                    entries.append(StringEntry(key.text, value.text))
    return entries


def create_string_file(loc_name: str, entries: List[StringEntry]):
    '''Create the strings file based on locale name.
    '''
    string_file = os.path.join(os.getcwd(), "{}.lproj".format(loc_name), STRING_FILE)
    with open(string_file, 'w') as f:
        for e in entries:
            string_entries = e.get_string_entries()
            for se in string_entries:
                value = se[1]
                f.write('"{}" = "{}";\n'.format(se[0], value))
    plist_string_file = os.path.join(os.getcwd(), "{}.lproj".format(loc_name), PLIST_STRING_FILE)
    with open(plist_string_file, 'w') as f:
        for e in entries:
            string_entries = e.get_string_entries()
            for se in string_entries:
                if se[0].startswith("NS"):
                    value = se[1]
                    f.write('"{}" = "{}";\n'.format(se[0], value))


def create_r_file(entries: List[StringEntry]):
    '''Generate R extension file.
    '''
    r_file = os.path.join(os.getcwd(), R_FILE_NAME)
    with open(r_file, 'w') as f:
        f.write(R_TEMPLATE_PART1)
        for i in range(len(entries)):
            entry = entries[i]
            for x in entry.get_function_string():
                f.write(x)
                f.write('\n')
        f.write(R_TEMPLATE_PART2)


STRING_RX = r'\%\d*\$*[s]'
def clean_string_placeholder(s: str) -> str:
    '''
    >>> clean_string_placeholder('%1$s %s %d -> %2$s')
    '%1$@ %@ %d -> %2$@'
    '''
    for m in re.finditer(STRING_RX, s):
        s = s[:m.end() - 1] + '@' + s[m.end():]
    return s.replace("\n", "\\n").replace('"', '\\"')


def check_if_changed(path: str, f: str) -> bool:
    last_check = ''
    try:
        with open(os.path.join(path, ASSET_LOG_FILE), 'r') as log_file:
            last_check = log_file.readline().strip()
    except:
        print("assets log file not found")

    BLOCKSIZE = 4096
    hasher = hashlib.md5()
    with open(os.path.join(path, f), 'rb') as lang_file:
        buf = lang_file.read(BLOCKSIZE)
        while len(buf) > 0:
            hasher.update(buf)
            buf = lang_file.read(BLOCKSIZE)
    curr_check = hasher.hexdigest()

    if curr_check == last_check:
        return False
    else:
        with open(os.path.join(path, ASSET_LOG_FILE), 'w') as log_file:
            log_file.write(curr_check)
        return True


if __name__ == '__main__':
    import doctest
    doctest.testmod()
    
    import sys
    if len(sys.argv) < 3:
        print("Not Enough Arguments provided")
        print("Usage: python3 [SCRIPT_NAME] [TARGET] [DESTINATION] -r [R FILE NAME] -f [String Function Name]")
    
    target_path = sys.argv[1]
    destination_path = sys.argv[2]
    if '-r' in sys.argv:
        index = sys.argv.index('-r')
        if index + 1 < len(sys.argv):
            R_FILE_NAME = sys.argv[index + 1]
    
    if '-f' in sys.argv:
        index = sys.argv.index('-f')
        if index + 1 < len(sys.argv):
            LOCALIZED_FUNCTION = sys.argv[index + 1]
    
    print("Starting Localization Parsing Script")
    print(f"Target Path: {target_path}")
    print(f"Destination Path: {destination_path}")   
    print(f"R Extension File Name: {R_FILE_NAME}")   
    print(f"Localized Function: {LOCALIZED_FUNCTION}")
    
    if not check_if_changed(target_path, "en.lproj/Localizable.plist"):
        print("No changes found")
    else:     
        print("Parsing...")
        locales = find_locales(target_path)
        for locale in locales:
            entries = process_locale(locale)
            create_string_file(locale, entries)
            print(entries)
            if locale == DEFAULT_LANGUAGE:
                create_r_file(entries)
