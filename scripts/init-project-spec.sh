#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <project-slug> \"<Project Name>\" [\"<Tech Stack>\"] [\"<Workspace/Repo Path>\"]"
  exit 1
fi

PROJECT_SLUG="$1"
PROJECT_NAME="$2"
TECH_STACK="${3:-Kotlin Spring Boot, React/Angular, React Native}"
WORKSPACE_PATH="${4:-TBD}"
DATE_TODAY="$(date +%Y-%m-%d)"

PLUGIN_DIR="/Users/nitroi/.gemini/config/plugins/agentic-dev"
TEMPLATE_DIR="$PLUGIN_DIR/specs/_template"
TARGET_DIR="$PLUGIN_DIR/specs/projects/$PROJECT_SLUG"
INDEX_FILE="$PLUGIN_DIR/specs/PROJECTS_INDEX.md"

if [ -d "$TARGET_DIR" ]; then
  echo "Project spec tree already exists at: $TARGET_DIR"
  exit 1
fi

mkdir -p "$TARGET_DIR/modules"

for file in 00-overview.md 01-design.md 02-testing-playbook.md 03-implementation-stage.md; do
  sed \
    -e "s/{{PROJECT_SLUG}}/$PROJECT_SLUG/g" \
    -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s|{{TECH_STACK}}|$TECH_STACK|g" \
    -e "s/{{DATE}}/$DATE_TODAY/g" \
    "$TEMPLATE_DIR/$file" > "$TARGET_DIR/$file"
done

# Update PROJECTS_INDEX.md
ROW="| \`$PROJECT_SLUG\` | **$PROJECT_NAME** | \`Overview\` | $TECH_STACK | [specs/projects/$PROJECT_SLUG](./projects/$PROJECT_SLUG/00-overview.md) | \`$WORKSPACE_PATH\` | $DATE_TODAY |"

if grep -q "*(none yet" "$INDEX_FILE"; then
  sed -i '' "s|^|*(none yet.*|$ROW|" "$INDEX_FILE" 2>/dev/null || \
  python3 -c "
p = '$INDEX_FILE'
txt = open(p).read()
lines = [l for l in txt.splitlines() if '*(none yet' not in l]
out = []
for l in lines:
    out.append(l)
    if l.startswith('| :---'):
        out.append('''$ROW''')
open(p, 'w').write('\n'.join(out) + '\n')
"
else
  python3 -c "
p = '$INDEX_FILE'
txt = open(p).read()
lines = txt.splitlines()
out = []
inserted = False
for i, l in enumerate(lines):
    out.append(l)
    if l.startswith('| :---') and not inserted:
        out.append('''$ROW''')
        inserted = True
open(p, 'w').write('\n'.join(out) + '\n')
"
fi

echo "Created Living Spec Tree at: $TARGET_DIR"
"$PLUGIN_DIR/scripts/sync-to-github.sh" "feat(specs): initialize living spec tree for $PROJECT_SLUG ($PROJECT_NAME)"
