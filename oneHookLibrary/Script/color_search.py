def get_all_colours(r_file_path):
    f = open(r_file_path)
    D = {}
    line = f.readline()
    while line:
        line = f.readline()
        if "ANY:" in line:
            comma_index = line.find(":")
            code = line[comma_index + 2:comma_index + 8]
            
            line = f.readline()
            while 'static let' not in line:
                line = f.readline()
            name_line = line.split()
            name = name_line[2]
            D[name] = code
    f.close()
    return D

def color_to_tuple(color):
    r = int(color[0:2], 16)
    g = int(color[2:4], 16)
    b = int(color[4:6], 16)
    return r, g, b
    
def compare_colors(color1, color2, threshold):
    color1 = color_to_tuple(color1)
    color2 = color_to_tuple(color2)
    return abs(color1[0] - color2[0]) <= threshold and \
           abs(color1[1] - color2[1]) <= threshold and \
           abs(color1[2] - color2[2]) <= threshold
       
def find_closest_color(colors_dict, target, threshold):
    found = False
    for name in colors_dict:
        color = colors_dict[name]
        if compare_colors(color, target, threshold):
            found = True
            print(f"Found {name} -> {color}")
    if not found:
        print("No colour found")

if __name__ == '__main__':
    
    threshold = 3
    
    import sys
    if len(sys.argv) < 3:
        print(f"Usage: python3 {sys.argv[0]} HEX [THRESHOLD] [PATH]")
    else:
        target = sys.argv[1].strip("#")
        path = sys.argv[3]
        if len(sys.argv) >= 3 and sys.argv[2].isdigit():
            threshold = int(sys.argv[2])
        print(f"Search {target} with threshold {threshold}")
        colors_dict = get_all_colours(path)
        find_closest_color(colors_dict, target, threshold)        
    
    
