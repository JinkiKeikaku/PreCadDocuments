---
title: PreCad for Windows
---

# PreCad for Windows

## PreCadについて
- PreCadは、マルチページ対応の2DCADです。
- dxf, jww, jwc, sfc, lcd, skc, pdf, svg, hpglなど多くのファイル形式に対応しています（一部は読み込みのみ）。
- Jw_cadの線記号変形が使えます。
- Jw_cadの図形ファイル(*.jws)をパーツとして使用できます。
- [Androidバージョン](https://play.google.com/store/apps/details?id=com.junkbulk.precad)もあります（ただし、ソースコードも開発言語も違うので別物です）
- カンパウェアです。[開発支援](https://www.junkbulk.com/windows/precad/donate_ja.html)をお願いします。

## 動作環境
- Windows10, Windows11

## インストール
1. zipファイルを解凍し、`PreCad_Setup.exe`を実行してください。
2. 実行時に「WindowsによってPCが保護されました」と言う画面が出ます。その画面の「詳細情報」をクリックすると「実行」ボタンがあらわれます。「実行」ボタンを押すとインストールプログラムが実行されます。
3. インストーラは、以下のファイルを自動的に取得してインストールします。インターネットに接続できない環境でインストールする場合、あらかじめこれらのファイルをダウンロードして実行してください。
- Microsoft Visual C++ 再頒布可能パッケージ(64bit)
https://aka.ms/vs/17/release/vc_redist.x64.exe

- .NET デスクトップ ランタイム 6.0.6(64bit)
https://download.visualstudio.microsoft.com/download/pr/9d6b6b34-44b5-4cf4-b924-79a00deb9795/2f17c30bdf42b6a8950a8552438cf8c1/windowsdesktop-runtime-6.0.6-win-x64.exe


## 使用法
- ヘルプのマニュアルを参照してください。最新のオンラインマニュアルは以下の場所にあります。
https://www.junkbulk.com/windows/precad/manual/ja/PreCAD_windows_manual.html

## 連絡先等
- Mail : <a href="mailto:ai@junkbulk.com?subject=PreCadについて">ai@junkbulk.com</a>
- Web : https://www.junkbulk.com/windows/precad/index.html
- 開発支援 : https://www.junkbulk.com/windows/precad/donate_ja.html
- Copyright(c) Junkbulk (Jinki-Keikaku) 2024


## 使用条件
- 当ソフトウェアはカンパウェアです。無料で使うことができますが、もしよろしければ開発支援をお願いします。
- 当ソフトウェアの使用によって何らかの障害が発生した場合でも、作者は一切の責任を負わないものとします。自己責任でご利用ください。
- 作者は当ソフトウェアのバグ修正、バージョンアップ等の一切のサポートの責は負いません。
- 当ソフトウェア及びその同梱物の改変を禁止します。

## その他

### Wine上での動作について
####　注意
- 以下に記す手順は、私が試行錯誤した記録であり、動作を保証するものではありません。
- gdiplus.dllをネイティブ版に変更するため、他のソフトに影響があると思われます。その時は、gdiplus.dllを内蔵版に戻してください。
- 描画に日本語を使わないのであれば、フォントについては何もしなくていいと思います。

#### 手順
Ubuntu 22.04とWine9.0で起動を確認しました。
- Winetricksでcjk fontsをインストール（インストーラの文字化け対策。英語環境なら必要ないかも）
- Winetricksでie8をインストール（一部機能が使えないため。必須では無い）
- 以下のコマンドでレジストリを変更
```wine reg.exe ADD "HKEY_CURRENT_USER\Software\Wine\X11 Driver" "/v" "UseXVidMode" "/t" "REG_SZ" "/d" "N"```

これでひとまずインストールできました。
ただし、PreCadを起動して、線を描いて画面を拡大すると、線幅がおかしいことに気付きます。
そこで、WinetricksでRun winconfigを選んでその中のライブラリからgdiplusを追加します。そうすると線幅が正常になります。
しかし、gdiplusのネイティブ版ではちゃんと日本語フォントを指定しないと日本語が文字化けします（このインストーラも日本語が文字化けします。Windowsでは代替フォントで表示されるので文字化けしません。gdiplusの内蔵版も文字化けしないようです。レジストリのFontLinkなどを編集する必要があると思いますが、それは大変そうです）。
日本語フォントが少なければ、`winetricks allfonts`を実行しインストールします（当然、全てではなく日本語フォントだけ選んでインストールしてもいいです）。
ところが、PreCadはファイルにフォントを埋め込まないので、開いた図面にインストールされていないフォントが使われていた場合、問題になります。Windowsでは代替フォントが設定されているので文字が読めますが、Wineでは文字化けします。その対策として、PreCadの設定で代替フォントを指定してください。これで読めるようになります。
## 履歴
- 2024/1/27 ver. 1.0.1.0
  - 公開開始