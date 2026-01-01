# <div style="text-align: center;">SakraCad</div>
## <P style="BACKGROUND-COLOR: gainsboro">SakraCad</P>
SakraCadはWindows用の2DCADです。特徴は、
- 複数ページを持つことのできます。
- 各ページにはレイヤーとは別にシートを作ることができ、各シートには個別に縮尺を持たせることができます。
- DXF, JWW, JWC, LCD, SFCのファイルの読み込みと保存ができます（一部制約あり）。
- 多くの機能はプラグインとして実装されています。
## <P style="BACKGROUND-COLOR: gainsboro">動作環境</P>
- Windows8.1
- Windows10
## <P style="BACKGROUND-COLOR: gainsboro">Download</P>
### SakraCad

[skc095f.zip](download/skc095f.zip)(ver0.9.5f 3673KB) 2026/01/01
- OLE貼り付けしたアプリが存在しないと何も表示されなかったため、OLEオブジェクトの領域に四角形とそのオブジェクトのCLSIDを表示するようにした。
例えば、ペイントのOLEで画像を貼り付けてWindows11環境でペイントがインストールしてない場合に問題があった。
ペイントの場合は、Microsoft Storeからアプリをインストールすると画像が表示される。


[skc095e.zip](download/skc095e.zip)(ver0.9.5e 3564KB) 2024/06/28
- jwwファイルのバージョン2.23以降の読み込みに対応しました。

[skc095d.zip](download/skc095d.zip)(ver0.9.5d 3.39MB) 2023/03/13
- SFC読み込みで外部定義ハッチング(externally_defined_hatch_feature)があると読み込めなかったので修正しました（外部定義ハッチングのハッチ名の情報がないので無視します）。
- SFC読み込みで用紙(drawing_sheet_feature)内の図形が読み込めない時があったので修正しました。

[skc095c.zip](download/skc095c.zip)(ver0.9.5c 3.39MB) 2022/07/15
- 寸法線書式設定ダイアログで入力できない項目があったので修正しました。

[skc095b.zip](download/skc095b.zip)(ver0.9.5b 3.39MB) 2022/05/30
- スプライン描画で異常終了したので修正しました。

[skc095a.zip](download/skc095a.zip)(ver0.9.5a 3.39MB) 2022/02/24
- DXF保存で数値にコンマが入っていたので修正しました。

[skc095.zip](download/skc095.zip)(ver0.9.5 3.39MB) 2022/01/11
- コンパイラを変更しWindows10対応。コンパイラが変わった関係で不具合があるかもしれません。
- DXF保存でヘッダが無効だったので修正。
- DXF読み込みシステム変数の図面範囲を利用するようにした。
- DXF読み込みでDIMENSION,LWPOLYLINE,MTEXTなど対応。
- jww形式対応。


[skc094y.zip](download/skc094y.zip)(ver0.9.4y 1.61MB) 2014/02/15
- Windows7の64bit以降でカラーメニュー関係が正常に働かない問題の修正。  
  
### CNCHobby plugin
CNCフライスなどで板を切り出すためのG-CODE出力用プラグインなど。 zipファイルを解凍して「CNCHobby.dll」をSakraCadのpluginフォルダーの下にコピーすると使えます。詳細は、[CNCHobby.txt](download/CNCHobby.txt)を参照してください。 

[cnc051.zip](download/cnc051.zip)(CNCHobby.DLL Ver0.51) 2022/01/11
- コンパイラを変えてコンパイルしなおしました。 機能はVer0.50と変わりません。

[cnc050.zip](download/cnc050.zip)(CNCHobby.DLL Ver0.50) 2008/05/10
- 最後に原点へ移動するときの動作変更。 

## <P style="BACKGROUND-COLOR: gainsboro">インストール</P>
- インストーラはありません。zipファイルを解凍すると、SakraCadというフォルダが作成されます。その中にSakraCad.exeというファイルがあります。それを実行してください。
- アイコンなどを登録したい時は管理者権限でSakraCad.exeを実行すると登録されると思います。
- アンインストールはSakraCad.exeがあるフォルダを削除するだけです。しかし、レジストリにいくつかの情報が残っているかもしれませんので削除前にSakraCad.exeと同じフォルダにあるUnregist.batを実行してください。

## <P style="BACKGROUND-COLOR: gainsboro">SXFについて</P>
SXFについて、私自身まだよく理解していないところがあるので勘違い等あると思います。そのことをご理解のうえ以下の文章をお読みください。
- SFCの変換には「CAD データ交換標準ソフトウェア」を使用しています。
- SakraCadに無い寸法線の矢印が以下のように変換されます。
  
    |変換前|変換後|
    |---|---|
    |blanked arrow|unfilled arrow|
    |blanked box|四角の中心まで線が伸びます|
    |blanked dot|dimension origin|
    |integral symbol|slash|

- 直線寸法の変換に問題があるかもしれません。寸法図形全てに言えますが、SakraCadで表現できない場合、適当に変換されます。
- ハッチング（塗り）は未対応です。また、グラデーションには非対応です。
- ハッチング（パターン）の45度重ねあじろは未対応です。
- ユーザー定義線種は非対応です。
- SakraCadで使用した色が256色以上の場合は適当な（ある程度近い）色に変換されます（はずです）。
- ハッチングは複合図形（作図グループ）に変換されます。
- 複合図形（作図部品）は作図グループに変換されます。その各図形にレイヤー情報がある場合は最初に現れたレイヤーに全て表示されます。
- 複合図形（作図グループ）で各図形にレイヤー情報がある場合は最初に現れたレイヤーに全て表示されます。
- 縦横異縮尺には非対応です。
- 文字の間隔は0になります。その代わり、各文字の幅が変わります。
- 図面表題欄、図面情報等は未対応です。
- p21ファイルは未対応です。
- その他いろいろあると思います。

## <P style="BACKGROUND-COLOR: gainsboro">使用上の注意</P>

以下の事項に留意の上、ご使用いただくようお願いします。
- SakraCadはフリーウェアです。使用制限等無く無料で使用できます。
- 本プログラムの著作権は、らん　ゆうじろう(M.Yamaguchi)にあります。本プログラムの改変等は堅く禁じます。
- 本プログラムの使用によって何らかの障害が発生した場合でも、作者は一切の責任を負わないものとします。
- 作者は本プログラムのバグ修正、バージョンアップ等の一切のサポートの責は負いません。
- ファイルフォーマット、ユーザーインターフェース等予告無く変更することがあります。

## <P style="BACKGROUND-COLOR: gainsboro">資料</P>

[SakraCadファイル仕様](./SakraCadFileFormat.html)

## <P style="BACKGROUND-COLOR: gainsboro">プライバシーポリシー</P>
- SakraCadは個人情報の収集を行いません。
- 不具合の連絡をいただいた場合、問題確認のため図面ファイルの提供をお願いすることがあります。提供していただいたファイルは問題解決のためにのみ利用します。
