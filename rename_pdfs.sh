#\!/bin/bash
find data-raw/data/canada_2022_electoral_ridings/shapefiles -name "*.pdf" -type f | while read file; do
  dir=$(dirname "$file")
  filename=$(basename "$file")
  newname=$(echo "$filename" | iconv -f utf8 -t ascii//TRANSLIT)
  if [ "$filename" \!= "$newname" ]; then
    mv "$file" "$dir/$newname"
    echo "Renamed: $file to $dir/$newname"
  fi
done
