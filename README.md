# Discrete Math LaTeX Framework

This repository now contains a clean framework for creating new topic sheets without touching legacy files, with Persian output and legacy-style visuals.

## Core files

- `event.cls`: flexible Persian class with legacy-style question/solution visuals and header controls.
- `main.tex`: minimal compile-safe starter document.
- `templates/`: reusable templates for question files and question indexes.
- `scripts/new_topic.sh`: creates a full topic scaffold.
- `topics/`: generated clean topic folders.

## Compiler

Use `xelatex` (not `pdflatex`) because the class uses `xepersian`.

Example:

```bash
xelatex -interaction=nonstopmode -halt-on-error main.tex
```

## Toggles

### Show/hide solutions

In any `main.tex`, switch class options:

- Hide solutions (default):
  - `\documentclass[hidesolutions,showdate]{event}`
- Show solutions:
  - `\documentclass[showsolutions,showdate]{event}`

You can also toggle in preamble with:

- `\showsolutions`
- `\hidesolutions`

### Show/hide date in header

- Class option: `showdate` or `hidedate`
- Or preamble commands: `\showdate` / `\hidedate`

## Header fields

Set all metadata via:

```tex
\eventsetup{
  course = ریاضیات گسسته,
  topic = نظریه اعداد,
  sheet = تمرین,
  number = 2,
  title =,
  date = \today,
  datelabel = تاریخ:,
  questionlabel = سؤال,
  solutionlabel = پاسخ,
  fontpath = fonts/
}
```

For generated sheet files inside `topics/...`, `fontpath` is set automatically to the correct relative path.

## Question workflow

Each sheet has:

- `main.tex` (header + index include)
- `questions/index.tex` (list of included question files)
- `questions/q01.tex` (starter question+solution block)

Add more question files as needed and include them in `questions/index.tex`.

## Generate a new topic

From repo root:

```bash
./scripts/new_topic.sh "Number Theory"
```

This creates:

- `topics/Number Theory/Drill`
- `topics/Number Theory/Homework`
- `topics/Number Theory/Quiz`
- `topics/Number Theory/Class Problems`
- `topics/Number Theory/Alternative Problemset`
- `topics/Number Theory/Contest Problems`

Each one is immediately ready for writing tasks.
