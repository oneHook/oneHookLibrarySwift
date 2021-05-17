"""
Assets Script.
"""

from __future__ import annotations
import json
import os
import math
from typing import Dict, List, Set, Tuple

ColorEntry = Tuple[float, str, Tuple[int, int, int]]


class DuplicateNameError(Exception):
    """Custom error for duplicate asset name"""
    pass


# Constants
COLOR_DIFFERENCE_THRESHOLD = 5
EXTENSION_TEMPLATE = '''/* This file is auto-generated, do not modify */
import UIKit

extension {} {{\n'''
CLASS_TEMPLATE = '''class {} {{\n'''
INDENT = 4
ROOT_IMAGE_CLASS_NAME = 'Image'
ROOT_ITEMS = '_list'
ANY = 'any'
DARK = 'dark'
LIGHT = 'light'


def _color_distance(c1: ColorEntry, c2: ColorEntry):
    """
    >>> result = _color_distance((1.0, '', (255, 230, 233)), (1.0, '', (255, 229, 232)))
    >>> result - 1.41421 < 0.001
    True
    """
    a = c1[0] * 255 - c2[0] * 255
    r = c1[2][0] - c2[2][0]
    g = c1[2][1] - c2[2][1]
    b = c1[2][2] - c2[2][2]
    return math.sqrt(a ** 2 + r ** 2 + g ** 2 + b ** 2)


def _to_camel_case(s: str) -> str:
    """
    Convert given string to Camel case.
    If the string has no space or under score, it will be
    treated as Camel case thus no change will be made.

    >>> _to_camel_case('eagleDiao')
    'eagleDiao'
    >>> _to_camel_case('eagle_diao')
    'EagleDiao'
    >>> _to_camel_case('eagle diao')
    'EagleDiao'
    """
    if ' ' in s:
        names = [x.capitalize() for x in s.split()]
        return ''.join(names)
    elif '_' in s:
        names = [x.capitalize() for x in s.split('_')]
        return ''.join(names)
    return s


def _str_to_hex(s: str) -> str:
    """
    Convert given string to hex string.

    given string can be one of hex format, int, or a float between 0 and 1.

    >>> _str_to_hex('0xFf')
    'Ff'
    >>> _str_to_hex('200')
    'c8'
    >>> _str_to_hex('0.52')
    '84'
    """
    if s.startswith('0x'):
        return s[2:].zfill(2)
    if s.isdigit():
        return hex(int(s))[2:].zfill(2)
    return hex(int(float(s) * 255))[2:].zfill(2)


class Asset:
    """
    Base Asset class.
    """
    file_path: str
    file_name: str
    name: str

    def __init__(self, file_path: str) -> None:
        """
        >>> a = Asset('Assets.xcassets/image-name.imageset')
        >>> a.file_path
        'Assets.xcassets/image-name.imageset'
        >>> a.file_name
        'image-name'
        >>> a.name
        'image_name'
        """
        import ntpath
        self.file_path = file_path
        self.file_name = os.path.splitext(ntpath.basename(file_path))[0]
        self.name = self.file_name.replace('-', '_')

    def __repr__(self) -> str:
        return self.name

    def __str__(self) -> str:
        return self.name

    def to_code(self) -> List[str]:
        """
        Return a list of generated lines of code
        """
        raise NotImplementedError

    def to_name_code(self) -> str:
        """
        Return a code that store string representing the name only
        """
        return f'static let {self.name} = "{self.file_name}"'

    def __lt__(self, other):
        return self.name < other.name

    def __gt__(self, other):
        return self.name > other.name

    def __le__(self, other):
        return self.name <= other.name

    def __ge__(self, other):
        return self.name >= other.name


class ImageAsset(Asset):
    """
    Image Asset.
    """
    file_path: str
    file_name: str
    name: str

    def __init__(self, file_path: str) -> None:
        Asset.__init__(self, file_path)

    def to_code(self) -> List[str]:
        """
        >>> a = ImageAsset('ic-hello')
        >>> a.to_code()
        ['static let ic_hello = UIImage(named: "ic-hello")']
        """
        code = f'static let {self.name} = UIImage(named: "{self.file_name}")'
        return [code]


class ColorAsset(Asset):
    """
    Color Asset.
    """
    file_path: str
    file_name: str
    name: str
    colors: Dict[str, ColorEntry]
    close_colors: Dict[str, List[Tuple[str, float]]]

    def __init__(self, file_path: str) -> None:
        Asset.__init__(self, file_path)
        self.colors = {}
        self.close_colors = {}
        json_file = os.path.join(file_path, 'Contents.json')
        try:
            with open(json_file) as f:
                data = json.load(f)
                self._decode_json(data)
        except FileNotFoundError:
            pass

    def _decode_json(self, color_json: dict):
        """
        Decode xCode's Content.json to get components values.
        """
        for color in color_json['colors']:
            appearance = ANY
            if 'appearances' in color:
                appearance = color['appearances'][0]['value']
                print("FOUND", appearance)
            alpha = color['color']['components']['alpha']
            red = color['color']['components']['red']
            green = color['color']['components']['green']
            blue = color['color']['components']['blue']
            self.colors[appearance] = self._decode_color(alpha, red, green, blue)

    def _decode_color(self, alpha: str, red: str, green: str, blue: str) -> ColorEntry:
        """
        Translate raw string value taking from json to color entry.

        >>> a = ColorAsset('')
        >>> a._decode_color('1.0', '0xFF', '0xFF', '0xFF')
        (1.0, '#FFFFFF', (255, 255, 255))
        """
        red = _str_to_hex(red)
        green = _str_to_hex(green)
        blue = _str_to_hex(blue)
        alpha = float(alpha)
        color_str = f'#{red}{green}{blue}'.upper()
        if alpha != 1:
            color_str += ' alpha: {:.2f}'.format(alpha)
        return (alpha, color_str, (int(red, 16), int(green, 16), int(blue, 16)))

    def __repr__(self):
        return f'{self.name} {str(self.colors)}'

    def to_code(self) -> List[str]:
        """
        Return list of generated codes.
        """
        result = []
        if 'any' in self.colors:
            result.append(f'// Any: {self.colors["any"][1]}')
            for close_color in self.close_colors.get('any', []):
                result.append(f'//     Close to {close_color[0]} with {round(close_color[1], 2)}')
        if 'dark' in self.colors:
            result.append(f'// Dark: {self.colors["dark"][1]}')
            for close_color in self.close_colors.get('dark', []):
                result.append(f'//     Close to {close_color[0]} with {round(close_color[1], 2)}')

        result.append(f'static let {self.name} = UIColor(named: "{self.file_name}")!')
        return result

    def add_close_color(self, appearance: str, name: str, distance: float):
        if appearance not in self.close_colors:
            self.close_colors[appearance] = []
        self.close_colors[appearance].append((name, distance))


class AssetTree:
    """
    Tree Structure to store all assets info.
    """
    image_root: dict
    color_root: dict
    all_colors: List[ColorAsset]
    _all_colors: Dict[str, Dict[str, ColorAsset]]
    _used_image_names: Set[str]
    _used_color_names: Set[str]

    def __init__(self) -> None:
        self.image_root = {ROOT_ITEMS: []}
        self.color_root = {ROOT_ITEMS: []}
        self._used_image_names = set()
        self._used_color_names = set()
        self.all_colors = []
        self._all_colors = {}

    def _add_asset(self, segments: List[str], asset: Asset, root: dict) -> None:
        """
        Add an asset to the tree.
        """
        curr = root
        for segment in segments:
            if segment not in curr:
                curr[segment] = {ROOT_ITEMS: []}
            curr = curr[segment]
        curr[ROOT_ITEMS].append(asset)

    def add_image(self, segments: List[str], asset: ImageAsset) -> None:
        if asset.name in self._used_image_names:
            raise DuplicateNameError(f'Duplicate name found {asset.name}')
        self._used_image_names.add(asset.name)
        self._add_asset(segments, asset, self.image_root)

    def add_color(self, segments: List[str], asset: ColorAsset) -> None:
        if asset.name in self._used_color_names:
            raise DuplicateNameError(f'Duplicate name found {asset.name}')
        self._used_color_names.add(asset.name)
        self._add_asset(segments, asset, self.color_root)

        # Compare <asset> with all added colors for similarity.
        for appearance in asset.colors:
            if appearance not in self._all_colors:
                self._all_colors[appearance] = {}
            for name in self._all_colors[appearance]:
                distance = _color_distance(self._all_colors[appearance][name].colors[appearance],
                                           asset.colors[appearance])
                if distance < COLOR_DIFFERENCE_THRESHOLD:
                    self._all_colors[appearance][name].add_close_color(appearance, asset.name, distance)
                    asset.add_close_color(appearance, name, distance)
            self._all_colors[appearance][asset.name] = asset
        self.all_colors.append(asset)


def write_colors_to_file(colors: [ColorAsset], out_file: str) -> None:
    """
    Write <colors> to <out_file>.
    """
    f = open(out_file, 'w')
    f.write(EXTENSION_TEMPLATE.format('UIColor'))
    indent = ' ' * 4
    for item in colors:
        f.write('\n')
        for line in item.to_code():
            f.write(indent)
            f.write(line)
            f.write('\n')
    f.write('}')
    f.write('\n')
    f.close()


def write_assets_to_file(root: dict, out_file: str) -> None:
    """
    Write tree with root at <root> into file <out_file>.
    """
    f = open(out_file, 'w')
    f.write(EXTENSION_TEMPLATE.format('R'))
    stk = [(4, ROOT_IMAGE_CLASS_NAME, root)]
    while stk:
        indent, class_name, curr = stk.pop()
        if class_name is None:
            # Leaf nodes, write asset code
            root_items = sorted(curr)

            # Write all image names under `Image` class
            f.write((indent + 4) * ' ')
            f.write(CLASS_TEMPLATE.format('Name'))
            for item in root_items:
                f.write((indent + 8) * ' ')
                f.write(item.to_name_code())
                f.write('\n')
            f.write((indent + 4) * ' ')
            f.write('}')
            f.write('\n')

            # Write all image codes
            for item in root_items:
                for line in item.to_code():
                    f.write((indent + 4) * ' ')
                    f.write(line)
                    f.write('\n')
            f.write(indent * ' ')
            f.write('}')
            f.write('\n')
        else:
            # Internal Node, write class definition
            f.write(indent * ' ')
            f.write(CLASS_TEMPLATE.format(class_name))
            stk.append((indent, None, curr.get(ROOT_ITEMS, [])))
            names = sorted(curr.keys(), reverse=True)
            for k in names:
                if k == ROOT_ITEMS:
                    continue
                stk.append((indent + 4, k, curr[k]))
    f.write('}')
    f.write('\n')
    f.close()


def load_path(path: str, tree: AssetTree, segments: List[str] = None) -> None:
    """
    Load the asset folder at <path> into given <tree> with path <segments>
    <segments> is used to determine location within the asset tree.
    """
    lof = sorted(os.listdir(path))
    segments = [] if segments is None else segments
    for f in lof:
        file_path = os.path.join(path, f)
        if os.path.isdir(file_path):
            if file_path.endswith('.colorset'):
                tree.add_color(segments, ColorAsset(file_path))
            elif file_path.endswith('.imageset'):
                tree.add_image(segments, ImageAsset(file_path))
            else:
                new_segment = _to_camel_case(f)
                load_path(file_path, tree, segments + [new_segment])


def start(_config: Dict[str, str], /) -> None:
    """
    Start the whole process with config dict.
    """
    input_files = _config['input_files']
    tree = AssetTree()

    # load all assets into tree
    for f in input_files:
        load_path(f, tree)

    # Write to output files if file name is given
    color_out_file = _config.get('color_out', '')
    if color_out_file:
        write_colors_to_file(tree.all_colors, color_out_file)

    image_out_file = _config.get('image_out', '')
    if image_out_file:
        write_assets_to_file(tree.image_root, image_out_file)


def show_usage() -> None:
    """
    Display usage of this script.
    """
    filename = sys.argv[0][sys.argv[0].rfind('/') + 1:]
    print('=' * 20)
    print('Usage:')
    print(f'python3 {filename} -f [input file] -f [input file] -i [image asset file name] -c [color asset file name]')
    print('''* You can provide multiple input files
* but only zero or one image asset file name and
* zero or one colour asset file name''')
    print('=' * 20)


if __name__ == '__main__':
    import doctest

    doctest.testmod()

    import getopt
    import sys

    try:
        opts, args = getopt.getopt(sys.argv[1:], "f:i:c:")
    except getopt.GetoptError:
        show_usage()
        sys.exit(2)

    config = {
        'input_files': [],
        'image_out': '',
        'color_out': ''
    }
    for opt, arg in opts:
        if opt == '-f':
            config['input_files'].append(arg)
        elif opt == '-i':
            config['image_out'] = arg
        elif opt == '-c':
            config['color_out'] = arg

    # Constants For Testing
    # print(os.listdir())
    # ASSETS_PATH1 = '../../edealer-ios/eDealer/Assets/Assets.xcassets'
    # ASSETS_PATH2 = '../../edealer-ios/eDealer/Assets/ColorAssets.xcassets'

    # config['input_files'].append(ASSETS_PATH1)
    # config['input_files'].append(ASSETS_PATH2)
    # config['image_out'] = "ImageAssets.swift"
    # config['color_out'] = "ColorAssets.swift"

    if not config['input_files']:
        show_usage()
        sys.exit(2)

    start(config)

