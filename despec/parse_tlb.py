import re
import sys

def parse_ghost_minion_trace(file_path):
    # Regex designed for the new DPRINTF format
    # Matches: GHOST_MINION_INTERCEPT: VA 0x... | ReqTS: ... | EntryTS: ... | Delta: ...
    log_pattern = re.compile(
        r"GHOST_MINION_INTERCEPT: VA (0x[0-9a-fA-F]+) \| ReqTS: (\d+) \| EntryTS: (\d+) \| Delta: (\d+)"
    )

    violations = []
    
    try:
        with open(file_path, 'r') as f:
            for line in f:
                match = log_pattern.search(line)
                if match:
                    va, req_ts, entry_ts, delta = match.groups()
                    violations.append({
                        'va': va,
                        'delta': int(delta)
                    })
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        sys.exit(1)

    return violations

def print_summary(violations):
    count = len(violations)
    print("\n" + "="*40)
    print("GHOSTMINION INTERCEPT SUMMARY")
    print("="*40)
    print(f"Total Intercepts: {count}")

    if count > 0:
        deltas = [v['delta'] for v in violations]
        unique_vas = len(set(v['va'] for v in violations))

        print(f"Unique VAs Affected:      {unique_vas}")
        print(f"Max Violation Delta:      {max(deltas)} ticks")
        print(f"Min Violation Delta:      {min(deltas)} ticks")
        print(f"Avg Violation Severity:   {sum(deltas)/count:.2f} ticks")
    else:
        print("No intercepts found in the provided file.")
    print("="*40 + "\n")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 parse_tlb.py <path_to_tlb_trace.out>")
        sys.exit(1)

    data = parse_ghost_minion_trace(sys.argv[1])
    print_summary(data)