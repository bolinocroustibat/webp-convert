#!/bin/bash

# Default values
recursive=false
delete_originals=false
quality=100

# Enhanced argument parsing
while getopts "rdq:h" opt; do
    case $opt in
        r) recursive=true ;;
        d) delete_originals=true ;;
        q) quality="$OPTARG" ;;
        h) 
            echo "Usage: $0 [-r] [-d] [-q quality] [-h] <path>"
            echo "Options:"
            echo "  -r    Recursive mode (search in subdirectories)"
            echo "  -d    Delete original files after conversion"
            echo "  -q    Quality setting (0-100, default: 100)"
            echo "  -h    Show this help message"
            echo "Example: $0 -r -d -q 80 ./public/images"
            exit 0
            ;;
        *) 
            echo "Invalid option. Use -h for help."
            exit 1
            ;;
    esac
done

# Shift to get the path argument
shift $((OPTIND-1))

# Check if a path argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 [-r] [-d] [-q quality] [-h] <path>"
    echo "Options:"
    echo "  -r    Recursive mode (search in subdirectories)"
    echo "  -d    Delete original files after conversion"
    echo "  -q    Quality setting (0-100, default: 80)"
    echo "  -h    Show this help message"
    echo "Example: $0 -r -d -q 85 ./public/images"
    exit 1
fi

# Store the path
path="$1"

# Check if the path exists
if [ ! -d "$path" ]; then
    echo "Error: Directory '$path' does not exist"
    exit 1
fi

# Set find command based on recursive flag
if [ "$recursive" = true ]; then
    find_cmd="find \"$path\""
else
    find_cmd="find \"$path\" -maxdepth 1"
fi

convert_to_webp() {
    local file="$1"
    local ext="${file##*.}"
    local output="${file%.*}.webp"
    local converter="cwebp"
    
    # Use gif2webp for GIFs
    if [ "${ext,,}" = "gif" ]; then
        converter="gif2webp"
    fi
    
    echo "Converting: $file"
    if $converter -q "$quality" "$file" -o "$output"; then
        if [ "$delete_originals" = true ]; then
            rm "$file"
            echo "Deleted original: $file"
        fi
    else
        echo "Error converting: $file"
        return 1
    fi
}

# Check for required commands
for cmd in cwebp gif2webp; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd is not installed. Please install webp tools."
        exit 1
    fi
done

# Single find command for all image types
echo "Converting images to WebP..."
eval "$find_cmd -type f \( -iname \"*.jpg\" -o -iname \"*.jpeg\" -o -iname \"*.png\" -o -iname \"*.gif\" \)" | 
while read -r file; do
    convert_to_webp "$file"
done

echo "Conversion complete!"
