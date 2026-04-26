pandoc index.md -o index.html --toc --toc-depth=1 --template=uikit.html
rem pandoc index_en.md -o index_en.html --toc --toc-depth=1 --template=bootstrap_menu.html

if errorlevel 1 (
  pause
  goto :EOF
)
index.html
rem index_en.html
rem pause