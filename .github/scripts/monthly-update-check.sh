#!/usr/bin/env bash
# 月度更新检查：上游 Kristal VERSION vs 本仓库声明版本 → issue 提醒
#
# 环境变量:
#   MODE       table        README 版本表第一列（默认）
#              version-file 根目录 VERSION 文件（el/utr fork）
#              enginever    mod.json engineVer 字段
#              none         不检测版本，仅月度兜底提醒（翻译类项目）
#   RUN_MODE   daily|monthly（由 workflow 判定触发源传入）
#   UPSTREAM_REPO / UPSTREAM_BRANCH / UPSTREAM_FILE（默认 KristalTeam/Kristal main VERSION）
#
# 行为:
#   daily   : 版本落后 → upsert 落后 issue；一致 → 关闭所有 [update] issue
#   monthly : 落后 → upsert 落后 issue；一致 → upsert 当月例行巡检 issue
set -euo pipefail

: "${MODE:?MODE required (table|version-file|enginever|none)}"
: "${RUN_MODE:?RUN_MODE required (daily|monthly)}"
UPSTREAM_REPO="${UPSTREAM_REPO:-KristalTeam/Kristal}"
UPSTREAM_BRANCH="${UPSTREAM_BRANCH:-main}"
UPSTREAM_FILE="${UPSTREAM_FILE:-VERSION}"
PREFIX="[update]"
REPO="${GITHUB_REPOSITORY:-Bli-AIk/unknown}"

log() { echo "[$(date -u +%FT%TZ)] $*"; }

fetch_upstream_version() {
  gh api "repos/${UPSTREAM_REPO}/contents/${UPSTREAM_FILE}?ref=${UPSTREAM_BRANCH}" --jq '.content' 2>/dev/null \
    | base64 -d 2>/dev/null | tr -d '[:space:]' || true
}

fetch_upstream_sha() {
  gh api "repos/${UPSTREAM_REPO}/contents/${UPSTREAM_FILE}?ref=${UPSTREAM_BRANCH}" --jq '.sha' 2>/dev/null \
    | cut -c1-7 || true
}

declare_version() {
  local v=""
  case "$MODE" in
    table)
      # README 版本支持表：| [v0.10.0](...) (`abc1234`, date) | 0.1.0 |  或  | Kristal v0.10.0 | ... |
      v="$(grep -E '^\|.*v[0-9][0-9.]*(-dev)?' README.md 2>/dev/null | head -1 | grep -oE 'v[0-9][0-9.]*(-dev)?' | head -1 || true)"
      ;;
    version-file)
      v="$(cat VERSION 2>/dev/null | tr -d '[:space:]' || true)"
      ;;
    enginever)
      v="$(grep -oE '"engineVer"[[:space:]]*:[[:space:]]*"v[^"]*"' mod.json 2>/dev/null | head -1 | grep -oE 'v[^"]*' || true)"
      ;;
    none)
      v=""
      ;;
  esac
  printf '%s' "$v"
}

# 保留第一个 open [update] issue 并更新，多余关闭；无则新建
upsert_issue() {
  local title="$1" body="$2"
  mapfile -t existing < <(gh issue list --state open --limit 100 --json number,title \
    --jq '.[] | select(.title | startswith("[update]")) | .number' || true)
  if [[ ${#existing[@]} -gt 0 ]]; then
    local first="${existing[0]}"
    for ((i = 1; i < ${#existing[@]}; i++)); do
      gh issue close "${existing[$i]}" >/dev/null 2>&1 || true
    done
    gh issue edit "$first" --title "$title" --body "$body" >/dev/null 2>&1 || true
  else
    gh issue create --title "$title" --body "$body" >/dev/null 2>&1 || true
  fi
}

close_all() {
  local nums
  nums="$(gh issue list --state open --limit 100 --json number,title \
    --jq '.[] | select(.title | startswith("[update]")) | .number' || true)"
  for n in $nums; do
    gh issue close "$n" >/dev/null 2>&1 || true
  done
}

main() {
  local upstream declared month
  upstream="$(fetch_upstream_version)"
  declared="$(declare_version)"
  month="$(date -u +%Y-%m)"
  # 归一 v 前缀：上游 VERSION 文件不带 v，README 表/engineVer 带 v
  upstream="${upstream#v}"
  declared="${declared#v}"

  log "repo=${REPO} mode=${MODE} run=${RUN_MODE} upstream=${upstream} declared=${declared}"

  if [[ "$MODE" == "none" ]]; then
    if [[ "$RUN_MODE" == "monthly" ]]; then
      upsert_issue "${PREFIX} ${month}：例行月度巡检（上游 Kristal ${upstream}）" \
"**例行月度巡检**

- 上游 Kristal（${UPSTREAM_BRANCH}）版本：\`${upstream}\`
- 本仓库为翻译项目，无版本声明，请检查上游文档 / 官网是否有新内容需要翻译。"
    else
      close_all
    fi
    return
  fi

  if [[ -z "$declared" ]]; then
    log "WARN 无法从本仓库解析声明版本（MODE=${MODE}）"
  fi

  if [[ "$declared" != "$upstream" ]]; then
    log "落后：declared=${declared} upstream=${upstream}"
    local sha
    sha="$(fetch_upstream_sha)"
    local body
    body="**月度更新提醒：落后上游**

- 上游 Kristal（${UPSTREAM_BRANCH}）版本：\`${upstream}\`
- 本仓库声明：\`${declared}\`

请适配上游并更新版本声明。若仓库使用 README 版本表，表格行可替换为：

\`\`\`
| [${upstream}](https://github.com/${UPSTREAM_REPO}/commit/${sha}) (\`${sha}\`) | <你的版本> |
\`\`\`

确认适配并更新声明后，本 workflow 下次运行会自动关闭本 issue，无需手动操作。"
    upsert_issue "${PREFIX} ${month}：落后 Kristal ${upstream}（当前声明 ${declared}）" "$body"
  else
    log "一致：${declared}"
    if [[ "$RUN_MODE" == "monthly" ]]; then
      upsert_issue "${PREFIX} ${month}：例行月度巡检（上游 ${upstream}，无需更新）" \
"**例行月度巡检**

- 上游 Kristal（${UPSTREAM_BRANCH}）版本：\`${upstream}\`
- 本仓库声明：\`${declared}\`，无落后。"
    else
      close_all
    fi
  fi
}

main