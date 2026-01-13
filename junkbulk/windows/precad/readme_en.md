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
- This is donationware. [Development support](https://junkbulk.com/windows/precad/donate_en.html)

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
https://junkbulk.com/windows/precad/manual/en/PreCAD_windows_manual.html

## Contact information
- Mail : <a href="mailto:ai@junkbulk.com?subject=PreCad">ai@junkbulk.com</a>
- Web : https://junkbulk.com/windows/precad/index_en.html
- Donation : https://junkbulk.com/windows/precad/donate_en.html
- Copyright(c) Junkbulk (Jinki-Keikaku) 2024-2025


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

- 2025/12/14 ver. 1.8.0.0
    - Enabled mm, cm, m, and inch units. When using these units, please set them separately for coordinates and dimension shapes.
    - Grid specifications have been changed. Previous grid settings will be invalidated, so please reset them.
    - Added functions such as 10x to the calculator.
    - Fixed a bug in the image saving tool.

- 2025/08/31 ver. 1.7.2.0
    - Changed the plugin interface.
    - Changed the calculator to a scientific calculator.
    - Changed the sheet name for sfc file reading.
    - Changed the behavior when constraining polyline vertices when editing with the select tool.
    - Changed the behavior when constraining Bezier shape control points when editing with the select tool.
    - Changed so that control points follow when moving Bezier shape vertices with the select tool.
    - Fixed an issue with the arc when outputting HPGL.
- 2025/08/05 ver. 1.6.12.0
    - Fixed a freeze that occurred when selecting a page.
- 2025/08/03 ver. 1.6.11.0
    - Support UNDO for scale change.
    - Fixed a bug when switching modes in the cut line tool.
- 2025/07/26 ver. 1.6.10.0
    - Supported polyline and elliptical arc by Extend line tool and Corner tool.
    - Changed intersection processing.
    - Fixed polyline degeneracy processing.
    - Fixed a bug in partially erasing polylines.
    - Fixed a bug in the area measurement tool.
    - Fixed an issue with the CncHobby plugin.

- 2025/07/09 ver. 1.6.9.0
    - Fixed an issue where files could not be saved under certain conditions.

- 2025/07/06 ver. 1.6.8.0
    - Changed the algorithm for the Erase line tool.

- 2025/06/29 ver. 1.6.7.0
    - Added a clipping mode to the Erase line tool that leaves the clicked part.
    - The number of shapes that can be searched for intersections by the Trim tool, Erase line tool, and Extend line tool has been increased.
    - Supported the Jw_cad Unicode file.
    - Changed the display range from LIMMIN, LIMMAX to EXTMIN, EXTMAX when importing DXF.
    - Fixed polylines in block shape were sometimes filled in when importing DXF.
    - Fixed issue with MTEXT when importing DXF.
    - The conditions for whether an inverse matrix can be calculated have been relaxed a little.

- 2025/06/14 ver. 1.6.6.0
    - Changed the algorithm for the trim tool.
    - Changed the specifications for text on line tool.

- 2025/06/05 ver. 1.6.5.0
    - Changed the plugin folder.
    - Other minor changes.
- 2025/04/28 ver. 1.6.4.0
    - Added the buttons to the right-click menu.
    - Improved file loading speed.
    - Fixed an issue where shapes were not selected after pasting with the select tool.
    - Minor changes.

- 2025/04/20 ver. 1.6.3.0
    - Changed the algorithm for a circle tangent to two lines.
    - Supports changing attributes such as color and selected layer while drawing with the coordinate tool.
    - Changed the initial value of the attributes of the coordinate file to the current selected attributes.
    - Changed the priority order when pasting images etc. (for example, PNG is now given priority over EMF).
- 2025/04/13 ver. 1.6.2.0
    - When drawing, the screen will scroll if you drag it off the screen.
    - Added shape commands such as circles to the coordinate file. For commands, see https://junkbulk.com/windows/precad/download/PrecoFormat_en.html.
    - You can now check for updates from the menu.
- 2025/03/27 ver. 1.6.1.0
    - Fixed the print dialog.
    - Added an option to not change the size of the dot marker with the zoom rate.
    - Changed the marker handle to only one point.
    - Double-clicking a marker shape now displays the style dialog.
    - Marker shape can now be resized in the same way as text when using the resize option of the select tool.
- 2025/03/19 ver. 1.6.0.0
    - Added Jw_cad external transformation tool (experimental). The method of selecting shapes and the layer configuration are different from Jw_cad, but I think it works for simple things.
    - Added copy and paste settings to the edit menu.
    - When dragging the left mouse button, the screen scrolls when the cursor goes off the screen.
    - The distance and angle between two points can now be copied to the clipboard from the right button menu.
    - In the script tool, the first item is selected after the file is loaded.
    - In the script tool, an error sound is now played when you click on the screen when there is no selection.

- 2025/02/03 ver. 1.5.0.0
    - Implemented wrapping in the text frame of text shape.
    - Added text frame modes (Auto, Resize width only, Resize width and height) to text shape. Normally, "Auto" is fine.
    - Added border, equal distribution, and justification to the text style.
    - Changed to display the center point when selecting a circle and arc.
    - Changed the rectangular selection of the line cut tool to a method of specifying two points, not dragging the mouse.
    - Added the color code in the tooltip of the color button.
    - Added the summary in the tooltip of the layer style button.
    - Added anti-aliasing option to PNG save.
    - Changed the method to draw the text shape.
    - Fixed the function to obtain the color at the cursor position.
    - Fixed the display of line style and text style in the menu.
    - Fixed that the angle of the Marker was not being saved.
    - Fixed that arc dimension was not to scale.
  
- 2024/12/16 ver. 1.4.4.0
    - Fixed an issue with the alignment of text shape.
    - Changed the way the style of snapped shapes is obtained.

- 2024/12/04 ver. 1.4.3.0
    - Added ability to copy snapped line length, etc. to clipboard.
    - Added ability to obtain line style and text style of snapped shape.
    - Supports copy and paste in calculator.
    - Changed settings and options dialog to tab switching.
    - Added support for uniform width ring solid and ring solid for jww reading.
    - Fixed text position when saving jww.
    - Fixed bitmap size when saving jww.
    - Changed not to output when polyline line color is transparent when saving jww.
    - Fixed PolylineTo processing when loading emf.
    - Fixed ExtTextOutW processing when loading emf.

- 2024/11/02 ver. 1.4.2.0
    - Added an option to display bitmaps faster.
    - Added an option to display background images faster.
    - Fixed when other layers were hidden and other sheets were displayed in gray, the hidden layers were displayed in gray.
    - Fixed that single horizontal and vertical lines not be copied as bitmaps.
    - Fixed when selecting a bitmap, the display was slightly misaligned.
    - Reviewed the screen drawing method to improve memory consumption and speed.
    - Changed command processing to reduce memory consumption.

- 2024/10/29 ver. 1.4.1.0
    - Added LTSCALE settings to DXF saving.
    - Changed the specifications of the copy and paste plugin.
    - Added support for pasting text from the clipboard.
    - Change the ability to copy text such as text shape to the clipboard.
    - It is now possible to change the resolution when copying shape as a bitmap.
    - When saving text shapes to other formats, the background is now a closed polyline.
    - Fixed a problem that bitmap was not being saved correctly to the clipboard when copying.

- 2024/10/20 ver. 1.4.0.0
    - Added line types. The line type patterns were based on SFC.
    - The line type name is now displayed on the line type.
    - Dashed lines are now drawn without using the API.
    - Added an option to make dashed lines visible when zooming out.
    - Added an option to specify the edge length to the chamfer tool.
    - Supported Windows EMF file.
    - Copy and paste has been made into a plugin, and SVG and EMF can now be copied and pasted.
    - Updated the file format version from 2.5.0 to 2.6.0. In older apps, the added line types will be solid lines.
    - Fixed the font name not being written when saving SVG.
    - Changed so that the background color of the text shape is saved if possible when saving to other formats.
    - Fixed a problem with the display position when the text shape has a slant.

- 2024/9/01 ver. 1.3.1.0
    - Added support for arc in the line dimension tool, but excluded ellipse.
    - Fixed a bug with oval(2 points) tool.

- 2024/8/28 ver. 1.3.0.0
    - Added arc dimension shape.
    - The message that was displayed when a shape could not be selected with the fillet tool was incorrect, so it has been fixed.
    - Changed that a warning message is displayed when checking the minor version when loading a file.

- 2024/8/20 ver. 1.2.3.0
    - Added overlap line tool.
    - Snapping is now possible on non-editable layers.
    - Fixed bugs and changed specifications for arc shape and angle dimension shape.
    - The 3-point arc tool and 3-point angle tool can now change orientation by pressing the Ctrl key.
    - The hatch tool has been changed so that pressing the Ctrl key switches to continuous line selection mode.

- 2024/8/05 ver. 1.2.2.1
    - Fixed a bug of "Fit to Object" to zoom to the selected shapes.

- 2024/8/05 ver. 1.2.2.0
    - Fixed an issue where the shape snapped to the select tool was not selected properly.
    - Changed "Fit to Object" to zoom to the selected shapes.

- 2024/7/28 ver. 1.2.1.1
    - Fixed a bug where the toolbar line color was not displayed correctly at startup.

- 2024/7/28 ver. 1.2.1.0
    - Fixed a bug in the line erase tool.
    - Changed the timing for deselecting in the select tool.

- 2024/7/21 ver. 1.2.0.0
    - Added line intersection select mode to the line erase tool and line extension tool.
    - Added the option of how to place the background image.
    - Added wiring tool.
    - Changed the text search dialog modeless.
    - Changed how to handle cases where there is no solution for 3-point circle and 3-point arc.

- 2024/6/26 ver. 1.1.1.3
    - Changed the line erase tool to search for intersections across all layers.
    - Changed the jww file reader to be able to import old formats (file versions 2.2.3 and later).

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
