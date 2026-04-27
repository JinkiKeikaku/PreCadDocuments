pandoc index.md -o index.html -N --toc --toc-depth=1 --template=uikit.html

if errorlevel 1 (
  pause
  goto :EOF
)
index.html
rem pause