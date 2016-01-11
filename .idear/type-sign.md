# 类型签名

**::**这个符号他表示“xxx的类型为xxx类型”，其中类型的首字母是大写。

在Haskell中可以用`:set +t`来开启类型注释。

一些基础的类型很容易想到，比如`Boolean``Char``Int``Float`这些。

```shell
ghci>:set +t

ghci>'a'
it :: Char

ghci>True
it :: Bool

ghci>42
it :: Num a => a

ghci>1 / 0
it :: Fractional a => a
```

当然，数组也有类型，用`[]`表示，比如`[True, Flase]`，这是个boolean值得列表，他的类型为[Bool]。那来看一些类型：

```shell
ghci>[1, 2, 3]
it :: Num t => [t]

ghci>['a', 'b']
"ab"
it :: [Char]

ghci>"ab"
"ab"
it :: [Char]
```

看来，字符串只是个列表，就是字符的列表。

11


