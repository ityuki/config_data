 ## config_data

* YAML/JSONの読み書きをするプログラム
* javascriptっぽくアクセス出来ます

## 使い方

```ruby
require 'config_data.rb' # 本体ロード

load 'test_loaddata.rb' # テストデータが入ってます

a = ConfigData.new # オブジェクト作成

a.loadYAML(@yaml_data) # テスト用のYAMLデータを読み込みます

puts a.lang.error          # それっぽいメッセージが出ます
puts a.lang.module1.error  # それっぽいメッセージが出ます


puts a.error.code          # nilエラーメッセージが出ます
puts a.error.message       # nilエラーメッセージが出ます

a.error = {} # 新しくハッシュを追加します
a.error.code = 10 # エラーコードは10
a.error.message = "ヒャッハー" # どうしようこのメッセージ

puts a.error.code          # それっぽいメッセージが出ます
puts a.error.message       # それっぽいメッセージが出ます

puts a.dumpYAML() # YAMLで出力
puts a.dumpJson() # Jsonで出力

```

## その他

* 適当に作ったので動作は保証しません
* ライセンスはまだ考えていません。著作権は放棄してないよ！




