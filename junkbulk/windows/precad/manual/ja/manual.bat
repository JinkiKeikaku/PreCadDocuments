pandoc PreCAD_windows_manual.md -o PreCAD_windows_manual.html --toc --toc-depth=3 -N --standalone --embed-resources --template=bootstrap_menu.html
rem -V tocTitle="�ڎ�"
rem --css styles.css
rem --css template.css
rem  -B nav
rem -f markdown+hard_line_breaks
if errorlevel 1 (
  pause
  goto :EOF
)
PreCAD_windows_manual.html