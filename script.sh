
for n in 1 2 3 4; do
    dir="Testcase$n"
    outdir="${dir}Diff"
    rm -rf "$outdir"

    for f in "$dir"/*.1.txt; do
        base="${f%.1.txt}"
        comp="${base}.2.txt"
        name=$(basename "$base")
        
        out="${name}Diff.txt"
        outfile="${outdir}/${out}"
    
        

        if diff -u "${base}.1.txt" "${comp}"; then
            :
        else 
	    mkdir -p "$outdir"
            diff -u "${base}.1.txt" "${comp}" > "$outfile"
        fi

    done
done

echo "done"