# 首先祝大家新年快乐

哦哈呦，我又来坑大家了，那么首先，**Happy 2016**:raising_hand:。

不知道大家在2015年收获怎样呢，**react**是不是已经6到爆炸。仔细回想一下，确实变化也是翻天覆地，react，webpack，ember2，redux……

2016，不如来看下*ng2*吧。

# 这是又一本带大家入坑的小书

ng的话大家已经都很熟悉了，即使没有真正玩过，也会每天听到这个词，烦到不行。这个mvvm框架是目前使用人数最多的mvc框架。恩，当然，这次我们的主角并不是ng，而是**ng2**。

这既不是一本比较不同的书，也不是一本很权威的文档，我呢，只是希望大家很简单的把ng2玩起来，真的很简单。

首先要有一些提前知道的东东，那就是**TypeScript**。说的简单一些，这就是一个带类型版本的JavaScript。除了提升逼格外，他还能帮助你检查类型问题，当然，也会约束你，写错类型的话会提示你。然后呢，他还支持一些es6新语法。ng2中用的比较多的是`import``export`，`class`，模板字符串和注解，我们会在之后看到这些。

Ts就像sass一样，只不过他把`.ts`文件编译为普通的`.js`文件。怎么用？之后就会看到。

然而知道ts之后我们还需要准备一些环境，没错，**nodejs**。如果你在抱怨为什么哪里都有他，那就out啦。

nodejs安装很简单，在官网上下载好一直下一步就可以装好。对了，建议装5.X版本。

有了node我们就可以愉快的开始了。接下来首先配置一个简单的环境，然后依次熟悉各部分，包括：

* 启动
* 组件
* 模板绑定
* 服务
* 路由

# 准备活动，先来index.html

前端嘛，肯定少不了这个文件：

```html
<!DOCTYPE html>
<html>
  <head>
    <base href="/">
    <title>Angular 2</title>

    <!-- 1. script libs -->
  </head>
  <body>
    <my-app>Loading...</my-app>
  </body>
</html>
```

什么都没有，注释的地方就是我们稍后要做的，在那里加一些依赖。

现在我们用npm先来生成一个配置文件：

```sh
npm init
```

喜欢添就添一些内容。完成之后修改一下生成的`package.json`，加入下面的依赖项和脚本：

```js
"scripts": {
  "tsc": "tsc",
  "tsc:w": "tsc -w",
  "lite": "lite-server",
  "start": "concurrent \"npm run tsc:w\" \"npm run lite\" "
},
"devDependencies": {
  "angular2": "^2.0.0-beta.1",
  "concurrently": "^1.0.0",
  "es6-promise": "^3.0.2",
  "es6-shim": "^0.33.3",
  "lite-server": "^1.3.2",
  "node-uuid": "^1.4.7",
  "reflect-metadata": "^0.1.2",
  "rxjs": "^5.0.0-beta.0",
  "systemjs": "^0.19.14",
  "typescript": "^1.7.5",
  "zone.js": "^0.5.10"
}
```

搞定后就可以安装依赖了：

```sh
npm init
```

注意那些版本号，如果版本号不对，npm会提示你，所以说如果出错了就好好看下日志。

还有一个配置文件，用来配置`typescript`，给他取名为`tsconfig.json`就好：

```js
{
  "compilerOptions": {
    "target": "ES5",
    "module": "system",
    "moduleResolution": "node",
    "sourceMap": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "removeComments": false,
    "noImplicitAny": false
  },
  "exclude": [
    "node_modules"
  ]
}
```

然后在我们的`index.html`里面把ng2的依赖加好。

```html
<!DOCTYPE html>
<html>
  <head>
    <base href="/">
    <title>Angular 2</title>

    <!-- 1. Load libraries -->
    <script src="node_modules/angular2/bundles/angular2-polyfills.js"></script>
    <script src="node_modules/systemjs/dist/system.src.js"></script>
    <script src="node_modules/rxjs/bundles/Rx.js"></script>
    <script src="node_modules/angular2/bundles/angular2.dev.js"></script>
    <script src="node_modules/angular2/bundles/router.dev.js"></script>
		
    <!-- 2. Configure SystemJS -->		
    <script>
    System.config({
      packages: {
        app: {
          format: 'register',
          defaultExtension: 'js'
        }
      }
    });
    System.import('app/boot')
      .then(null, console.error.bind(console));
    </script>
  </head>
  <body>
    <my-app>Loading...</my-app>
  </body>
</html>
```

恩，直接复制就好了。开启服务：

```sh
npm start
```

下面开始我们的第一个组件，就是`index.html`里面那个奇怪的`<my-app>Loading...</my-app>`

