pandoc PreCadFormat.md -o PreCadFormat.html --toc --toc-depth=2 -N --standalone --embed-resources --template=bootstrap_menu.html
rem toc-sidebar.html -B nav
rem --css template.css

rem --template=uikit.html --css styles.css
rem -V tocTitle="–ÚŽŸ"
rem --css styles.css
rem --css template.css
rem  -B nav
rem -f markdown+hard_line_breaks
if errorlevel 1 (
  pause
  goto :EOF
)
PreCadFormat.html
