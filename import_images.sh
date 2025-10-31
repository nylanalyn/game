#!/bin/bash
# Helper script to import ComfyUI images into your game

echo "ComfyUI Image Import Helper"
echo "============================"
echo ""

if [ $# -eq 0 ]; then
    echo "Usage: ./import_images.sh <path_to_comfyui_output_folder>"
    echo ""
    echo "This will copy all PNG/JPG images from ComfyUI output to assets/images/"
    echo "and list them so you can reference them in your story files."
    exit 1
fi

SOURCE_DIR="$1"
DEST_DIR="./assets/images"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory not found: $SOURCE_DIR"
    exit 1
fi

echo "Copying images from: $SOURCE_DIR"
echo "To: $DEST_DIR"
echo ""

# Copy PNG files
PNG_COUNT=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.png" -type f | wc -l)
if [ $PNG_COUNT -gt 0 ]; then
    echo "Copying $PNG_COUNT PNG files..."
    cp "$SOURCE_DIR"/*.png "$DEST_DIR/" 2>/dev/null
fi

# Copy JPG files
JPG_COUNT=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.jpg" -o -name "*.jpeg" -type f | wc -l)
if [ $JPG_COUNT -gt 0 ]; then
    echo "Copying $JPG_COUNT JPG files..."
    cp "$SOURCE_DIR"/*.jpg "$DEST_DIR/" 2>/dev/null
    cp "$SOURCE_DIR"/*.jpeg "$DEST_DIR/" 2>/dev/null
fi

echo ""
echo "Import complete!"
echo ""
echo "Images in assets/images/:"
echo "========================="

for img in "$DEST_DIR"/*.{png,jpg,jpeg} 2>/dev/null; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        echo "\"image\": \"res://assets/images/$filename\""
    fi
done

echo ""
echo "Copy the lines above into your story JSON files!"
