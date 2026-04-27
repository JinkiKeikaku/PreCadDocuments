pandoc PrecoFormat.md -o PrecoFormat.html --toc --toc-depth=3 -N --standalone --embed-resources --template=bootstrap_menu.html
pandoc PrecoFormat_en.md -o PrecoFormat_en.html --toc --toc-depth=3 -N --standalone --embed-resources --template=bootstrap_menu.html

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
PrecoFormat.html
PrecoFormat_en.html
