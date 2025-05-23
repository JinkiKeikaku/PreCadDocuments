---
html:
  embed_local_images: true
  embed_svg: true
  offline: true
  toc: true
print_background: false
title: PreCad file format
---

# PreCad file format ver 2.7.0仕様書　Rev.0
## PreCadの特徴
- PreCadは2DCADです。複数のページを作成することができます。
- 各ページにはレイヤーの他にシートがあります。シートは縮尺を設定できます。
- シートを複数使用することで縮尺の異なる部分図を作成することができます。
- PreCadのファイルは複数のファイルをZIP形式で圧縮し、拡張子をpcadとしたものです。拡張子をzipに変えて展開すると内容を確認することができます。
## ファイル構成
- PreCadの図面ファイルはインデックスファイル及び複数の図面ファイルにより構成されています。それらをzipで圧縮後、拡張子をpcadに変更したものです。そのためPreCadのファイルの拡張子をzipに変更し解凍すると構成するファイルを確認することができます。
以下はファイル構成の例です。
```
/
 ├index
 ├drawing_1.pcdt
 ├drawing_2.pcdt
 ├drawing_3.pcdt
 └media/
   ├ e87099e2-8962-4e33-9de5-87eda5b55270.jpg
   └ 01ed77be-822f-474b-a297-6d4c025ba6be.jpg
```
 
 
- インデックスファイル及び図面ファイルはテキストファイルで文字コードはUTF8です。改行コードはLF(0x0A)もしくはCRLF(0x0D, 0x0A)です。
- ファイルフォーマットはタグパラメータ形式を使用しています。タグパラメータ形式はタグの次にパラメータを()で囲み記述します。パラメータは数値、文字列、タグパラメータを複数含めることができます。パラメータの区切りは空白文字です。またパラメータがないタグも存在します。タグの出現順は一部（セクション、ページ、レイヤ、シート、図形の順序など）を除き自由です。
- タグ名は大文字小文字を区別します。
- 一部のタグには短縮形があります。この仕様書では短縮形があるものは[]で囲って併記します。
- 改行や空白などは無視されます（ただし、ファイル先頭のfiletypeは除きます）。
- //から行末まではコメントです。
- 数値は整数（Int）もしくは実数（Double）でタグごとに判断します。
- 16進整数は先頭に0xを付けます。主に色値に使います。色値は32ビットARGBです。
- 文字列はダブルクォーテーションでくくります。文字列中の行末の改行は無視されます。`\`はエスケープ文字です。改行は`\n`、タブは`\t`です。`\`の後にその他の文字が来た場合はその文字が使われます（例えばダブルクォーテーションは`\"`を使います）。
- ファイルの１行目に`filetype`タグを記入してください。
- たとえば、indexファイルは１行目に`filetype("precad_archive")`と記入します。これでファイルの種類を判別します。`filetype("precad_archive")`はタグパラメータ形式ですが、途中に空白や改行を入れず行の先頭から書いてください（ファイル種別の判別を簡略化するためです）。
- １行目のfiletypeはアプリケーション側で一行読み込んで文字列として比較しても通常のタグパラメータと同じように解析してもどちらでも問題ありません。
- mediaフォルダは画像などを同梱する時に使います。画像はこのフォルダに保存する以外に各図面ファイル内に文字列として同梱することもできます。
- 以下はタグパラメータ形式の例です。

```
filetype("sample")  //一行目はファイルタイプ。ここでは空白文字を使わないこと。
tag1(1)		//単独の数値。整数とするか実数とするかはタグの種類による。
tag2("STRING")	//単独の文字列。
tag3(10.0 15.5)	//座標。数値を空白文字で区切る。
tag4(tag1(5.5)tag2("xyz"))	//複数のタグパラメータ。
tag5(0xFF000000)	//16進数は整数として解釈する。主に色で使われる。
byLayer()	//パラメータなし。
//次の二つはどちらも同じ（順序は無関係）
tag6(tag1(5.5)tag2(123))
tag6(tag2(123)tag1(5.5))

```

## インデックスファイル
インデックスファイルのファイル名は`index`です。このファイルにページの情報と共通する設定を記入します。
- 1行目に`filetype("precad_archive")`を空白文字なしで記入してください。
- 2行目以降にfileinfo、contents、settingsのセクションが続きます。この出現順は守ってください。バージョンアップ等で新たにセクションが加わるかもしれませんので未知のセクションは読み飛ばせるようにしてください。

以下はindexファイルの例です。
```
filetype("precad_archive")
fileinfo(
 version(2.0.0)appinfo("precad for windows version 2.0.0.0")
)
contents(
 pages(
  page(
   title("Page1")drawing("drawing_1.pcdt")
  )
  page(
   title("Page2")drawing("drawing_2.pcdt")
  )
 )
)
settings(
 pageIndex(0)
 paper(name("A3")size(297 210))
 grid(p0(0.0 0.0)spacing(10.0)div(10)isScaled(0)angle(0.0))
 printInfo(printPaperSize(420.0 297.0)printCenter(0.0 0.0)printScale(2.0))
)
```
### fileinfoセクション
ファイルの情報です。

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| version(version) | version : String | フォーマットのバージョン |
| appinfo(name) | name : String | 作成したアプリの情報 |
- バージョンは2.1.0のようにメジャーバージョン、マイナ―バージョン、リビジョンを小数点で分割します。
- メジャーバージョンは大きなファイル構造の変更時に変更します。マルチページ対応時に1から2に上がりました。メジャーバージョンが上がり旧アプリで読めない場合はエラーを表示します（メジャーバージョンが上がった場合、おそらくそうなるでしょう）。
- マイナーバージョンは要素追加、タグ名の変更・削除などで変わります。この変更で新バージョンのファイルを旧バージョンで読むと情報の欠落などが起こるかもしれません。必要であれば警告を表示します。
- 読み込み時、マイナーバージョンにより処理を変えることを推奨しません。マイナーバージョンはあくまでも参考とし、追加されたタグ（もしくは廃止されたタグ）をもとに読み込みを行うべきです。
- リビジョンはその他軽微な変更で変わります。

### contentsセクション


#### pages
ページのリストです。1ページから順に並びます。

#### page
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| title(title) | title : String | 図面のタイトル |
| drawing(file) | file : String | 図面のファイル名 |
- 図面ファイルの拡張子は`pcdt`(PreCad Drawing Text)です。

### settingsセクション
設定を記述します。
```
settings(
 pageIndex(0)   
 paper(name("A3")size(297 210))rotatePaper
 grid(p0(0 0)spacing(10)div(5)isScaled(0)angle(0.0))
 printInfo(printPaperSize(420.0 297.0)printCenter(0.0 0.0)printScale(2.0))
)
```
#### pageIndex : Int
選択されていたページのインデクス（0が1ページ目）。

#### paper
用紙設定。画面上で表示される用紙のサイズで印刷用紙で無いことに注意。
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| size(width height) | width : Double,  height : Double| 用紙サイズ。|

PreCadでは以下の用紙リストから用紙を選択する。

用紙名リスト（用紙は横向きが基準）
|用紙名|サイズ(幅 x 高さ)[mm]|備考|
|--|--|--|
|Letter|279 x 216|11 x 8.5 in|
|A4|297 x 210|  |
|A3|420 x 297|  |
|A2|594 x 420|  |
|A1|841 x 594|  |
|A0|1189 x 841|  |
|2A|1682 x 1189|  |
|3A|2378 x 1682|  |
|4A|3364 x 2378|  |
|5A|4756 x 3364|  |

#### grid
グリッドの設定

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| グリッド原点 |
| spacing(s) | s : Double| グリッド間隔 |
| div(n) | n : Int| グリッド間隔をn分割 |
| isScaled(f) | f : Int| 0:グリッド間隔は用紙寸<br>1:グリッド間隔は実寸 |
| angle(s) | s : Double| グリッド角度（度） |


#### printInfo

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| printPaperSize(width height) | width : Double,  height : Double| 印刷する用紙のサイズ |
| printCenter(x y) | x : Double, y : Double| 印刷領域の中心座標 |
| printScale(scale) | scale : Double| 印刷倍率 |


## 図面ファイル
図面ファイルは各ページの図面本体です。
１行目に`filetype("precad_document")`を記入してください。これでファイルの種類を判別します。
２行目以降にfileinfo、contents、settingsのセクションが続きます。この出現順は守ってください。バージョンアップ等で新たにセクションが加わるかもしれませんので未知のセクションは読み飛ばせるようにしてください。

### fileinfoセクション
ファイルの情報です。インデックスファイルに準拠します。

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| version(version) | version : Stgring | フォーマットのバージョン |
| appinfo(name) | name : String | 作成したアプリの情報 |

### contentsセクション
レイヤ、シート、図形を記述します。
drawingファイルでは基本的に使用する要素は事前に定義されていなければいけません。したがってshapesはsheet及びlayerが必要になるのでshapesの前にlayers及びsheetsが必要になります（layersとsheetsの出現順には制約がありません）。
```
contents(
 layers(
  layer(name("テスト1")color(0xFF000000)lineWidth(0))
  layer(name("テスト2")color(0xFF000000)lineWidth(0))
 )
 sheets(
  sheet(name("シート1")scale(0.3))
  sheet(name("シート2")scale(0.3))
 )
 shapes(
  sheet("シート2")
   layer("テスト1")
    Line(...)
    Circle(...)
   layer("テスト2")
    Line(...)
  ...
 )
)        
```
#### layers
レイヤのリストです。並びは表示されるときの重ね順で下から上になります。
#### sheets
シートのリストです。並びは表示されるときの重ね順で下から上になります。
#### shapes
図形のリストです。図形以外にsheetおよびlayerタグがあらわれます。
- sheetタグで現在の書き込みシートを切り替えます。
- layerタグで現在の書き込みレイヤを切り替えます。

並びは表示されるときの重ね順で下から上になります。
#### 図形共通
- 座標及び大きさ（線幅、半径、文字サイズ等）は用紙寸です。シートの縮尺で割ることで実寸になります。
- 座標原点は用紙の中心でX軸は右が正、Y軸は上が正です。
- 角度は度(degree)です。左回りが正です。
- 図形には線種など共通する属性があります。
- 省略時の値が書かれていないパラメータもパラメータを省略できますが値は未定義です。
- 文字図形や寸法線などの文字列にはページタイトルなどに置換できるマクロ文字列を使用できます。以下のマクロ文字列が使用できます。

| マクロ文字列 |  値 |
|-----|-----|
| \$\{\$\}| \$ |
| \$\{PageTitle\}| ページのタイトル |
| \$\{PageNumber\} | ページ番号 |
| \$\{PageCount\} | 総ページ数 |
| \$\{SheetName\} | シート名|
| \$\{SheetScale\} | シートの縮尺|

#### 図形属性
図形には以下の属性があります。
<a id="lineStyle"></a>
###### lineStyle（線スタイル属性）
線のスタイル。省略時は黒、実線、線幅0です。
```
lineStyle(width(w)color(c)lineType(name)flag(f))
```

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| width(w)<br>[ w ] | w : Double | 線幅。省略時0.0 |
| color(c)<br>[ c ] | c : Int| 線色。省略時0xff000000（黒） |
| lineType(name)<br>[ t ] | name : String| 線種名。省略時実線 |
| flag(f)<br>[ f ] | f : Int| フラグ。省略時0<br>|
- 線種

| 線種名 | パターン | 説明 |
|-----|------|-----|
|solid| なし | 実線|
|dashed| 12.0, 3.0 | 破線|
|dash_space| 12.0, 12.0 | 跳び破線|
|center| 24.0, 3.0, 7.0, 3.0| 一点鎖線|
|phantom| 24.0, 3.0, 7.0, 3.0, 7.0, 3.0| 二点鎖線|
|long-dash_dot| 24.0, 3.0, 0.5, 3.0| 一点長鎖線|
|long-dash_2dot| 24.0, 3.0, 0.5, 3.0, 0.5, 3.0| 二点長鎖線|
|long-dash_3dot| 24.0, 3.0, 0.5, 3.0, 0.5, 3.0, 0.5, 3.0| 二点長鎖線|
|dot| 0.5, 3.0| 点線|
|dash_dot| 12.0, 3.0, 0.5, 3.0| 一点短鎖線|
|2dash_dot| 12.0, 3.0, 12.0, 3.0, 0.5, 3.0| 一点二短鎖線|
|dash_2dot| 12.0, 3.0, 0.5, 3.0, 0.5, 3.0| 二点短鎖線|
|2dash_2dot| 12.0, 3.0, 12.0, 3.0, 0.5, 3.0, 0.5, 3.0| 二点二短鎖線|
|dash_3dot| 12.0, 3.0, 0.5, 3.0, 0.5, 3.0, 0.5, 3.0| 三点短鎖線|
|2dash_3dot| 12.0, 3.0, 12.0, 3.0, 0.5, 3.0, 0.5, 3.0, 0.5, 3.0| 三点二短鎖線|

※パターンは線分長と空白のペアで、長さはこれに線幅を掛ける。
※パターンはSXF規格を参考にした。
- フラグ<br>1:ColorByLayer, 0x1000:補助線, 0x2000:TypeByLayer, 0x8000:WidthByLayer
- ColorByLayerの場合、線色があっても無視されます。線種と線幅も同様です。

<a id="fillStyle"></a>
######  fillStyle（塗りスタイル属性）
円や多角形の塗りのスタイルです。solid（単色）とbyLayerがあります。fillStyleのパラメータにはどちらかを指定してください。fillStyleタグが省略された場合は透明色です。
```
fillStyle(solid(0xFF00FF00))
```
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| solid(c) | c : Int| 面色。省略時、透明（アルファ値が0） |
| byLayer()| | レイヤ色。パラメータはありません。 |


<a id="arrowStyle"></a>
######  arrow, startArrow, endArrow（矢印、始点矢印、終点矢印スタイル属性）
矢印のスタイルです。省略時は矢印無し。

```
startArrow(size(3)type(1))
```
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| size(size)<br>[ s ] | size : Double | 矢印の大きさ |
| type(id)<br>[ t ] | id : Int | 矢印の種類 |

- 矢印の種類
  
| ID  | 種類 |
| ------ | -----|
| 0| なし |
| 1| 開いた矢印 |
| 2| 三角形 |
| 3| 塗りつぶした三角形 |
| 4| 円 |
| 5| 塗りつぶした円 |
| 6| 四角形 |
| 7| 塗りつぶした四角形 |
| 8| 斜め線 |
| 9| S字 |

<a id="textStyle"></a>
######  textStyle（文字スタイル）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| color(c)<br>[ c ] | c : Int | 文字色。省略時黒 |
| textAlign(a)<br>[ ta ] | a : Int | 文字配置<br>省略時0 |
| fontName(name)<br>[ fn ] | name : String | フォント名<br>省略時、空文字列 |
| fontHeight(h)<br>[ fh ] | h : Double | フォントサイズ |
| fontWidthScale(w)<br>[ fw ] | w : Double | フォント横幅比<br>省略時1 |
| fontSpace(s)<br>[ fs ] | s : Double | 文字間隔<br>省略時0 |
| fontSkewAngle(a)<br>[ fa ] | a : Double | 傾斜角<br>省略時0 |
| flag(f)<br>[ f ] | f : Int | フラグ<br>省略時0 |

- 文字配置<br> 0:左 1:中央 2:右 3:両端揃え 4:均等揃え
- フラグ
フラグは以下の値の組み合わせです。
  0x0000_0001 : | ColorByLayer
  0x0002_0000 : （予約：縦書き？）
  0x0004_0000 : イタリック
  0x0008_0000 : ボールド
  0x0010_0000 : 下線
  0x0020_0000 : 取り消し線
  0x0040_0000 : （予約：未定）
  0x0080_0000 : （予約：折り返しなし？）
  0x0100_0000 : 文字のみ傾斜
  0x0200_0000 : 枠線

- 「文字のみ傾斜」は、fontSkewAngleで文字のみを傾かせる（文字枠は長方形で文字のみ傾く）。フラグが立っていない場合は、文字枠を含め文字を歪ませる（文字枠は平行四辺形になる）。
- 枠線は、太さ0.13mmの実線（下線等と同じ扱い）。

<a id="markerStyle"></a>
###### markerStyle（点スタイル）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| type(name)<br>[ t ] | name : String | マーカー名 |
| size(s)<br>[ s ] | s : Double | サイズ |


  - マーカー名
  
| 名称  | 種類 |備考|
| ------ | -----|---|
| asterisk| <center>*</center> |
| circle| <center>円</center> |
| dot| <center>点</center> |オブジェクトのsizeを使わず、すべての点の大きさは共通の設定を使用する。|
| plus| <center>+</center> |
| square| <center>四角</center> |
| triangle| <center>三角形</center> |
| x| <center>X</center> |


<a id="leaderStyle"></a>
###### leaderStyle（引出線スタイル）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| textOffset(d)<br>[ to ] | d : Double | 文字の下線との縦方向の離れ。省略時0 |
| leaderOffset(d)<br>[ lo ] | d : Double | 引出線の終点から文字横方向の離れ。省略時0 |
| extendLine(i)<br>[ el ] | i : Int | 線を文字列まで延長。<br>0:延長なし 1:延長する<br>省略時1 |
| leaderOrientation(i)<br>[ lr ] | i : Int | 文字の配置方向。<br> 0:水平 1:平行<br>省略時0 |
| leaderBasis(i)<br>[ lb ] | i : Int | 文字の配置。<br> 0:上 1:下 2:中 3:自由<br>省略時0|
| textStyle(...)<br>[ ts ] | [文字スタイル](#textStyle)参照 | 文字スタイル |
| arrowStyle(...)<br>[ as ] | [矢印スタイル](#arrowStyle)参照 | 矢印スタイル |
| textAngle(d)<br>[ ta ] | d:Double | 文字角度。leaderBasisが3の時有効。 省略時0。|

- extendLineの省略時の値は0でないことに注意。
- leaderBasisが3の場合、leaderOffsettとtextOffsetは文字配置の相対座標。extendLine及びleaderOrientationは無視される。
- textAngleはleaderBasisが3の時のみ有効。

<a id="balloonStyle"></a>
###### balloonStyle（バルーンスタイル）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| radius(r)<br>[ r ] | r : Double | 半径 |
| textStyle(...)<br>[ ts ] | [文字スタイル](#textStyle)参照 | 文字スタイル |
| arrowStyle(...)<br>[ as ] | [矢印スタイル](#arrowStyle)参照 | 矢印スタイル |


<a id="dimensionStyle"></a>
###### dimensionStyle（直線寸法スタイル）
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| extensionLineOffset(d)<br>[ eo ] | d : Double | 引出位置から引出線までの離れ |
| extensionLineOvershoot(d)<br>[ ev ] | d : Double | 寸法線からの引出線の延長長さ |
| dimensionLineExtension(d)<br>[ de ] | d : Double | 寸法線の延長長さ |
| textStyle(...)<br>[ ts ] | [文字スタイル](#textStyle)参照 | 文字スタイル |
| textOffset(d)<br>[ to ] | d : Double | 文字の寸法線との離れ。省略時0 |
| formatStyle(...)<br>[ fs ] | [寸法値フォーマット](#formatStyle)参照 | 寸法値フォーマット |
| tolerance2LinesTextScale(s)<br>[ tt ] | s:Double | 2行の許容差の文字サイズの比率。省略時0.75 |
| startArrow(...)<br>[ sa ] | [矢印スタイル](#arrowStyle)参照 | 始点の矢印スタイル。省略時矢印なし |
| endArrow(...)<br>[ ea ] | [矢印スタイル](#arrowStyle)参照 | 終点の矢印スタイル。省略時矢印なし |
| arrowMode(m)<br>[ am ] | m:Int | 矢印モード<br>0:自動, 1:内側, 2:外側<br>省略時0 |

<a id="radiusStyle"></a>
###### radiusStyle（半径寸法スタイル）
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| dimensionLineExtension(d)<br>[de(d)] | d : Double | 寸法線の延長長さ |
| fromText(i)<br>[ ft ] | i:Int | 0：中心から円周に向けて線を引く。<br>1：文字から円周に向けての線のみ。<br>省略時0|
| textStyle(...)<br>[ ts ] | [文字スタイル](#textStyle)参照 | 文字スタイル |
| textOffset(d)<br>[ to ] | d : Double | 文字の寸法線との離れ。<br>省略時0 |
| formatStyle(...)<br>[ fs ] | [寸法値フォーマット](#formatStyle)参照 | 寸法値フォーマット |
| tolerance2LinesTextScale(s)<br>[ tt ] | s:Double | 2行の許容差の文字サイズの比率。省略時0.75 |
| arrowStyle(...)<br>[ as ] | [矢印スタイル](#arrowStyle)参照 | 矢印スタイル |
| arrowMode(m)<br>[ am ] | m:Int | 矢印モード<br>0:自動, 1:内側, 2:外側<br>省略時0 |

<a id="diameterStyle"></a>
###### diameterStyle（直径寸法スタイル）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| dimensionLineExtension(d)<br>[de(d)] | d : Double | 寸法線の延長長さ |
| textStyle(...)<br>[ ts ] | [文字スタイル](#textStyle)参照 | 文字スタイル |
| textOffset(d)<br>[ to ] | d : Double | 文字の寸法線との離れ。省略時0 |
| formatStyle(...)<br>[ fs ] | [寸法値フォーマット](#formatStyle)参照 | 寸法値フォーマット |
| tolerance2LinesTextScale(s)<br>[ tt ] | s:Double | 2行の許容差の文字サイズの比率。省略時0.75 |
| startArrow(...)<br>[ sa ] | [矢印スタイル](#arrowStyle)参照 | 始点の矢印スタイル。省略時矢印なし |
| endArrow(...)<br>[ ea ] | [矢印スタイル](#arrowStyle)参照 | 終点の矢印スタイル。省略時矢印なし |
| arrowMode(m)<br>[ am ] | m:Int | 矢印モード<br>0:自動, 1:内側, 2:外側<br>省略時0 |

<a id="arcdimensionStyle"></a>
###### arcDimensionStyle（弧長寸法スタイル）
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| extensionLineOffset(d)<br>[ eo ] | d : Double | 引出位置から引出線までの離れ |
| extensionLineOvershoot(d)<br>[ ev ] | d : Double | 寸法線からの引出線の延長長さ |
| dimensionLineExtension(d)<br>[ de ] | d : Double | 寸法線の延長長さ |
| textStyle(...)<br>[ ts ] | [文字スタイル](#textStyle)参照 | 文字スタイル |
| textOffset(d)<br>[ to ] | d : Double | 文字の寸法線との離れ。省略時0 |
| formatStyle(...)<br>[ fs ] | [寸法値フォーマット](#formatStyle)参照 | 寸法値フォーマット |
| tolerance2LinesTextScale(s)<br>[ tt ] | s:Double | 2行の許容差の文字サイズの比率。省略時0.75 |
| startArrow(...)<br>[ sa ] | [矢印スタイル](#arrowStyle)参照 | 始点の矢印スタイル。省略時矢印なし |
| endArrow(...)<br>[ ea ] | [矢印スタイル](#arrowStyle)参照 | 終点の矢印スタイル。省略時矢印なし |
| arrowMode(m)<br>[ am ] | m:Int | 矢印モード<br>0:自動, 1:内側, 2:外側<br>省略時0 |
| em(m)<br> | m : Int | 引出線モード<br>0:自動, 1:平行, 2:放射状<br>省略時0 |

- 引出線モード自動では、弧角が90度以内で平行、90度を超えると放射状になる。


<a id="formatStyle"></a>
###### formatStyle（寸法値フォーマット）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| fractionDigits(d)<br>[ fd ] | d : Int | 小数点桁数。省略時1 |
| usesGroupingSeparator(f)<br>[ gs ] | f : Int | 0:区切りなし 1:桁区切り。省略時0 |
| prefix(s)<br>[ p ] | s : String | 前置文字。省略時、半径はR、直径はΦ、弧長は⌒、その他は文字無し |
| suffix(s)<br>[ s ] | s : String | 後置文字。省略時、角度は°、その他は文字無し |

- prefix及びsuffixは図形により省略時の文字が違うことに注意。

<a id="tolerance"></a>
###### tolerance（許容差）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| toleranceType(t)<br>[ tt ] | t : Int | 許容差タイプ 0:無し 1:一段 2:二段。省略時0 |
| value0(v)<br>[ v0 ] | v : Double | 許容差上、一段の時使用 |
| value1(v)<br>[ v1 ] | v : Double | 許容差下。一段の時は省略 |
| fractionDigits(d)<br>[ fd ] | d : Int | 小数点桁数。省略時1 |
| suffix(s)<br>[ s ] | s : String | 後置文字。省略時文字無し |


#### 図形要素
##### Line（線）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| pp(x0 y0 x1 y1) | x0 : Double,  y0 : Double, <br>x1 : Double,  y1 : Double| 始点と終点 |
| p0(x y) | x : Double,  y : Double| 始点 |
| p1(x y) | x : Double,  y : Double| 終点 |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| startArrow(...)<br>[ sa ] | [矢印スタイル](#arrowStyle)参照 | 始点の矢印スタイル。省略時矢印なし |
| endArrow(...)<br>[ ea ] | [矢印スタイル](#arrowStyle)参照 | 終点の矢印スタイル。省略時矢印なし |

##### Polyline（連続線）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| vertices(x1 y1 x2 y2 x3 y3 ... xn yn)<br>[ vs ] | x1..xn : Double,  y1..yn : Double| 頂点 |
| isClosed(flag)<br>[ ic ] | flag : Int | 0:Open　1:Close 省略時0 |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 塗りスタイル。省略時塗りなし |
| startArrow(...)<br>[ sa ] | [矢印スタイル](#arrowStyle)参照 | 始点矢印。省略時矢印なし |
| endArrow(...)<br>[ ea ] | [矢印スタイル](#arrowStyle)参照 | 終点矢印。省略時矢印なし |
- isCloseが1の時は矢印スタイルは使われません。

##### Spline（スプライン曲線）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| vertices(x1 y1 x2 y2 x3 y3 ... xn yn)<br>[ vs ] | x1..xn : Double,  y1..yn : Double| 頂点 |
| isClosed(flag)<br>[ ic ] | flag : Int | 0:Open　1:Close 省略時0 |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 塗りスタイル。省略時塗りなし |
| startArrow(...)<br>[ sa ] | [矢印スタイル](#arrowStyle)参照 | 始点矢印。省略時矢印なし |
| endArrow(...)<br>[ ea ] | [矢印スタイル](#arrowStyle)参照 | 終点矢印。省略時矢印なし |
- カーディナルスプラインでテンションは0.5です。
- isCloseが1の時は矢印スタイルは使われません。

##### Bezier（ベジェ曲線）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| vertices(x1 y1 x2 y2 x3 y3 ... xn yn)<br>[ vs ] | x1..xn : Double,  y1..yn : Double| 頂点と制御点 |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 塗りスタイル。省略時塗りなし |
| startArrow(...)<br>[ sa ] | [矢印スタイル](#arrowStyle)参照 | 始点矢印。省略時矢印なし |
| endArrow(...)<br>[ ea ] | [矢印スタイル](#arrowStyle)参照 | 終点矢印。省略時矢印なし |
- 3次ベジェ曲線です。頂点、制御点１、制御点2，頂点の順に並べてあります。頂点数をmとした場合、制御点と頂点の合計nはn=3*m+1になります。
- isCloseが1の時は始点と終点が直線で繋がれ矢印スタイルは使われません。

##### Circle（円）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| 中心点 |
| radius(r)<br>[ r ] | r : Double| 半径 |
| flatness(f)<br>[ f ] | f : Double| 扁平率。省略時1 |
| angle(a)<br>[ a ] | a : Double| 角度（度）。省略時0 |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 塗りスタイル。省略時塗りなし |

##### Arc（円弧）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| 中心点 |
| radius(r)<br>[ r ] | r : Double| 半径 |
| flatness(f)<br>[ f ] | f : Double| 扁平率。省略時1 |
| angle(a)<br>[ a ] | a : Double| 角度（度）。省略時0 |
| startAngle(a)<br>[ st ] | a : Double| 開始角（度）。省略時0|
| sweepAngle(a)<br>[ sw ] | a : Double| 角幅（度）。省略時90|
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 塗りスタイル。省略時塗りなし |
| startArrow(...)<br>[ sa ] | [矢印スタイル](#arrowStyle)参照 | 始点矢印。省略時矢印なし |
| endArrow(...)<br>[ ea ] | [矢印スタイル](#arrowStyle)参照 | 終点矢印。省略時矢印なし |
- 開始角及び角幅は省略可能ですが省略値は暫定のため省略を推奨しません。
- 角幅は左回りが正、右回りは負です。

##### Marker（点）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| 中心点 |
| angle(a)<br>[ a ] | a : Double| 角度（度）。省略時0 |
| markerStyle(...)<br>[ ms ] | [点スタイル](#markerStyle)参照 | 点スタイル |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |

- 線スタイルの線種は無効で常に実線になります。
- フラグで線種がレイヤ線種になっていても実線で表示される。
- フラグが仮線の場合は仮線で表示される（印刷不可の仮点となる）。

##### Text（文字）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| 基準点 |
| width(w)<br>[ w ] | w : Double| 文字枠幅。省略時0。 |
| height(h)<br>[ h ] | h : Double| 文字枠高さ。省略時0。 |
| text(t)<br>[ t ] | t : String| 文字列|
| angle(a)<br>[ a ] | a : Double| 角度（度）。省略時0 |
| basis(b)<br>[ b ] | b : Int| 配置基準。省略時0（左下）|
| fm(m) | m : Int| 文字枠モード。省略時0（自動）|
| textStyle(...)<br>[ ts ] | [文字スタイル](#textStyle)参照 | 文字スタイル。|
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 文字背景塗りスタイル。省略時塗りなし |

- 配置基準　0:左下, 1:中下, 2:右下, 3:左中, 4:中央, 5:右中, 6:左上, 7:中上, 8:右上
- 文字枠内は背景色で塗りつぶしができます。また、文字枠の幅で文字列は折り返しされます。文字枠の大きさは、文字枠幅と文字枠高さと文字枠モードの組み合わせで決まります。
- 文字枠モード
    - 0：自動。文字枠の幅と高さは文字列を囲む範囲（折り返しなし）。width（文字枠幅）とheight（文字枠高さ）は省略できる（存在しても使われない）。
    - 1：幅可変。width（文字枠幅）が有効で、文字枠高さは文字列を囲む範囲。height（文字枠高さ）は省略できる（存在しても使われない）。
    - 2：幅と高さ可変。文字枠は、width（文字枠幅）とheight（文字枠高さ）で決まる。
- 必要な文字枠幅・高さが0の場合、文字列を囲む範囲を初期値としてとる。

##### Dimension（直線寸法）
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| 寸法線始点 |
| p1(x y) | x : Double,  y : Double| 寸法線終点 |
| direction(dx dy)<br>[ d ] | dx : Double,  dy : Double| 寸法線から引出位置への方向単位ベクトル |
| extensionLine0(d)<br>[ e0 ] | d : Double| 始点側引き出し線の長さ |
| extensionLine1(d)<br>[ e1 ] | d : Double| 終点側引き出し線の長さ |
| text(t)<br>[ t ] | t : String| 文字列|
| tp(d) | d : Double| 文字配置位置 0.0が始点、1.0が終点、0.5が寸法線の中央。省略時0.5|
| enableAutoDimension(f)<br>[ ed ]| f : Int | 1で寸法値自動。省略時1 |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 文字背景塗りスタイル。省略時塗りなし |
| dimensionStyle(...)<br>[ ds ] | [直線寸法スタイル](#dimensionStyle)参照 | 直線寸法スタイル |
| tolerance(...)<br>[ to ] | [許容差](#tolerance)参照 | 許容差。省略時、許容差なし |

- 引き出し線の長さがマイナスの場合、directionの逆向きに引き出し線を伸ばす。

##### Radius（半径寸法）
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| 寸法線始点 |
| p1(x y) | x : Double,  y : Double| 寸法線終点 |
| text(t)<br>[ t ] | t : String| 文字列|
| tp(d) | d : Double| 文字配置位置 0.0が中心、1.0が終点、0.5が寸法線の中央。省略時0.5|
| enableAutoDimension(f)<br>[ ed ]| f : Int | 1で寸法値自動。省略時1 |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 文字背景塗りスタイル。省略時塗りなし |
| dimensionStyle(...)<br>[ ds ] | [半径寸法スタイル](#radiusStyle)参照 | 半径寸法スタイル |
| tolerance(...)<br>[ to ] | [許容差](#tolerance)参照 | 許容差。省略時、許容差なし |
- 始点は円の中心。

##### Diameter（直径寸法）
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| 寸法線始点 |
| p1(x y) | x : Double,  y : Double| 寸法線終点 |
| text(t)<br>[ t ] | t : String| 文字列|
| tp(d) | d : Double| 文字配置位置 0.0が始点、1.0が終点、0.5が寸法線の中央。省略時0.5|
| enableAutoDimension(f)<br>[ ed ]| f : Int | 1で寸法値自動。省略時1 |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 文字背景塗りスタイル。省略時塗りなし |
| dimensionStyle(...)<br>[ ds ] | [直径寸法スタイル](#diameterStyle)参照 | 直径寸法スタイル |
| tolerance(...)<br>[ to ] | [許容差](#tolerance)参照 | 許容差。省略時、許容差なし |


##### Angle（角度寸法）
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| 中心 |
| radius(r)<br>[ r ] | r : Double| 半径|
| startAngle(a)<br>[ st ] | a : Double| 開始角（度）。省略時0|
| sweepAngle(a)<br>[ sw ] | a : Double| 角幅（度）。省略時90|
| extensionLine0(d)<br>[ e0 ] | d : Double| 始点側引き出し線の長さ |
| extensionLine1(d)<br>[ e1 ] | d : Double| 終点側引き出し線の長さ |
| text(t)<br>[ t ] | t : String| 文字列|
| tp(d) | d : Double| 文字配置位置 0.0が始点、1.0が終点、0.5が寸法線の中央。省略時0.5|
| enableAutoDimension(f)<br>[ ed ]| f : Int | 1で寸法値自動。省略時1 |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 文字背景塗りスタイル。省略時塗りなし |
| dimensionStyle(...)<br>[ ds ] | [直線寸法スタイル](#dimensionStyle)参照 | 寸法スタイル。直線寸法スタイルを使用 |
| tolerance(...)<br>[ to ] | [許容差](#tolerance)参照 | 許容差。省略時、許容差なし |

- 引き出し線の長さがマイナスの場合、中心と反対側に引き出し線を伸ばす。

##### ArcDimension（弧長寸法）
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| 中心 |
| radius(r)<br>[ r ] | r : Double| 寸法線の半径|
| startAngle(a)<br>[ st ] | a : Double| 開始角（度）。省略時0|
| sweepAngle(a)<br>[ sw ] | a : Double| 角幅（度）。省略時90|
| ar(r)<br> | r : Double| 弧長の半径|
| text(t)<br>[ t ] | t : String| 文字列|
| tp(d) | d : Double| 文字配置位置 0.0が始点、1.0が終点、0.5が寸法線の中央。省略時0.5|
| enableAutoDimension(f)<br>[ ed ]| f : Int | 1で寸法値自動。省略時1 |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 文字背景塗りスタイル。省略時塗りなし |
| dimensionStyle(...)<br>[ ds ] | [弧長寸法スタイル](#arcdimensionStyle)参照 | 弧長寸法スタイル |
| tolerance(...)<br>[ to ] | [許容差](#tolerance)参照 | 許容差。省略時、許容差なし |

- 寸法線（寸法値が表示される）の半径と、弧長を測る半径があることに注意。
- 延長線が平行（延長線モード自動で弧幅が90度以内の場合を含む）で寸法線の半径が弧長の半径より小さい時、寸法線が寸法線の半径で描画できないならば、寸法線の半径を無視し、寸法線を描画できる最小の半径を使い描画する。


<a id="Leader"></a>
##### Leader（引出線）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| vertices(x1 y1 x2 y2 x3 y3 ... xn yn)<br>[ vs ] | x1..xn : Double,  y1..yn : Double| 頂点 |
| text(t)<br>[ t ] | t : String| 文字列|
leaderStyle.leaderBasisが3の時のみ有効。|
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 文字背景塗りスタイル。省略時塗りなし |
| leaderStyle(...)<br>[ lt ] | [引出線スタイル](#leaderStyle)参照 | 引出線スタイル |
- leaderStyle.leaderBasisが3（Free）の場合、文字列の配置点は最後の頂点にleaderStyle.textOffsetをX、leaderStyle.leaderOffsetをYとしてオフセットする（文字の基点は中心）。
- leaderStyle.leaderBasisが3（Free）の場合、leaderStyle.extendLineとleaderStyle.leaderOrientationは無視され文字列の傾きはleaderStyle.textAngleが使われる。


##### Balloon（バルーン）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| vertices(x1 y1 x2 y2 x3 y3 ... xn yn)<br>[ vs ] | x1..xn : Double,  y1..yn : Double| 頂点 |
| text(t)<br>[ t ] | t : String| 文字列|
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 文字背景塗りスタイル。省略時塗りなし |
| balloonStyle(...)<br>[ bs ] | [バルーンスタイル](#balloonStyle)参照 | バルーンスタイル |

##### Group（グループ図形）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| shapes(S1()S2()...Sn())<br>[ ss ] |S1..Sn:図形 | 図形のリスト |

##### Path（パス図形）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p(...)<br>| | パスリスト |
| lineStyle(...)<br>[ ls ] | [線スタイル](#lineStyle)参照 | 線スタイル。省略時、黒実線、幅0 |
| fillStyle(...)<br>[ fs ] | [塗りスタイル](#fillStyle)参照 | 塗りスタイル。省略時塗りなし |

パス要素
| 要素 | パラメータ | 説明 |
|-----|------|-----|
| s(x,y)<br>| x:Double, y:Double| 始点 |
| e(flag)<br>| flag:Int| 0：閉じない, 1:閉じる |
| l(x1 y1 x2 y2 ... xn yn)<br>| x1..xn : Double,  y1..yn : Double| 直線 |
| b(x1 y1 x2 y2 ... xn yn)<br>| x1..xn : Double,  y1..yn : Double| 3次ベジェ曲線。2つの制御点と１つの頂点の組 |
- パスはs()から始まること。e()のフラグが1の時は最後の点からまで始点まで直線を引く。


##### Image（画像図形）

| 要素 | パラメータ | 説明 |
|-----|------|-----|
| p0(x y) | x : Double,  y : Double| 中心 |
| width(w)<br>[ w ] | w : Double| 幅 |
| height(h)<br>[ h ] | h : Double| 高さ |
| angle(a)<br>[ a ] | a : Double| 角度（度）。省略時0 |
| image(bytes)<br>[ im ] | bytes : Bytes| 画像データ |
| src(file)<br>| file : String| 画像データファイルへのパス（フォルダ名含む）。例：src("media\\\\e1ed77be-822f-4743-a295-6d4c025ba6b0.png") フォルダの区切りの'\\'は文字列では２つ必要なことに注意。ファイルに拡張子は無くてもよいが、あったほうがデバッグが楽になると思います。|
| type(name)<br>[ t ] | name : String| 画像の種類（jpg, png, bmp）<br>参考値。省略可。 |

- 画像の種類はバイナリから判断できるためtypeタグは無くてもよい。今のところtypeタグはデバッグで使うことを想定する。
- imageタグとsrcタグは片方のみ有効。両方あった場合の動作は未定義。
- imageタグを使うとファイルサイズが大きくなりますが画像を一つのファイルにまとめることができるのでアプリケーションによっては実装が容易になります。
- 既存の図面に別の図面をインポートで追加する可能性を考えてsrcに使うファイル名の衝突を避けるためuuidを使うことを推奨します。

### settingsセクション
設定を記述します。
```
settings(
 currentLayer("Lyer1")
 currentSheet("Sheet2")
)
```

#### currentLayer
選択中のレイヤ名
#### currentSheet
選択中のシート名

## 補足
### ファイルバージョン
- インデックスファイルと図面ファイルのバージョンはそれぞれ違う値にすることもできますが、インデクスファイルのメジャーバージョン2以降はインデックスファイルと図面ファイルは同じものにしようと思います。

### バージョンによる違い
- ファイルバージョンは文字列でversionタグを使いますが、旧バージョンでは```fileversion(versionNumber)```を使いメジャーバージョン（整数値）のみでした。
- メジャーバージョン1はページが１つしかなく、pagesタグがない代わりにdrawingタグがあります。また、settingsタグはありません（設定はdrawingファイルにあります）。
以下はインデックスファイルのメジャーバージョン1の例です。メジャーバージョン１では図面ファイル名は`drawing`でした。
```
filetype("precad_archive")
fileinfo(
 fileversion(1)appinfo("precad for windows version 1.0.0.0")
)
contents(
 drawing("drawing")
)
```

- 線図形（Line）の始点と終点はppタグでまとめて書き出しますが、バージョン2.1.0までは始点と終点を別々に以下の書式で記述していました。バージョン2.2.0以降、分けて記述するのは冗長なのでppの書式に変更しました。互換性のため読み込みのみ対応しています。
```
p0(x0,y0)p1(x1,y1)
```

- 頂点リスト（vertices()）はファイルバージョン2.0.0以下では次の書式でした。互換性のため読み込みのみ対応しています。
```
points(P(x0,y0)P(x1,y1)...)　　//Pは大文字
```
- ベジェ曲線の頂点リストは以下の旧型式(ファイルバージョン2.0.0以下)があります（非推奨）。各頂点とその制御点を分けて記述します。制御点は各頂点の始点側（s()）と終点側（e()）の制御点を記述します。開いたベジェ曲線の場合は始点の終点側の制御点、終点の始点側の制御点は無視されます。
記述が冗長なのでこの形式は互換性のために読み込みのみ対応しています。
```
points(P(x0 y0)P(x1 y1)...)
controlPoints(cp(s(sx0 sy0)e(ex0 ey0)cp(s(sx1 sy1)e(ex1 ey1))...))
```

- バージョン2.1.0以前の直径寸法スタイルと直線寸法スタイルの矢印は始点終点同じものでした。そのため矢印スタイルのタグは`arrowStyle`でした。

- バージョン2.3.0からImageのsrcタグにファイル名を追加、圧縮ファイル内のmediaフォルダ内に画像を保存します。それ以前はimageタグを使用し文字列として同梱していました（この方式はクリップボード経由のコピーのために現在も使われています）。

### 短縮形について
もともとタグ名は内部で使っている変数名を元に決めました（kotlinで作っていたため最初が小文字から始まります）。そのため比較的文字数が多くなってしまいました。
タグ名が多少長くてもCPUは十分速くファイルは圧縮するため、それほど問題にならないと思っていました。実際、ファイルサイズの増加はそれほどでもなく速度も（普通のファイルなら）問題になりませんでした。
しかし、Androidでサイズの大きなファイルを読み込むと速度は大きく落ちました。Androidのディスクアクセスは遅かったのです。
そのためバージョン2.2.0で短縮形を設けました。

## 履歴
2025/1/14 2.7.0 Rev.0
- textStyleのtextAlignに両端揃えと均等揃え追加。
- Text（文字）にfm（文字枠モード）追加。
- 文字スタイルの縦書きは未実装のため、フラグを予約に変更。
- 文字スタイルに枠線フラグ追加。

2024/10/20 2.6.0 Rev.0
- バージョン変更　2.5.1->2.6.0（線種追加したので）。
- 履歴の日付修正。

2024/10/20 2.5.1 Rev.0
- 線種追加。
- 線種名誤記修正。

2024/08/28 2.5.0 Rev.1
- formatStyleのprefix,suffix省略値修正。
- textStyleのfontName省略値追加。

2024/08/25 2.5.0 Rev.0
- ArcDimension（弧長寸法）、arcDimensionStyle（弧長寸法スタイル）追加
- 誤記修正

2024/02/08 2.4.1 Rev.1
- 点（dot）のサイズについて修正

2024/02/08 2.4.1 Rev.0
- textStyleのflagの値の誤記を修正。
- textStyleのflagにTEXT_SLANT_ONLY_CHARACTERを追加。

2023/04/28 2.4.0 Rev.2
- 用紙名を保存するように変更。用紙の回転フラグ追加。

2023/04/14 2.4.0 rev1
- Leaderの修正
- 寸法値の変更
- このファイルのバージョン名の命名規則変更。

2023/04/12 2.4 rev0
- 引出線の仕様変更。
- 半径寸法のdimensionLineExtension説明追加、flag追加。
- 寸法線関係の説明追加と修正。

2023/04/10 rev5
- 直径寸法のdimensionLineExtensionが0の場合の処理を追加。
- leaderStyleにパラメータ追加。

2023/04/9 rev4
- 寸法線と角度寸法のdimensionLineExtensionが0の場合の処理を追加。

2023/03/23 rev3
- 線種追加

2023/03/23 rev2
- マクロ文字列追加

2023/03/09 
- 初版
