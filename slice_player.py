import os
from PIL import Image

def slice_and_crop(image_path, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    try:
        img = Image.open(image_path)
        width, height = img.size
        print(f"Sheet size: {width}x{height}")
        
        # Assuming 2x2 grid based on generation
        mid_x = width // 2
        mid_y = height // 2
        
        # Define 4 quadrants: Top-Left, Top-Right, Bottom-Left, Bottom-Right
        # Mapping to directions based on standard visual check of prev image (Front/Down, Back/Up, Left, Right)
        # Note: Usually generated grids order varies, but taking a best guess based on preview:
        # TL: Front/Down
        # TR: Back/Up
        # BL: Left
        # BR: Right
        
        quadrants = {
            "attack_down": (0, 0, mid_x, mid_y),
            "attack_up": (mid_x, 0, width, mid_y),
            "attack_left": (0, mid_y, mid_x, height),
            "attack_right": (mid_x, mid_y, width, height)
        }

        for name, box in quadrants.items():
            print(f"Processing {name}...")
            # Crop the quadrant
            quad = img.crop(box)
            
            # Auto-crop to content (bbox) to remove empty space/text if it's far
            # If text is too close to the sprite, this might keep it, but it's a good start.
            bbox = quad.getbbox()
            if bbox:
                sprite = quad.crop(bbox)
                sprite.save(os.path.join(output_dir, f"{name}.png"))
                print(f"Saved {name}.png (Size: {sprite.size})")
            else:
                print(f"Warning: {name} quadrant seems empty.")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    image_path = 'assets/images/player/warrior_attack_sheet.png'
    output_dir = 'assets/images/player'
    slice_and_crop(image_path, output_dir)
