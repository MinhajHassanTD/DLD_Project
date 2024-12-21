from PIL import Image

def convert_image_to_binary(image_path):
    image = Image.open(image_path)
    image = image.convert('RGB')
    pixels = list(image.getdata())

    binary_data = []
    for pixel in pixels:
        r, g, b = pixel
        binary_value = (r >> 4) << 8 | (g >> 4) << 4 | (b >> 4)
        binary_data.append(f"{binary_value:012b}")

    return binary_data

image_path = 'enemies\enemyImages\laal.png'
binary_data = convert_image_to_binary(image_path)

output_file = 'enemies\ememies_rom\laal_rom.txt'
with open(output_file, 'w') as file:
    for i, binary_value in enumerate(binary_data):
        file.write(f"rom[{i}] = 12'b{binary_value};\n")

print(f"Binary data has been written to {output_file}")

