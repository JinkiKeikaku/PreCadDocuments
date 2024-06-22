---
title: PreCad for Windows
---
# PreCad for Windows

## About PreCad for Windows
- PreCad is a 2DCAD that supports multi-pages.
- Supports many file formats such as dxf, jww, jwc, sfc, lcd, skc, pdf, svg, hpgl (some can only be read).
- You can use Jw_cad's line symbol transformation.
- Jw_cad parts files (*.jws) can be used as parts.
- There is also an [Android version](https://play.google.com/store/apps/details?id=com.junkbulk.precad) (but it is different because the source code and development language are different)
- This is donationware. [Development support](https://www.junkbulk.com/windows/precad/donate_en.html)

## Supported OS
- Windows10, Windows11

## Install
1. Unzip the zip file and run `PreCad_Setup.exe`.
2. When you run it, a screen will appear saying "Windows protected your PC." Click "More info" on that screen and the "Run anyway" button will appear. Press it to run the installation program.
3. The installer automatically retrieves and installs the following files. If you are installing in an environment where you cannot connect to the Internet, please download and run these files in advance.
- Microsoft Visual C++ Redistributable Package (64bit)
https://aka.ms/vs/17/release/vc_redist.x64.exe
- .NET Desktop Runtime 6.0.6(64bit)
https://download.visualstudio.microsoft.com/download/pr/9d6b6b34-44b5-4cf4-b924-79a00deb9795/2f17c30bdf42b6a8950a8552438cf8c1/windowsdesktop-runtime-6.0.6-win-x64.exe


## How to use
- See the manual in the Help menu. The latest online manual can be found at:
https://www.junkbulk.com/windows/precad/manual/en/PreCAD_windows_manual.html

## Contact information
- Mail : <a href="mailto:ai@junkbulk.com?subject=PreCad">ai@junkbulk.com</a>
- Web : https://www.junkbulk.com/windows/precad/index_en.html
- Donation : https://www.junkbulk.com/windows/precad/donate_en.html
- Copyright(c) Junkbulk (Jinki-Keikaku) 2024


## Terms of use
- This software is provided by Donationware. You can use it for free, but if you like it, please support the development.
- The author will not be held responsible for any problems that may occur due to the use of this software. Please use at your own risk.
- The author is not responsible for any support such as bug fixes or version updates for this software.
- Modification of this software and its bundled materials is prohibited.

## Others

### Running on Wine
#### Note
- The procedure described below is a record of my trial and error, and does not guarantee that it will work.
- Since gdiplus.dll is changed to the native version, other software may be affected. In that case, please return gdiplus.dll to the built-in version.
- If you don't use Japanese for drawing, I don't think you need to do anything about fonts.

#### Procedure
I confirmed booting on Ubuntu 22.04 and Wine9.0.
- Install cjk fonts with Winetricks (to prevent garbled characters in the installer. It may not be necessary in an English environment)
- Install ie8 with Winetricks (some functions cannot be used. It is not required)
- Modify the registry with the following command
```wine reg.exe ADD "HKEY_CURRENT_USER\Software\Wine\X11 Driver" "/v" "UseXVidMode" "/t" "REG_SZ" "/d" "N"```

Now you can install it for now.
However, when I start PreCad, draw a line, and enlarge the screen, I notice that the line width is strange.
So, select Run winconfig in Winetricks and add gdiplus from the libraries inside. This will make the line width normal.
However, in the native version of gdiplus, if you do not properly specify the Japanese font, Japanese characters will be garbled (Japanese characters will also be garbled with this installer. In Windows, the characters will not be garbled because they will be displayed in an alternative font. The built-in version also doesn't seem to have garbled characters.I think you'll need to edit FontLink in the registry, but that seems difficult).
If you don't have many Japanese fonts, run `winetricks allfonts` to install them (of course, you can select and install only Japanese fonts instead of all).
However, PreCad does not embed fonts in files, so if the drawing you open uses fonts that are not installed, this can be a problem. In Windows, the text is readable because an alternative font is set, but in Wine, the text is garbled. Please specify an alternative font in PreCad option. Now you can read it.

## History

- 2024/6/21 ver. 1.1.1.2
    - Fixed a bug in the circle tangent to three circles and the circle tangent to a line and two circles.

- 2024/5/20 ver. 1.1.1.1
   - Fixed an issue where main menu favorite tools and recent tools could not be used. 
   - Changed that can snap to cross points within group shape.
   - Manual updated.

- 2024/5/17 ver. 1.1.1.0
    - Fixed the free hand tool crashing.
    - Changed that shortcuts can also be set for tools.

- 2024/5/10 ver. 1.1.0.2
    - Fixed the grid origin setting button not working.
    - Changed to display a message on the screen when saving is completed.

- 2024/5/08 ver. 1.1.0.1
    - Fixed an issue that snapping could be done to invisible shapes when the sheet was invisible.

- 2024/5/07 ver. 1.1.0.0
    - Added the function to register keyboard shortcuts (as a side effect of keyboard shortcuts, favorite tools registered in previous versions will be cleared).
    - Changed that hidden layers/sheets are not displayed even when selected.
    - Added zoom to shapes display range.
    - Changed to open the calculator by pressing the space key in the numerical input area.
    - Changed the calculator button to be able to push from the keyboard's numeric keypad. However, ± is the TAB key. Equals is enter, and pressing enter again will make it OK.
    - Added the function to change the orientation using the CTRL key in the horizontal/vertical mode of the dimension line tool.
    - Supported dashed lines when saving SVG.
    - Fixed an issue where changing layer colors etc. after loading a file was not reflected immediately.
    - Fixed the issue where the Japanese manual could not be opened. However, the contents of the manual remain outdated.But the tooltips have been updated, so please refer to them.

- 2024/4/23 ver. 1.0.6.2
    - Fixed that files could not be saved correctly in areas where the decimal point was a comma.
    - Changed to reuse objects used for file save/read plugins.
    - Added ViewBox get button to SVG save.
  
- 2024/4/21 ver. 1.0.6.1
    - Added snap pause.
    - Changed so that the effective snap radius can be set.
    - Changed snap algorithm.
    - Added option to output layers and sheets as a group when saving SVG.
    - Fixed a problem with the conversion of arrows when dividing polylines.
    - Fixed a problem with the tangent to the circle.
    - Fixed a problem with the proximity points of Bezier and splines.

- 2024/4/14 ver. 1.0.5.0
    - Added line connectivity check tool.
    - Added "Below line" to the options of the text on line tool.
    - Supported duplicate layer and sheet.
    - Added duplicate page to menu.
    - Changed UNDO algorithm for layers and sheets.
    - Changed offset algorithm for straight line part of Bezier curve.
    - Supported path shape offset.
    - When a path shape is ungrouped, it is now decomposed into Bezier curves.
    - Fixed an issue where various settings popups in the status bar could not be used.
    - Fixed a bug in turning spline to polyline.
    - Changed the displayed line width when selecting lines.
    - Added strings for tooltips, etc.
    - Changed the initial value of grid division to 1. 
    - Document control tabs are now switched when adding/deleting layers, sheets, or pages.

- 2024/4/07 ver. 1.0.4.1
    - Fixed an issue where lines were sometimes dirty depending on the resolution.
    - Changed Bezier curve offset algorithm.
    - Improved calculation speed of intersection points between Bezier curves.
    - Fixed an issue where the direction of the leader line was incorrect when selecting an ellipse with the line dimension tool.
    - Add favorite tools and recently used tools.
    - The font size of the cursor coordinate display can now be changed.

- 2024/3/20 ver. 1.0.3.0
     - Supports Bezier curve and spline curve with offset tool.
     - Added ellipse options to maintain flatness and convert to Bezier curve in the offset tool.
     - Changed polyline offset algorithm.
     - Cut line tool now supports Bezier curve and spline curve.
     - Added clipping function to cut line tool.
     - Fixed an issue where the text became dirty when saving as PNG or copying PNG to the clipboard.
     - Supports pasting with DIB.
     - Unnecessary files were copied to the plugin's ja folder, so they were deleted.
 
- 2024/2/18 ver. 1.0.2.0
     - Added Ellipse on 2 lines tool.
     - Added shear option to select tool.
     - Added a flag that only slants characters in text style.
     - You can now change the auxiliary line color.
     - You can now change the pitch of the dashed line.
     - The marker dots were constant regardless of the screen magnification, but now they follow the screen magnification like normal markers.
     - The page number is now displayed in the page list.
     - Added an option to convert characters when the layer name contains non-ASCII characters when saving in DXF.
     - Enabled character width and slant angle in the Outline text tool (character spacing cannot be used).
     - Fixed an issue where the page name in the status bar did not change even if the page name was changed from the list.
     - Moved some settings dialog items to the view menu, etc.
     - Fixed an issue where snap settings could not be changed from the menu.
     - Fixed an issue where bitmaps were being read correctly when loading SakraCad and LilliCad.

- 2024/1/27 ver. 1.0.1.0
  - First release
