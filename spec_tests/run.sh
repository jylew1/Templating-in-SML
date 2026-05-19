#!/bin/bash
# Automated Mustache spec test runner.
# Reads spec YAML files, converts them to JSON, then runs the SML test suite.
# Usage: bash spec_tests/run.sh  (from anywhere in the repo)

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"

# Step 1 — read YAML spec files and convert to JSON for the SML runner
python3 - <<'EOF'
import os, json, yaml

specs_dir = "spec_tests/specs"
out_dir   = "spec_tests/generated"
os.makedirs(out_dir, exist_ok=True)

for fname in sorted(os.listdir(specs_dir)):
    if not fname.endswith(".yml"):
        continue
    with open(os.path.join(specs_dir, fname), encoding="utf-8") as f:
        doc = yaml.safe_load(f)
    spec_name = fname.replace(".yml", "")
    out = {"spec": spec_name, "tests": []}
    for t in doc.get("tests", []):
        out["tests"].append({
            "name":     t.get("name", ""),
            "template": t.get("template", ""),
            "data":     t.get("data") or {},
            "expected": t.get("expected", ""),
            "partials": t.get("partials") or {}
        })
    with open(os.path.join(out_dir, spec_name + ".json"), "w") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)
    print(f"  {fname} -> generated/{spec_name}.json ({len(out['tests'])} tests)")
EOF

# Step 2 — run the SML test suite against the generated JSON files
printf 'use "spec_tests/load_spec.sml";\n' | sml
