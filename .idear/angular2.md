# 首先祝大家新年快乐

哦哈呦，我又来坑大家了，那么首先，**Happy 2016**:raising_hand:。

不知道大家在2015年收获怎样呢，**react**是不是已经6到爆炸。仔细回想一下，确实变化也是翻天覆地，react，webpack，ember2，redux……

2016，不如来看下**ng2**吧。
	
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
* 模板与绑定
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

恩，直接复制就好了。接下来开启服务：

```sh
npm start
```

浏览器会自动打开`localhost:3000`，然后会显示`Loading...`。

下面开始我们的第一个组件，就是`index.html`里面那个奇怪的`<my-app>Loading...</my-app>`

# 他们都一样，没什么区别

`<my-app>`是做什么的？我想你应该已经知道了，这是程序的根节点，我们写的全部东东都在这个标签下面。其他框架不也是这么做的么？想想

```js
ReactDOM.render(<app />, document.getElementById('my-app'))
```

和

```js
Ember.Application.create();
```

接下来就来实现我们的`Hello World`。

先来创建我们的第一个组件`AppComponent`。首先创建一个`app`文件夹，然后在里面新建文件`app/app.component.ts`。注意后缀名，我们要用的**TypeScript**。

```typescript
/* @file app/app.component.ts */
import { Component } from 'angular2/core'

const component = {
  selector: 'my-app',
  template: '<h1>Hello World</h1>'
}

@Component(component)
export class AppComponent { }
```

好多新东西。上面一行是模块导入，我们需要`angular2/core`的`Component`来构建我们的组件；接下来定义了一个对象，`selector`就是之前看到的标签名字`my-app`，`templete`是要显示的内容；最下面导出了AppComponent组件，然后再上面一行`@Component`是一个注解，表示这是一个ng2的组件。当然啦，这只是一个语法糖，其实就是`Component(component)(AppComponent)`，那么写可以增加颜值，也更清楚的看到这个组件的特性。后面还会遇到一些注解。

有了AppComponent组件还不能看到效果，因为还木有启动（安装）。

新建一个`app/boot.ts`：

```typescript
/* @file app/boot.ts */
import { bootstrap } from 'angular2/platform/browser'
import { AppComponent } from './app.component'

bootstrap(AppComponent)
```

这就是启动方式，不用说可以明白。保存片刻之后浏览器会自动刷新。Hello World完成:joy:。

接下来看下强大的模板功能。

# 没错，模板就是最强大的

展示模板的最好方法就是弄一个列表出来，然后再花样显示上去。

Hello World就留着好了。再来新建一个组件`UserListComponent`，新建文件`app/user-list.component.ts`

```typescript
/* @file app/user-list.component.ts */
import { Component, OnInit } from 'angular2/core'

interface User {
  id: number
  name: string
}

const component = {
  selector: 'user-list',
  template: `
    <ul>
      <li *ngFor="#user of users">
      {{user.name}}
      </li>
    </ul>
  `
}

@Component(component)
export class UserListComponent implements OnInit {
  users: User[]
  
  ngOnInit() {
    this.users = users || []
  }
}

const users: User[] = [
  { id: 1, name: 'aaa' },
  { id: 2, name: 'bbb' },
  { id: 3, name: 'ccc' }
]
```

额，这次有点多。总之还是从上之下来看吧。首先除了`Component`还引入了`OnInit`这是个接口。什么？JS也有接口？是的，TS有，这个接口表示要实现我们自定义的初始化方法，稍后会看到。

然后我们自己定义了一个接口……好吧，我感觉你已经晕了。那这个是用来做什么的呢？我们知道JS是没有类型一说，而TS就是要解决这个问题，而这里的`interface User`就是我们自定义的类型，他的类型为`User`。这里简单定义了两个属性，`id`和`name`。

接下来要轻松一些，是之前见到过的东西`component`。`template`有些特别，这里不再是字符串，而是用了es6中模板字符串。模板字符串用```表示，他除了可以多行显示外，还可以将变量插入到字符串中，来代替之前的用`+`拼接字符串：

```js
var test = 'test'
var oldConcatStr = 'this is ' + test + 'template string'
var tempStr = `this is ${test} template string`
```

当然，还有重要的`*ngFor`，名字可以看出来，他用于循环列表。`#user of users`表示我们要循环`users`，每一项用`user`来表示。然后`{{user.name}}`就是说要区`user`的`name`属性。`user`就是`#user of users`中的`user`。

接下来是导出组件，`UserListComponent`组件实现了`OnInit`，就像之前所说的那样。然后在里面定义一些属性。`users`你肯定已经知道了，但是要注意一下写法`users: User[]`，其中`: User[]`表示`user`的类型为`User[]`。`User`前面已经定义好了，带一个`[]`表示他是一个数组，数组里面的每一项都是`User`类型。这里并没有给他赋值，因为我想在组件初始化的时候给他赋值。那么接下来的这个方法就用来做这件事情。`ngOnInit`是一个钩子方法，目的就是刚才说的，要自定义初始化方法，`implements OnInit`也是这个意思。

最下面就是一些静态数据，他的类型签名是`User[]`。

然后要做的工作就是把这个组件塞到之前的`AppComponent`的组件里面：

```typescript
import { UserListComponent } from './user-list.component'

const component = {
  selector: 'my-app',
  directives: [UserListComponent],
  template: `
    <h1>Hello World</h1>
    <user-list></user-list>
  `
}
```

要想使用`<user-list>`，必须先用import将他导进来，然后声明`directives: [UserListComponent]`。之后也是这样，要想使用我们自定义的组件，这两步是必须的。

来看下效果吧，页面应该刷新好了。

接下来再来看一些模板。

# 太简单了，老板再来一些模板

我要实现一个功能，在空列表时显示一句话告诉别人没有用户，而在不为空时显示用户列表。要实现这个，需要用到`*ngIf`:

```typescript
template: `
  <div *ngIf="getUserCount()">
    <ul>
      <li *ngFor="#user of users">
        {{user.name}}
      </li>
    </ul>
    <p>用户的数量是：{{getUserCount()}}</p>
  </div>
  <div *ngIf="!getUserCount()">
    <p>木有用户(°Д°)</p>
  </div>
`
```

在组件`UserListComponent`里添加一个`getUserCount`方法：

```typescript
getUserCount(): number {
  return this.users.length
}
```

注意他的类型签名，这个方法返回一个数字，也就是`number`类型。

静态数据`users`已经没用了，可以把它删掉了。浏览器刷新后，会看到空列表模板。

显示列表已经完全没有问题，接下来让我们做一些更有意思的功能，比如增加和删除。

# 来点更有意思的吧

在这之前我想先声明一点，在组件里那样处理数据是不好的习惯。合理的做法是用一些方法来单独处理数据，在组件里只需要调用这些方法。在ng2里面，他叫做**service**。

试着把刚才的数据移到service里，新建一个文件`app/user.service.ts`:


