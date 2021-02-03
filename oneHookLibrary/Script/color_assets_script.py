import os
import time

R_FILE_NAME = 'ColorAssets.swift'

ASSET_PATH = "Assets/ColorAssets.xcassets"
DARK_MODE_ASSET_PATH = "Assets/ColorAssets.xcassets/DarkMode"
DESTINATION = "Assets"


FILE_TEMPLATE = """import UIKit

extension UIColor {{
{}
}}
"""
CODE_TEMPLATE = """
    /* 
    {}
    */
    static let {} = UIColor(named: "{}")!"""

def to_hex(a, r, g, b):
    def normalize(v):
        if '.' in v:
            return "{:x}".format(int(float(v) * 255)).upper()        
        if v.startswith('0'):
            return v[2:]
        return "{:x}".format(int(v)).upper()
    a = normalize(a)
    r = normalize(r)
    g = normalize(g)
    b = normalize(b)
    if a == 'FF':
        return r + g + b
    else:
        return a + r + g + b


def decode_color(color):
    raw_alpha = color['components']['alpha']
    raw_red = color['components']['red']
    raw_green = color['components']['green']
    raw_blue = color['components']['blue']
    return to_hex(raw_alpha, raw_red, raw_green, raw_blue)


def decode_color_file(filename: str):
    print(filename)
    import json
    appearances = {}    
    with open(filename) as json_file:
        data = json.load(json_file)
        colors = data['colors']
        for color in colors:
            if 'appearances' in color:
                key = color['appearances'][0]['value']
                appearances[key] = decode_color(color['color'])                
            else:
                appearances['any'] = decode_color(color['color'])
    return appearances


def dict_to_comment(appearances):
    keys = sorted(list(appearances.keys()))
    comments = []
    for k in keys:
        comments.append('{}: {}'.format(k.upper(), appearances[k]))
    return '    '.join(comments)
        
    
def get_color_names(path: str):
    names = []
    files = os.listdir(path)
    for file in files:
        if file.endswith('.colorset'):
            result = decode_color_file(os.path.join(path, file, 'Contents.json'))
            name = file[:file.find('.')]
            comment = dict_to_comment(result)
            names.append((name, comment))
    return names

def check_similar(names):
    D = {}
    for name in names:
        code = name[1].split()[1]
        D[name[0]] = code
    from color_search import compare_colors
    
    
    for i in range(len(names)):
        entry = names[i]
        target = entry[1].split()[1]
        similars = []
        for name in D:
            if name != entry[0]:
                if compare_colors(target, D[name], 3):
                    similar = f"    close to {name} {D[name]}"
                    similars.append(similar)
        if similars:
            names[i] = (names[i][0], names[i][1] + "\n" + "\n".join(similars))

def generate():
    names_regular = get_color_names(ASSET_PATH)
    names_dark_mode = get_color_names(DARK_MODE_ASSET_PATH)
    names = names_regular + names_dark_mode
    names.sort()
    check_similar(names)
    codes = [CODE_TEMPLATE.format(x[1], x[0], x[0]) for x in names]
    code = FILE_TEMPLATE.format('\n'.join(codes))
    with open(DESTINATION, 'w') as f:
        f.write(code)
    
if __name__ == '__main__':
    start = time.process_time()

    import sys
    if len(sys.argv) < 4:
        print('Not Enough Arguments provided')
        print(f'Usage: python3 {sys.argv[0]} [TARGET] [DARK_TARGET] [DESTINATION] -r [R FILE NAME]')
        exit()

    ASSET_PATH = sys.argv[1]
    DARK_MODE_ASSET_PATH = sys.argv[2]
    DESTINATION = f'{sys.argv[3]}/{R_FILE_NAME}'
    if '-r' in sys.argv:
        index = sys.argv.index('-r')
        if index + 1 < len(sys.argv):
            R_FILE_NAME = sys.argv[index + 1]

    print("Starting Color Parsing")
    print(f'Traget Path: {ASSET_PATH}')
    print(f'Traget Path (Dark): {DARK_MODE_ASSET_PATH}')
    print(f'Destination Path: ${DESTINATION}')
    print(f'R Extension File Name: {R_FILE_NAME}')

    generate()
    print("Time consumed {}".format(time.process_time() - start))    

