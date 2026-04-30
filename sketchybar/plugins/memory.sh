#!/bin/bash
MEM=$(python3 -c "
import subprocess, re
o = subprocess.check_output(['vm_stat']).decode()
ps = 4096
def get(k):
    m = re.search(k + r':\s+(\d+)', o)
    return int(m.group(1)) * ps if m else 0
used = (get('Pages active') + get('Pages wired down') + get('Pages occupied by compressor')) / 1024**3
total = int(subprocess.check_output(['sysctl', '-n', 'hw.memsize'])) / 1024**3
print(f'{used:.1f}/{total:.0f}G')
")
sketchybar --set "$NAME" label="$MEM"
