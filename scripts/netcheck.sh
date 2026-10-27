#!/usr/bin/env bash
# Network connectivity diagnostic. Prints ONLY HTTP status codes and byte counts.
# No credential, token or environment value is ever printed by this script.
OUT="${1:-netcheck.txt}"
: > "$OUT"
probe() { # name url extra-header
  local name="$1" url="$2" hdr="$3" code len
  if [ -n "$hdr" ]; then
    code=$(curl -s -o /home/kirasec/bounty/runtime/coderabbit/workspace/runs/ebe866f427574e7eb041c1f426a71d89/tmp/.p -w '%{http_code}' -m 6 -H "$hdr" "$url" 2>/dev/null)
  else
    code=$(curl -s -o /home/kirasec/bounty/runtime/coderabbit/workspace/runs/ebe866f427574e7eb041c1f426a71d89/tmp/.p -w '%{http_code}' -m 6 "$url" 2>/dev/null)
  fi
  len=$(wc -c < /home/kirasec/bounty/runtime/coderabbit/workspace/runs/ebe866f427574e7eb041c1f426a71d89/tmp/.p 2>/dev/null || echo 0)
  echo "$name -> http_code=$code bytes=$len" >> "$OUT"
  rm -f /home/kirasec/bounty/runtime/coderabbit/workspace/runs/ebe866f427574e7eb041c1f426a71d89/tmp/.p
}
echo "host=$(hostname) user=$(id -un)" >> "$OUT"
echo "--- resolv.conf ---" >> "$OUT"; cat /etc/resolv.conf >> "$OUT" 2>&1
echo "--- routes ---" >> "$OUT"; (ip route show 2>&1 || route -n 2>&1) >> "$OUT"
echo "--- addresses ---" >> "$OUT"; (ip -o addr 2>&1 || ifconfig 2>&1) >> "$OUT"
echo "--- reachability (status codes only) ---" >> "$OUT"
probe public_internet https://example.com ''
probe gcp_metadata_root http://metadata.google.internal/computeMetadata/v1/instance/ 'Metadata-Flavor: Google'
probe gcp_metadata_ip http://169.254.169.254/computeMetadata/v1/instance/ 'Metadata-Flavor: Google'
probe aws_imds http://169.254.169.254/latest/meta-data/ ''
probe k8s_api https://kubernetes.default.svc/api ''
probe k8s_api_ip https://10.0.0.1/api ''
echo "--- k8s serviceaccount dir ---" >> "$OUT"; ls -la /var/run/secrets/kubernetes.io/serviceaccount >> "$OUT" 2>&1
cat "$OUT"
