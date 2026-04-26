pandoc index.md -o index.html --toc --toc-depth=1 --template=uikit.html
rem bootstrap_menu.html
rem --template=template.html --css styles.css
pandoc index_en.md -o index_en.html --toc --toc-depth=1 --template=uikit.html
rem template=bootstrap_menu.html
rem --template=template.html --css styles.css

if errorlevel 1 (
  pause
  goto :EOF
)
index.html
index_en.html
rem pause