#!/bin/bash
echo "== this machine =="
ls /opt /usr/local 2>/dev/null | grep -i -E "mentor|leonardo|mgc|exemplar"
[ -f ~/.ssh/id_ed25519 ] || ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519 -q
grep -qf ~/.ssh/id_ed25519.pub ~/.ssh/authorized_keys 2>/dev/null || cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys
echo "== lab machines =="
for i in $(seq -w 1 30); do
  h=o405-u$i
  r=$(timeout 6 ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=3 $h 'ls /mgc 2>/dev/null | tr "\n" " "; ls -d ~/synth >/dev/null 2>&1 && echo "[synth ok]"' 2>/dev/null)
  echo "$h: ${r:-unreachable or no /mgc}"
done
