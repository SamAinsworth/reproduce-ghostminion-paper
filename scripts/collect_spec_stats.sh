#!/bin/bash

cd ..
BASE=$(pwd)
SPEC_DIR="${BASE}/SPEC/benchspec/CPU2006"
BENCHMARKS="xalancbmk|cactusADM|zeusmp|astar|bwaves|bzip2|calculix|gcc|GemsFDTD|gobmk|gromacs|h264ref|hmmer|lbm|leslie3d|libquantum|milc|namd|omnetpp|povray|sjeng|soplex|tonto"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Verify the SPEC directory exists before continuing
if [ ! -d "$SPEC_DIR" ]; then
    echo "Error: Directory $SPEC_DIR does not exist."
    exit 1
fi

echo "Scanning $SPEC_DIR for benchmarks..."

for dir in "$SPEC_DIR"/*/; do
    # Skip if the directory glob didn't match anything
    [ -e "$dir" ] || continue 
    dir_name=$(basename "$dir")
    if [[ "$dir_name" =~ $BENCHMARKS ]]; then
        echo "Found matching benchmark: $dir_name"
        # Define the source paths for the two stats files
        file_ghost="$dir/run/run_base_ref_aarch64.0000/m5out/statsghostminion.txt"
        file_no="$dir/run/run_base_ref_aarch64.0000/m5out/statsno.txt"      
        dest_dir="${BASE}/results/spec/${dir_name}"
        mkdir -p "$dest_dir"

        # Copy the first file if it exists
        if [ -f "$file_ghost" ]; then
            cp "$file_ghost" "$dest_dir/statsghostminion${TIMESTAMP}.txt"
            echo "  -> Copied statsghostminion${TIMESTAMP}.txt"
        else
            echo "  -> Warning: statsghostminion.txt missing in $dir_name"
        fi

        # Copy the second file if it exists
        if [ -f "$file_no" ]; then
            cp "$file_no" "$dest_dir/statsno${TIMESTAMP}.txt"
            echo "  -> Copied statsno${TIMESTAMP}.txt"
        else
            echo "  -> Warning: statsno.txt missing in $dir_name"
        fi
    fi
done

echo "Extraction complete. Files are saved in ${BASE}/results/spec/"