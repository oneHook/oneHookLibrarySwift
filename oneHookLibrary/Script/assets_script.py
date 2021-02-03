import os
from typing import List

ASSETS_FOLDER = ''
DESTINATION = ''
CLASS_NAME = 'Image'
TEMPLATE = 'static let {} = "{}"'
TEMPLATE_EXTENSION = """extension {} {{
{}
}}"""
CLASS_PREFIX = 'class '

def clean_name(s: str, white_space_to: str, snake_case: bool) -> str:
    """
    >>> clean_name('abc', '', False)
    'Abc'
    >>> clean_name('ab c', '_', True)
    'ab_c'
    """
    s = s.replace(' ', white_space_to)
    if snake_case:
        return s.lower()
    return s[0:1].upper() + s[1:]


def to_tree(path: str, tree: dict, images: List[str]):
    files = os.listdir(path)
    tree['root'] = []
    for file in files:
        file_path = os.path.join(path, file)
        if file.startswith('.'):
            continue
        if file.endswith('.imageset'):
            raw_file_name = file[:file.find('.')]
            tree['root'].append(raw_file_name)
            images.append(file_path)
        elif os.path.isdir(file_path):
            name = clean_name(file, '', False)
            if name not in tree:
                tree[name] = {}
            to_tree(file_path, tree[name], images)


def check_image_asset(path: str):
    import json

    files = os.listdir(path)
    content_file_path = os.path.join(path, 'Contents.json')
    with open(content_file_path) as f:
        content = json.load(f)
        images = content.get('images', [])
        scale_to_path = {}
        for image in images:
            if 'filename' in image:
                scale_to_path[image['scale']] = image['filename']
        if len(scale_to_path) < 3:
            print(f'missing scale for {path}')


def to_code(D, class_name, indent):
    if D['root'] == [] and len(D) == 1:
        return ""
    content = ""

    root_content = []
    for icon in D['root']:
        icon_text = TEMPLATE.format(icon.replace('-', '_'), icon)
        root_content.append((indent + 4) * ' ' + icon_text)

    folders = []
    for folder in D:
        if folder == 'root':
            continue
        code = to_code(D[folder], folder, indent + 4)
        folders.append(code.strip('\n'))

    folders = [x for x in folders if x != '']
    if folders:
        content += '\n\n'.join(folders)

    if root_content:
        if folders:
            content += '\n\n'
        content += '\n'.join(root_content)

    if indent == 4:
        class_prefix = 'class '
    else:
        class_prefix = CLASS_PREFIX
    content = indent * ' ' + class_prefix + class_name + ' {\n' + content + '\n' + indent * ' ' + '}'
    return content


if __name__ == '__main__':
    import doctest
    doctest.testmod()

    import sys
    if len(sys.argv) < 4:
        print('Not Enough Arguments provided')
        print(f'Usage: python3 {sys.argv[0]} [TARGET] [DESTINATION] [CLASS_NAME] -p')
        exit()


    ASSETS_FOLDER = sys.argv[1]
    DESTINATION = sys.argv[2]
    CLASS_NAME = sys.argv[3]
    if '-p' in sys.argv:
        TEMPLATE = 'public ' + TEMPLATE
        TEMPLATE_EXTENSION = 'public ' + TEMPLATE_EXTENSION
        CLASS_PREFIX = 'public ' + CLASS_PREFIX
    else:
        TEMPLATE_EXTENSION = '\n' + TEMPLATE_EXTENSION

    tree = {}
    images = []
    to_tree(ASSETS_FOLDER, tree, images)

    for image_path in images:
        check_image_asset(image_path)

    code = TEMPLATE_EXTENSION.format('R', to_code(tree, CLASS_NAME, 4))
    with open(DESTINATION, 'w') as f:
        f.write(code)


        
