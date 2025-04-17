---
html:
  embed_local_images: true
  embed_svg: true
  offline: true
  toc: true
print_background: false
title: PreCad preco format
---
# PreCad coordinate file format ver 1.0 specification Rev.0
## File specifications
### Character code
- A text file with character code UTF8 (without BOM). Line break code is LF (0x0A) or CRLF (0x0D, 0x0A).

### Comments
- Anything after `#` is a comment except within a string.
- If you write `#preco` on the first line of the file, type identification will be performed when pasted via the clipboard, etc. (planned).

### Numbers
- Numbers are integers or real numbers, and the decimal point is `.` (period).
- Integers can also be expressed in hexadecimal (mainly used for colors). Hexadecimal notation starts with 0x. x and a through f are case insensitive (e.g. `0xffaa1234` or `0XCC1234AA`).

- Colors are 32-bit and the order is ARGB.

- The unit of angle is degrees, and counterclockwise is positive. However, the font slant is clockwise.

### Strings

- Strings are enclosed in `"` (double quotes).
- Strings can span multiple lines. However, newline characters are ignored. If you want to break a string, use `\n`. For example,
```
"The Martians are
coming!"
```

becomes `The Martians are coming!`. If you need a line break, use `The Martians are\n coming!`.
- If you need a `"` in the string, use `\"`. If you need a `\` in the string, use `\\`.

### Lines

- Each line specifies shapes, attributes, etc. (may span multiple lines).
- Each line is either [line coordinates](#coordinate_line) if it starts with a number, or [command line](#command_line) if it starts with an identifier, with the first identifier being the command, followed by parameters.
- Parameters can be numbers, strings, or some identifiers (color, line width, `bylayer` used in line type, `construction` used in line type, color name, etc.). Parameters are separated by at least one whitespace character (space, tab).

However, if the parameter is a string, the delimiter can be omitted (not recommended as it is difficult to read).

```
text"abcdefg"100 10#This line is OK, but not recommended. It's easier to read if there are spaces.
```
- If there are multiple parameters, you can continue writing them on the next line by adding `&` at the end of the line (`&` should be written in the same notation as the parameters).

```
line 0 0 10 10 20 20
#This cannot be written as follows.
line 0 0 10 10 20&
20
#Do as follows.
line 0 0 10 10 &
20 20
```

Example
```
#preco

line 0 0 100 0 100 -50 # lines (0,0)-(100,0)-(100,-50)
lc red # Line color is red.

# Indent is OK.
circle 0 0 100 # circle center=(0,0) radius=100
text "The Martians are coming!" 100 100 0
```

<a id="coordinate_line"></a>

#### Coordinate line

If the line starts with a number, the numbers after that are treated as coordinates and a line is drawn.
XY coordinates are separated by whitespace (space or tab). It is also possible to write multiple XY coordinates on one line.
A continuous line is drawn with one segment until there is a line other than numbers, including a blank line.
The following example draws two squares (and a circle) with side lengths of 40 and 80.
This is fine if you only have lines, but if you have other shapes, we recommend using the [line](#line) or [polyline](#polyline) commands.

```
-20 -20
20 -20
20 20
-20 20
-20 -20

-40 -40 40 -40 40 40 -40 40
-40 -40
circle 0 0 50
```

<a id="command_line"></a>

#### Command line

A command line begins with a command, followed by parameters.
Some parameters can be omitted. If a parameter is omitted, it may have a special meaning or a default value may be used. Parameters are separated by spaces, so you cannot omit only a parameter in the middle of a set of multiple parameters.

Parameters in this specification follow the following notation:
- Optional parameters are enclosed in `[]`.
- If the omitted parameter has a default value, enter it on the right side with `=`.

In the example below, x, y, and radius cannot be omitted, but if angle is omitted, angle=0.0, and if flatness is also omitted, flatness=1.0, angle=0.0.

`circle x y radius [flatness=1.0] [angle=0.0]`

Also, in the example below, x and y cannot be omitted alone, but the pair of x and y can be omitted.

`p0 [x y]`

### Terminology

#### Attributes

Color, line type, and line width of shapes.

#### Current Attributes

Currently selected color, line type, and line width on the PreCad toolbar.

Color is called current line color, current text color, current fill color, etc., depending on the element.

The same applies to fonts, such as the current font name.

#### Current layer

The layer selected in the PreCad layer list for writing.

#### Paper size/actual size

The size displayed on the paper is the paper size, and the actual size is the size divided by the scale.

Line width is always written in paper size.

## Command description

### Control command

#### ps

`ps f`

When `f` is 0, the coordinates and length are actual size, and when `f` is 1, the paper size. The initial value is 0 (actual size).
Do not use during grouping.

#### p0

`p0 [x y]`
Sets the coordinates specified with the mouse to (x, y).
This is the same as offsetting the coordinates by (-X, -Y). The coordinate values ​​set are affected by the [ps](#ps) command.
The initial value is (0, 0).
If no parameters are used, it returns to the initial value (0, 0).
Do not use during grouping.
Please note that the value of the `p0` command is added (you probably won't use multiple commands).
```
p0 100 50
line 100 50 200 50 # Draw a line 100 to the right from the mouse position.
p0 10 20 # Coordinates are (100+10, 50+20)
line 100 50 200 50 # Draw a line 100 to the right from the mouse position at (-10, -20).
p0 # Initialization
line 100 50 200 50 # Draw a line 100 to the right from the mouse position at (100, 50).
```

### Document commands
Commands related to document structure.
#### layer

`layer [name]`
Sets the writing layer to the layer `name`. `name` is a string. If there is no layer name, the current layer will be the writing layer.
The default is the current layer.
If the layer with `name` does not exist, a new layer with that name will be created.
Do not use during grouping.
```
layer "Layer1" # Select layer name "Layer1"
layer # Select current layer
```

### Attribute commands

Commands to specify shape attributes such as color and line type.

#### lc

`lc [color]`
Sets the line color to be used for subsequent shapes. If there is no `color`, the current line color will be used.
The default is black (0xff000000).
`color` can be an integer value (32-bit, including alpha) or several defined values.
| name | definition |
|-----|------|
| bylayer| layer color |
| black | black (0xff000000) |
| blue | blue (0xff0000ff) |
| red | red (0xffff0000) |
| magenta | purple (0xffff00ff) |
| green | green (0xff00ff00) |
| cyan | light blue (0xff00ffff) |
| yellow | yellow (0xffffff00) |
| white | white (0xffffffff) |
| gray | gray (0xff808080) |
| lightgray | light gray (0xffd3d3d3) |
| darkgray | dark gray (0xffa9a9a9) |
| transparent | transparent (0x00ffffff) |

```
lc 4294901760 # 0xffff0000 (red). 32 bits, starting from the upper, ARGB
lc 0xffff0000 # Hexadecimal notation (red). x and a to f can be capital letters
lc red # Red
lc bylayer # Layer line color
lc # Current line color
```

#### lt

`lt [name]`
Sets the line type to be used for subsequent shapes. If `name` is not specified, the current line type is used.
The default is a solid line.
bylayer is the layer line type, construction is the auxiliary line, and if it is a string, it is the line type name.
The line type name is based on the table below.

| Line type name | Pattern | Description |
|-----|------|-----|
|solid| None | Solid line|
|dashed| 12.0, 3.0 | Dashed line|
|dash_space| 12.0, 12.0 | Dash-dash space|
|center| 24.0, 3.0, 7.0, 3.0| Dash-dash line|
|phantom| 24.0, 3.0, 7.0, 3.0, 7.0, 3.0| Dash-dash line with two dots|
|long-dash_dot| 24.0, 3.0, 0.5, 3.0| Long dash-dash line|
|long-dash_2dot| 24.0, 3.0, 0.5, 3.0, 0.5, 3.0| Two-point long dashed line |
|long-dash_3dot| 24.0, 3.0, 0.5, 3.0, 0.5, 3.0, 0.5, 3.0| Two-dot long dash line|
|dot| 0.5, 3.0| Dotted line|
|dash_dot| 12.0, 3.0, 0.5, 3.0| Short dashed line|
|2dash_dot| 12.0, 3.0, 12.0, 3.0, 0.5, 3.0| Two short dashed lines|
|dash_2dot| 12.0, 3.0, 0.5, 3.0, 0.5, 3.0| Short dashed line|
|2dash_2dot| 12.0 , 3.0, 12.0, 3.0, 0.5, 3.0, 0.5, 3.0| Two-dot two-short dash line|
|dash_3dot| 12.0, 3.0, 0.5, 3.0, 0.5, 3.0, 0.5, 3.0| Three-dot two-short dash line|
|2dash_3dot| 12.0, 3.0, 12.0, 3.0, 0.5, 3.0, 0.5, 3.0, 0.5, 3.0| Three-dot two-short dash line|

*The pattern is a pair of line length and space, and the length is multiplied by the line width.
*The pattern was based on the SXF standard.
*Personally, I think I would use solid, dashed, center, phantom, or dot.
*If the line type name is not in the table above, it will be a warning rather than an error, and the line type will be solid.

```
lt "solid" # Solid line
lt bylayer # Layer line type
lt construction # Construction line
lt # Current line type
```

#### lw

`lw [width]`
Sets the line width to be used for subsequent shapes. Line width is the dimension on the paper. If `width` is not present, the current line width is used.
The default is 0.0.
bylayer is the layer line width.

```
lw 0.25 # Thickness 0.25mm
lw bylayer # Layer line width
lw # Current line width
```

#### lz

`lz f`
If f is 1, the end and start points of the following [line](#line), [arc](#arc), [polyline](#polyline), [spline](#spline), and [bezier](#bezier) are connected (closing the shape). If `f` is 0, the end and start points are not connected.
The default is 0 (does not connect the end and start points).

#### fc

`fc [color]`
Sets the fill color to be used for subsequent shapes. The color can be specified in the same way as for `lc`.
The default is transparent.

#### mt

`mt [name]`
Sets the marker name as a string. If there is no marker name, the current marker name is used. The initial value is `"x"`. The marker name is based on the table below.
| Name | Type | Notes|
| ------ | -----|---|
| asterisk| <center>*</center> |
| circle| <center>Circle</center> |
| dot| <center>Dot</center> |Do not use size, use a setting for the size of dot. |
| plus| <center>+</center> |
| square| <center>Square</center> |
| triangle| <center>Triangle</center> |
| x| <center>X</center> |

```
mt "plus" # marker '+'
mt  # current marker
```
#### ms

`ms [size]`

Sets the marker size. The marker size is the paper size. If there is no marker size, the current marker size is used. The initial value is 2.5.
If the marker name is `dot`, this size will not be used.
*The marker size is the paper size, so care must be taken if [ps](#ps) is 0.
```
ms 4 # marker size 4
ms # current marker size
```

#### tc

`tc [color]`
Sets the text color to be used for subsequent shapes. The color can be specified in the same way as [lc](#lc).
The default is black (0xff000000).

#### tb

`tb f`
The alignment of the characters. `f` is 0: bottom left, 1: bottom center, 2: bottom right, 3: center left, 4: center, 5: center right, 6: top left, 7: top center, 8: top right.

The default is 0 (bottom left).

#### fn

`fn [name]`
Specifies the font name of `name`. If `name` is not specified, the current font name is used.

The default is the current font name.

#### fh

`fh [h]`
Specifies the character height. If `h` is not specified, the current character height is used.

[ps](#ps) is 0, the size specified here is the actual size.

The default is 4.0.

#### fw

`fw [w]`
Specifies the character width ratio. If `w` is not specified, the current character width ratio is used.
The default is 1.0.

#### fs

`fs [s]`
Specifies the spacing between characters. If `s` is not specified, the current character spacing is used.
If [ps](#ps) is 0, the size specified here is actual size.
The default is 0.0.

#### fa

`fa [a]`
Specifies the font slant. Note that the font slant is positive clockwise. If `a` is not specified, the current slant is used.
The default is 0.0.

#### ff

`ff [f]`
Sets the character modification (italic, bold, etc.).
`f` is a combination of the following values:
1: Italic
2: Bold
4: Underline
8: Strikethrough
16: (Reserved: Not used)
32: (Reserved: Not used)
64: Slant text only
128: Border
If `f` is not present, the current text modification is used.
The default is 0.
#### fnt
`fnt [h] [w] [s] [a] [f]`
Sets font parameters other than the font name.
h: Text height, w: Text width ratio, s: Text spacing, a: Text slant, f: Text modification
If all parameters are omitted, the current values ​​are used. If some parameters are omitted, the parameters will not change.
For default values, see [fh](#fh), [fw](#fw), [fs](#fs), [fa](#fa), and [ff](#ff).
###　Shape commands

#### line

`line [x0 y0] [x1 y1] [x2 y2] ... [xn yn]`
Draws a line. If multiple pairs of x and y coordinates are passed as parameters, lines connecting them will be drawn.
If [lz](#lz) is 1, a line will be drawn between the end point and the start point.
Normally, two points are required for a line, but if there are fewer than two points, it will not be an error (nothing will be written). Also, an even number of parameters are required.
```
# A line connecting the coordinates (0,0), (100,0), and (100,50).
line 0 0 100 0 100 50
```

#### circle

`circle x y radius [flatness=1.0] [angle=0.0]`
Draws an ellipse with center coordinates (x,y), radius radius, flatness, and angle. It can be filled.
```
circle 0 0 100 # Circle with center (0,0) and radius 100
circle 0 0 100 0.5 # Ellipse with center (0,0), radius 100, and flatness 0.5
circle 0 0 100 0.5 30 # Ellipse with center (0,0), radius 100, flatness 0.5, and tilt 30 degrees
```

#### arc

`arc x y radius start sweep [flatness=1.0] [angle=0.0]`
Draws an elliptical arc with center coordinates (x,y), radius radius, start angle start, angle width sweep, flatness flatness, and tilt angle. It can be filled. If sweep is positive from start, it will be an arc going counterclockwise, and if it is negative, it will be a clockwise arc.
If [lz](#lz) is 1, a line will be drawn between the end point and the start point (this will be a Bézier curve, not a circular arc).

```
arc 0 0 100 30 45 # Circular arc with center (0,0), radius 100, starting angle 30, and width 45
arc 0 0 100 30 -45 0.5 # Elliptical arc with center (0,0), radius 100, starting angle 30, width -45 (45 degrees clockwise), and flattening ratio 0.5
arc 0 0 100 30 -45 0.5 30 # Elliptical arc with center (0,0), radius 100, starting angle 30, width -45 (45 degrees clockwise), flattening ratio 0.5, and tilt 30
arc 0 0 100 30 45 # Circular arc with center (0,0), radius 100, starting angle 30, and width 45
arc 0 0 100 30 -45 0.5 # An ellipse with center (0,0), radius 100, start angle 30, corner width -45 (45 degrees clockwise), and flatness 0.5.
```

#### fan

`fan x y radius start sweep [flatness=1.0] [angle=0.0]`
Draws a fan (Bézier curve) with center coordinates (x,y), radius radius, start angle start, corner width sweep, flatness flatness, and inclination angle. Can be filled.

#### polyline

`polyline [x0 y0] [x1 y1] [x2 y2] ... [xn yn]`
If multiple xy coordinate pairs are passed as parameters, lines (polylines) connecting them are drawn.
If [lz](#lz) is 1, a line is drawn between the end point and the start point.
Can be filled.

#### spline

`spline [x0 y0] [x1 y1] [x2 y2] ... [xn yn]`
When multiple pairs of xy coordinates are passed as parameters, a spline curve connecting them is drawn.

If [lz](#lz) is 1, a curve is drawn between the end point and the start point.

Can be filled.

#### bezier

`bezier x0 y0 dx0 dy0 cx1 cy1 x1 y1 [dx1 dy1 cx2 cy2 x2 y2] ... [dxn-1 dyn-1 cxn cyn xn yn]`
A cubic Bezier curve. The order is vertex, control point 1 (dx,dy), control point 2 (cx,cy), vertex. If the number of vertices is m, the total number of control points and vertices is 3*m+1.
If [lz](#lz) is 1, a straight line is drawn between the end point and the start point.

You can fill it.

#### text

`text str x y [angle=0.0]`
Draws the string str with coordinates (x,y) and angle angle. You can fill the background with the fill color.

```
text "test" 0 0
text "test" 0 0 30
```
#### marker

`marker x y [angle=0.0]`
Draws a marker with coordinates (x,y) and angle angle.
The style uses the marker type [mt](#mt), the marker size [ms](#ms), and the line attributes for color, etc. (color [lc](#lc), line width [lw](#lw), and line type [lt](#lt) are only valid for construction).

#### group

```
group
....
....
end group
```
Groups the shapes between `group` and `end group`. You can also put `group` inside `group`.
The [layer](#layer) command, [ps](#ps) command, and [p0](#p0) command cannot be used inside `group`.
If `end group` does not exist, the group shape will not be added (it is not yet decided whether to cause an error).

## History

2025/04/09
- ver 1.0 Rev.0
- First edition
