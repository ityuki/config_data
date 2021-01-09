@yaml_data =<<EOF

lang:
  error: エラーが発生しました
  warning: 警告です
  module1:
    error: 致命傷
    warning: 首の皮一枚

value:
  array:
    - 1  
    - 2  
    - 3  

EOF

@json_data =<<EOF
{
  "lang":{
    "error": "エラーが発生しました",
    "warning": "警告です",
    "module1":{
      "error": "致命傷",
      "warning": "首の皮一枚"
    }
  },
  "value":{
    "array":[
      1,
      2,
      3
    ]
  }
}

EOF
