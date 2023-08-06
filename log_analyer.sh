if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_logfile>"
    exit 1
fi

log_file="$1"

if [ ! -f "$log_file" ]; then
    echo "Error: Log file not found: $log_file"
    exit 1
fi

total_lines=$(wc -l < "$log_file")

error_count=$(grep -c -i "ERROR" "$log_file")

mapfile -t critical_events < <(grep -n -i "CRITICAL" "$log_file")

declare -A error_messages
while IFS= read -r line; do
    error_msg=$(awk '{for (i=3; i<=NF; i++) printf $i " "; print ""}' <<< "$line")
    ((error_messages["$error_msg"]++))
done < <(grep -i "ERROR" "$log_file")


sorted_error_messages=$(for key in "${!error_messages[@]}"; do
    echo "${error_messages[$key]} $key"
done | sort -rn | head -n 5)

summary_report="log_summary_$(date +%Y-%m-%d).txt"
{
    echo "Date of analysis: $(date)"
    echo "Log file: $log_file"
    echo "Total lines processed: $total_lines"
    echo "Total error count: $error_count"
    echo -e "\nTop 5 error messages:"
    echo "$sorted_error_messages"
    echo -e "\nCritical events with line numbers:"
    for event in "${critical_events[@]}"; do
        echo "$event"
    done
} > "$summary_report"

echo "Summary report generated: $summary_report"