# Image to WebP Converter

A Bash script that converts batch of images from various image formats (GIF, PNG, JPG/JPEG) to WebP format. WebP offers superior compression and quality, making it ideal for web applications.

## Prerequisites

Make sure you have the following tools installed:

- `cwebp` (for converting PNG and JPG/JPEG files)
- `gif2webp` (for converting GIF files)

On Debian/Ubuntu systems, you can install these tools with:

```bash
sudo apt-get install webp
```

## Usage

```bash
./webp_convert.sh [-r] [-d] <path>
```

### Options

- `-r`: Recursive mode - processes images in subdirectories
- `-d`: Delete original files after successful conversion
- `<path>`: Directory containing the images to convert

### Example

```bash
# Convert all images in the current directory
./webp_convert.sh ./

# Convert all images recursively and delete originals
./webp_convert.sh -r -d ./public/images/

# Convert all images in a specific directory
./webp_convert.sh ./images
```

## Features

- Converts multiple image formats:
  - GIF → WebP
  - PNG → WebP
  - JPG/JPEG → WebP
- Optional recursive directory scanning
- Optional deletion of original files after conversion
- Quality setting of 80% (can be modified in the script)
- Progress feedback during conversion
- Error handling for failed conversions

## Output

The script will:
1. Create WebP versions of all supported images in the specified directory
2. Maintain the original filename with a `.webp` extension
3. Display progress and any errors during conversion
4. Optionally delete original files if requested with `-d` flag

## License

MIT
