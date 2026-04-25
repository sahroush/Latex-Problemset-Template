#!/usr/bin/env bash
set -euo pipefail

TOPIC_NAME="${1:-}"
TOPIC_PERSIAN="${2:-}"

if [[ -z "$TOPIC_NAME" ]]; then
  read -r -p "Topic name for folders/files (e.g. Number Theory): " TOPIC_NAME
fi

if [[ -z "$TOPIC_PERSIAN" ]]; then
  read -r -p "Topic name in Persian (e.g. نظریه اعداد): " TOPIC_PERSIAN
fi

if [[ -z "$TOPIC_NAME" || -z "$TOPIC_PERSIAN" ]]; then
  echo "Usage: $0 \"Topic Name\" \"موضوع فارسی\""
  exit 1
fi
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOPICS_DIR="$ROOT_DIR/topics"
TOPIC_DIR="$TOPICS_DIR/$TOPIC_NAME"

SHEET_EN=()
SHEET_FA=()

add_sheet() {
  SHEET_EN+=("$1")
  SHEET_FA+=("$2")
}

add_sheet "Drill" "تمرین مقدماتی"
add_sheet "Homework" "تمرین پیشرفته"
add_sheet "Quiz" "آزمونک"
add_sheet "Class Problems" "سوالات کلاسی"
add_sheet "Alternative Problemset" "سوالات جایگزین"
add_sheet "Contest Problems" "سوالات کانتست"

mkdir -p "$TOPIC_DIR"

create_sheet() {
  local sheet_name="$1"
  local sheet_label="$2"
  local sheet_dir="$TOPIC_DIR/$sheet_name"
  local questions_dir="$sheet_dir/questions"

  mkdir -p "$questions_dir"

  cat > "$sheet_dir/main.tex" <<EOF
\\documentclass[hidesolutions,showdate]{../../../event}

\\eventsetup{
  course = ریاضیات گسسته,
  topic = $TOPIC_PERSIAN,
  sheet = $sheet_label,
  title =,
  date = \\today,
  datelabel = تاریخ:,
  questionlabel = سؤال,
  solutionlabel = پاسخ,
  leftlogo = ../../../templates/uni_logo.png,
  rightlogo = ../../../templates/eng_logo.png,
  fontpath = ../../../fonts/
}

\\begin{document}
\\maketitle
\\input{questions/index.tex}
\\end{document}
EOF

  cat > "$questions_dir/index.tex" <<'EOF'
% Add/remove lines below as needed.
\input{questions/q01.tex}
EOF

  cat > "$questions_dir/q01.tex" <<'EOF'
\begin{question}
متن سؤال را اینجا بنویسید.

\begin{solution}
پاسخ را اینجا بنویسید.
\end{solution}
\end{question}
EOF
}

for i in "${!SHEET_EN[@]}"; do
  create_sheet "${SHEET_EN[$i]}" "${SHEET_FA[$i]}"
done

cat > "$TOPIC_DIR/main.tex" <<EOF
\\documentclass[hidesolutions,showdate]{../../event}

\\eventsetup{
  course = ریاضیات گسسته,
  topic = $TOPIC_PERSIAN,
  sheet = فهرست مبحث,
  number =,
  title = همه برگه‌های این موضوع,
  date = \\today,
  datelabel = تاریخ:,
  questionlabel = سؤال,
  solutionlabel = پاسخ,
  leftlogo = ../../templates/uni_logo.png,
  rightlogo = ../../templates/eng_logo.png,
  fontpath = ../../fonts/
}

\\begin{document}
\\maketitle

\\section*{برگه‌ها}
\\begin{itemize}
  \\item تمرین مقدماتی: \\texttt{$TOPIC_NAME/Drill/main.tex}
  \\item تمرین پیشرفته: \\texttt{$TOPIC_NAME/Homework/main.tex}
  \\item آزمونک: \\texttt{$TOPIC_NAME/Quiz/main.tex}
  \\item سوالات کلاسی: \\texttt{$TOPIC_NAME/Class Problems/main.tex}
  \\item سوالات جایگزین: \\texttt{$TOPIC_NAME/Alternative Problemset/main.tex}
  \\item سوالات کانتست: \\texttt{$TOPIC_NAME/Contest Problems/main.tex}
\\end{itemize}

\\end{document}
EOF

echo "Created topic scaffold: $TOPIC_DIR"
