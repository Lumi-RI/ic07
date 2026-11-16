all_pass=1

for n in 1 2 3 4; do
    dir="Testcase$n"
    outdir="${dir}Diff"

    pass_dir=1
    pass_file_exist=1
    pass_pair_diff=1
    diff_exist=0


    for f in "$dir"/*.1.txt; do
        base="${f%.1.txt}"
        comp="${base}.2.txt"
        name=$(basename "$base")
        
        out="${name}Diff.txt"
        outfile="${outdir}/${out}"

	
	if cmp -s "$f" "$comp"; then
	    if [ -f "$outfile" ]; then
	        pass_file_exist=0
	    fi
	else
	    diff_exist=1
	    if [ ! -f "$outfile" ]; then
	        pass_file_exist=0
	    else #has outfile, compare
		if ! cmp -s <(diff -u "$f" "$comp" | tail -n +3) <(tail -n +3 "$outfile"); then
		    pass_pair_diff=0
		fi
	    fi
	fi
    done

    if [ "$diff_exist" -eq 1 ] && [ ! -d "$outdir" ]; then
	pass_dir=0
    fi

    if [ "$diff_exist" -eq 0 ] && [ -d "$outdir" ]; then
	pass_dir=0
    fi

    if [ "$pass_dir" -eq 1 ] && [ "$pass_file_exist" -eq 1 ] && [ "$pass_pair_diff" -eq 1 ]; then
        echo "$dir: PASS"
    else
	echo "$dir: FAIL"
	all_pass=0
    fi

done


if [ "$all_pass" -eq 1 ]; then
    exit 0
else
    exit 1
fi