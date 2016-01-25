导航：

* [那么首先，祝大家新年快乐](#那么首先祝大家新年快乐)
* [写在之前，Coffee Or Tea？](#写在之前，Coffee Or Tea？)
* [准备活动是必不可少的](#准备活动是必不可少的)
* [他们都一样，没什么区别](#他们都一样，没什么区别)
* [没错，模板最大](#没错，模板最大)
* [就是这个感觉，来点有意思的](#就是这个感觉，来点有意思的)

# 那么首先，祝大家新年快乐

哦哈呦，那么首先，_Happy 2016 evenyone_:tada:。

我是来给大家拜年的:raising_hand:。

2015年大家玩的怎样？**react**是不是已经6到爆炸，**webpack**是不是已经轻松拿下。仔细回想一下，前端变化也算是翻天覆地的，[react](https://github.com/facebook/react)，[webpack](https://github.com/webpack/webpack)，[ember2](https://github.com/emberjs/ember.js)，[redux](https://github.com/rackt/redux)……真是超多东西需要学习。

之前的圣诞元旦腊八节也没有送大家礼物，在苦思冥想之后，我决定为大家送上这个。

没错，这次又来带大家踩坑了。

2016，不如来看下**ng2**吧。

[回到顶部](#)

# 写在之前，Coffee Or Tea？

[angular](https://github.com/angular/angular.js)我想大家已经都相当熟悉了，就算没有真正玩过，也会天天听到这个词，简直烦到不能。这个mvvm框架是目前使用人数最多的mv(x)框架。恩，当然，这次我们的主角并不是ng，而是[angular2](https://github.com/angular/angular)。

这既不是一本比较ng1与ng2区别的书，也不是一本很权威的文档，相反，是一个相当随意的文章。只是希望大家很简单的把ng2玩起来，试过之后你会发现，真的很简单。:joy:

在开始之前需要做一些准备活动。那么首先，有一个东西一定要提，那就是ng官方推荐的[TypeScript](https://github.com/Microsoft/TypeScript)。用一句话简单来说，TypeScript是一个带**类型**版本的JavaScript。当然，他的功能不至于次，除了提升逼格外，还能提高颜值。

TypeScript（以下简称**ts**）可以帮助你检查类型问题，告别**TypeError**；约束你写出正确的类型，否则编译器就会抱怨不止。而后，他还支持大部分es6（es2015）新语法。常用的包括模块，类，箭头函数，绑定，模板字符串等等都已支持。除了这些，ts还支持es7的注解功能，非常强大，不久之后就会看到。

如果你玩过sass，就应该知道sass是把`.sass`文件编译为`.css`文件。在这一点上ts就像sass一样，他把后缀名为`.ts`的文件编译为普通的`.js`文件。

快速浏览ts的内容可以先跳到[附录1](#附录，TypeScript 101)。

说了半天为嘛要用ts而非js呢？首先一点，ng2就是用ts写的；其次，ts写起来感觉很好，比同等级别晦涩的js好太多。所以还是有必要入手的，当然，如果你是强迫症的话，ng2同样提供了es5，es3的写法，我相信你看过之后就会改变想法的。

ts之后就是我们的老朋友，没错，就是[nodejs](http://nodejs.org)。你一定在抱怨什么，为什么哪里都有他，没办法，这是必须的。

nodejs安装很简单，win用户在官网上下载好安装包后一路*next*下去就可以了。对了，建议装5.X版本。

nodejs准备好，就可以愉快的开始了。接下来的任务先要配置一个简单的ng环境，然后依次熟悉ng各部分，包括但不限于：

* 环境与启动文件
* 组件
* 模板与绑定
* 服务与依赖注入
* 路由模块

我将用一个简单明了的demo来刻画这些内容。:ghost:

[回到顶部](#)

# 准备活动是必不可少的

第一个文件，`index.html`，你应该最熟悉不过：

```html
<!-- @file index.html -->
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <title>Hello World, Angular 2</title>
  </head>
  <body>
    <!-- Application root container. -->
    <my-app>Loading...</my-app>
  </body>
</html>
```

除了那条注释外，不能再更简单了。

接下来用npm（nodejs的包管理器，会与nodejs一起捆绑安装）先来生成一个配置文件`package.json`，这个文件保存着项目里用到的依赖。执行：

```sh
npm init
```

nodejs问你一大堆问题，名称、版本号什么的，括号里面是默认值。这里不想麻烦就一路回车吧，喜欢就添一些内容。

需要的依赖包括这些东西：

| 依赖              | 说明                       |
| :-------------   | :------------------------  |
| typescript       | 不解释                      |
| angular2         | 同上                       |
| rxjs             | FPR库，ng2需要他            |
| es6-shim         | 一个es6的垫片，用来兼容不同环境 |
| es6-promise      | Promise，用来处理异步任务     |
| reflect-metadata | 提供es7注解语法支持           |
| zone.js          | 用来脏值检查                 |
| systemjs         | 脚本加载器                   |
| lite-server      | 一个静态文件服务器            |
| concurrently     | 可以一次执行多个脚本          |

不要被这么多东西吓到，因为现在并不需要去完全掌握他们，只要保证他们存在就没问题。接下来修改一下`package.json`，把上面提到的依赖添加进去：

```js
"devDependencies": {
  "angular2": "^2.0.0-beta.1",
  "concurrently": "^1.0.0",
  "es6-promise": "^3.0.2",
  "es6-shim": "^0.33.3",
  "lite-server": "^1.3.2",
  "reflect-metadata": "0.1.2",
  "rxjs": "5.0.0-beta.0",
  "systemjs": "^0.19.14",
  "typescript": "^1.7.5",
  "zone.js": "^0.5.10"
}
```

直接复制就好。然后还有一些启动脚本：

```js
"scripts": {
  "tsc": "tsc",
  "tsc:w": "tsc -w",
  "lite": "lite-server",
  "start": "concurrent \"npm run tsc:w\" \"npm run lite\" "
}
```

同样的，直接复制就可以了。目前为止我的`package.json`长这个样子：

```js
{
  "name": "angular2-start",
  "version": "1.0.0",
  "description": "Hello ng2.",
  "main": "index.js",
  "scripts": {
    "tsc": "tsc",
    "tsc:w": "tsc -w",
    "lite": "lite-server",
    "start": "concurrent \"npm run tsc:w\" \"npm run lite\" "
  },
  "license": "MIT",
  "devDependencies": {
    "angular2": "^2.0.0-beta.1",
    "concurrently": "^1.0.0",
    "es6-promise": "^3.0.2",
    "es6-shim": "^0.33.3",
    "lite-server": "^1.3.2",
    "node-uuid": "^1.4.7",
    "reflect-metadata": "0.1.2",
    "rxjs": "5.0.0-beta.0",
    "systemjs": "^0.19.14",
    "typescript": "^1.7.5",
    "zone.js": "^0.5.10"
  }
}
```

接下来通过下面的命令安装依赖：

```sh
npm install --verbose
```

命令行此刻会起飞。

要注意那些版本号，因为ng2需求一些依赖的版本号可能并不是最新，**所以说版本号不对，npm就会在命令行提醒你ng2需要的xxx的版本应该是xxx**。出错了就检查下日志，这里还是建议直接复制过去安装比较简单。

片刻之后npm就会把所需的依赖全部安装好。

对了，还有一个配置文件，是用来配置ts的，取名为`tsconfig.json`：

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

同样的，不需要了解到每一行的意思，不过依据命名应该能猜到一些端倪。

然后在`index.html`中把刚才安装的依赖添加上去。

```html
<!-- @file index.html -->
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <title>Hello World, Angular 2</title>

    <!-- 1. Load libraries -->
    <script src="node_modules/angular2/bundles/angular2-polyfills.js"></script>
    <script src="node_modules/systemjs/dist/system.src.js"></script>
    <script src="node_modules/rxjs/bundles/Rx.js"></script>
    <script src="node_modules/angular2/bundles/angular2.dev.js"></script>
		
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
    <!-- Application root container. -->
    <my-app>Loading...</my-app>
  </body>
</html>
```

直接复制就好。接下来启动服务：

```sh
npm run start
```

浏览器会自动打开`localhost:3000`的地址，会显示`Loading...`:rabbit:。

先喝杯java休息一下，别走开，紧接着开始我们的第一个组件，就是那个奇怪的`<my-app>Loading...</my-app>`。

[回到顶部](#)

# 他们都一样，没什么区别

`<my-app>`这个标签是做什么的，貌似重来没有见过？我不说，你也应该猜到一些，他是程序的根节点，我们写的全部内容都会塞在这个标签下。来回忆一下，其他框架的是怎么做的？

react:

```js
ReactDOM.render(<app />, document.getElementById('my-app'))
```

emberjs:

```js
Ember.Application.create({
  rootElement: '#my-app'
});
```

你懂的。

接下来就来实现`Hello World`。

创建第一个组件`AppComponent`。首先新建一个`app`文件夹，然后在里面新建文件`app/app.component.ts`，注意后缀名是`ts`。ng2文件的命名规范是`$name.component.ts`，之后会看到其他的文件也都是这样的命名范式。

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

好多新东西，并且完全没有js的样子。没关系，理解起来很简单。

`import`和`export`是es6模块的用法，表示导入和导出。最上面从`angular2/core`中导入了`Component`，最下面导出了一个类`AppComponent`，也就是组件。

`class`也是es6的新语法，用来表示一个类。如果你熟悉下面的写法：

```js
function Foo(bar) {
  this.bar = bar
}
var foo = new Foo()
```

`class`就是上面这段代码的语法糖。当然，这么说也不正确，因为class所做的事远远不止如此。

```js
class Foo {
  constructor(bar) { this.bar = bar }
}
var foo = new Foo()
```

`const`是绑定，和`var`类似，不过`const`定义的是常量，不能重复定义。否则下面的代码会报错：

```js
const PI = 3.1415
const PI = 0.618 //=> Error!
```

这里的`const`绑定了一个对象`component`：

```js
const component = {
  selector: 'my-app',
  template: '<h1>Hello World</h1>'
}
```

`selector`就是本节开始时看到的标签`my-app`，他用来定义标签的名字；`template`就是要显示的内容，称做模板。

我猜你会第一眼看到`@Component`，他太特别了。这是一个注解，如果熟悉java，一定不会陌生，然而这里的注解很简单，他也是一个语法糖。`@Component`可以简单理解为`Component(component)(AppComponent)`，一个函数的调用。当然，这里理解为**AppComponent是一个ng2组件显然更好**，除了增加颜值，还能直观的看到组件类的特性。之后也会遇到一些其他注解。

有了AppComponent组件还不能马上看到效果，因为还没有启动（安装）。

新建一个`app/boot.ts`：

```typescript
/* @file app/boot.ts */
import { bootstrap } from 'angular2/platform/browser'
import { AppComponent } from './app.component'

bootstrap(AppComponent)
```

这就是启动方式，现在可以不用理解`bootstrap`到底做了什么。保存片刻之后浏览器自动刷新，会看到大大的**Hello World**:joy:。

接下来摆弄一下强大的模板。

[回到顶部](#)

# 没错，模板最大

展示模板的最好方法就是做一个列表，然后再花样显示上去。

Hello World就让他留在那里吧。我们计划实现一个用来显示用户姓名的简单列表。

还是先来新建一个组件，给他取名`UserListComponent`我想就很合适。新建文件`app/user-list.component.ts`。之前在命名`app/app.component.ts`时说到了命名规范，这里再加一条，词组的话用`-`来连接每个单词，就像上面那样：

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
    if(!USERS) return
    this.users = USERS
  }
}

const USERS: User[] = [
  { id: 1, name: 'aaa' },
  { id: 2, name: 'bbb' },
  { id: 3, name: 'ccc' }
]
```

有新东西，`interface`。在解释之前还是先浏览一下代码内容。与`app/app.component.ts`不同的是，第一行除了导入`Component`外，还导入了`OnInit`，这是一个接口，也就是`interface`。

`interface`接口是ts中的扩展内容，如果你有其他oop编程经验那么肯定不会对接口感到陌生。接口可以表现为对行为的一种约束，就是说如果"xxx实现了某种接口，那么xxx必然具备这个接口的所有内容"。看一下这行代码：

```typescript
export class UserListComponent implements OnInit {
  //...
  ngOnInit() {
    //...
  }
}
```

这句话可以翻译为“实现了`OnInit`接口的`UserListComponent`类”。既然要实现这个接口，必然也要实现接口里面的内容，那就是`ngOnInit`方法，因为`ngOnInit`方法定义在`OnInit`接口中。这个方法会在初始化该类时调用，所以可以写一些自己的逻辑在里面，比如赋值操作：

```typescript
//...
ngOnInit() {
  if(!USERS) return
  this.users = USERS
}
//...
```

如果感觉很抽象，再看看这个会好一些：

```typescript
interface User {
  id: number
  name: string
}
```

这是我们自定义的接口，`OnInit`是ng2已经定义好的接口。这里定义了`User`接口，他包括了两个属性：`id`和`name`，并且在属性后面指明了他们的类型。那就是说，但凡实现`User`接口的东西必须要求包括这两个属性。再来看看最后几行代码：

```typescript
const USERS: User[] = [
  { id: 1, name: 'aaa' },
  { id: 2, name: 'bbb' },
  { id: 3, name: 'ccc' }
]
```

这里定义了一些静态测试数据，注意他的类型签名，是`User[]`，他表示`USERS`是一个`User`数组。显然他的数据格式已经包括了`id`和`name`，否则编译器会报错。

当然，除了显眼的`Interface`外，还有一样东西也格外引人入目，那就是`template`，也是本节的主角，模板。

```typescript
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
```

`*ngFor`，从名字上就可以揣测出他的用途。没错，他用来循环列表，而后面的`#user of users`则可译为："users中的每一项用user表示"。而`{{user.name}}`不必多说你也已经清楚了。这里取的是每个`user`的`name`属性。回忆一下其他框架中是怎么做的：

react:

```jsx
<ul>
  {
    this.props.users.map(user => {
		return <li>{user.name}</li>
	})
  }
</ul>
```

emberjs:

```hbs
<ul>
{{#each user as |users|}}
  <li>{{user.name}}</li>
{{/each}}
</ul>
```

`selector: user-list`之前已经解释过，稍后就会看到他的用处。

这里还有一个很有意思的es6特性，那就是模板字符串**Template String**。与普通字符串不同，他用 **`** 符号把内容括起来，当然还有一个更厉害的功能：

```js
var foo = 'bar'
var oldStr = 'this is ' + foo + 'template string'
var newStr = `this is ${foo} template string`
```

效果是一样的。没有模板字符串，就只能用老办法拼接字符串或是用replace替换，这样做使得代码颜值很低而且容易出错。模板字符串是一个优雅的做法，他可以将`${var}`中的内容替换成变量。更重要的一点是，他支持多行文本，这样就不需要在字符串末尾使用`+`号拼接了。ng2充分利用了这个特性，你都看到了。

还有重要的一点没有说，模板里的`users`是从哪来的？我想你应该已经找到了，他定义在组件类中，注意他的签名，是`User[]`。而后在`UserListComponent#ngOnInit`中给他赋了值。

接下来要做的工作就是把这个组件塞到之前的`app/app.component.ts`的`template`里：

```typescript
/* @file app/app.component.ts */
import { UserListComponent } from './user-list.component'

const component = {
  //...
  directives: [UserListComponent],
  template: '<h1>Hello World</h1><user-list></user-list>'
  //...
}
//...
```

首先在页面顶部先把组件用`import`导入。

有个问题，ng2并不认识`<user-list>`，要想使用他，必须声明`directives`。`directives`的值是一个数组，里面存放我们想要使用的组件。

这里要思考的一点是，想要使用我们自定义的组件，就必须明确告诉ng2，做法就是务必写在`directives`中。同时，组件就是一个`directive`。

来看下效果吧，页面应该早就刷新好了。

[回到顶部](#)

# 感觉简单，就再来一些模板

接下来想要实现一个功能，在没有用户即空列表时，显示一句话友好的告诉别人还没有用户；而在有用户时照常显示用户列表。要实现这个，需要if条件逻辑:

```typescript
/* @file app/user-list.component.ts */
const component = {
  //...
  template: `
    <div *ngIf="getUsersCount()">
      <ul>
        <li *ngFor="#user of users">
          {{user.name}}
        </li>
      </ul>
      <p>用户的数量是：{{getUsersCount()}}</p>
    </div>
    <div *ngIf="!getUsersCount()">
      <p>木有用户(°Д°)</p>
    </div>
  `
}
```

`*ngIf`就是我们需要的，而功能的话也无需过多解释。等号后面相当于条件语句，这里是一个表达式`getUsersCount()`，说明他是一个方法，而且这个方法应该返回一个或能转换成`true`或`false`的值。

在组件类`UserListComponent`里添加一个`getUsersCount`方法：

```typescript
/* @file app/user-list.component.ts */
export class UserListComponent implements OnInit {
  //...
  getUsersCount(): number {
    if(!this.users) return 0
    return this.users.length
  }
  //...
}
```

如果没有用户，就返回`0`，这样会被隐式转换成`false`；当然，有用户时就返回用户的数量。注意他的类型签名，这个方法返回了一个数字，也就是`number`类型。

为什么不直接返回一个布尔类型的值？因为我还想在之后统计一下用户的数量：

```typescript
/* @file app/user-list.component.ts */
const component = {
  //...
  template: `
    //...
    <p>用户的数量是：{{getUsersCount()}}</p>
	//...
  `
}
```

静态数据`USERS`已经没用了，把它删掉了。浏览器刷新后，会看到空列表模板。

if模板和for模板应该是模板当中使用最多的，但显示一个列表未免也太显无聊了点。接下来做一些有意思的功能，比如增删改。

[回到顶部](#)

# 就是这个感觉，来点有意思的

在开始之前先声明一点，静态数据`USERS`只是为了演示功能。在ng2里数据和组件应该隔离开，数据被放在叫做**service**的类里。

试着把刚才的静态数据移到service里，新建一个文件`app/user.service.ts`:

```typescript
/* @file app/user.service.ts */
import { Injectable } from 'angular2/core'

export interface User {
  id: number
  name: string
}

@Injectable()
export class UserService {
  constructor() { 
    this.users = [] 
  }
  
  users: User[]
  
  getUsers(): Promise<User[]> {
    return Promise.resolve(this.users)
  }
}
```

快来看，我们遇到了第二个注解，`@Injectable`。于`@Component`类似，这个注解表明该类是可注入的。注意后边有一对括号，丢了他们ng2可不干。

`User`接口也被移到了这里，并用`export`导出。

在`UserService`类的构造函数中赋给`users`属性初值，`[]`，一个空列表。

同时`UserService`类中申明了一个`getUsers`方法，该方法用来获取用户数据。注意类型签名，一个泛型`Promise<Users[]>`，使用Promise是为了模拟从服务器端异步请求，后边可以直接换成**AJAX**。

这样`app/user-list.component.ts`也要做一下小手术了：

```typescript
/* @file app/user-list.component.ts */
import { User, UserService } from './user.service'

@Component(component)
export class UserListComponent implements OnInit {
  constructor(private _service: UserService) {}
  //...
  ngOnInit() {
    this._service.getUsers().then(users => this.users = users)
  }
}
```

组件类中多了一个构造函数：

```typescript
export class UserListComponent implements OnInit {
  constructor(private _service: UserService) {}
  //...
}
```

有点不好理解。这是ts中的写法，可以转换成如下的代码：

```typescript
export class UserListComponent implements OnInit {

  private _service: UserService
  
  constructor(userService: UserService) {
    this._service = userService
  }
}
```

在构造函数中为属性赋值，这个模式太常见了，所以ts把他直接弄到构造函数中来简写了这个功能。

初始化方法也有点不同，用了`Promise`的写法：

```typescript
export class UserListComponent implements OnInit {
  //...
  ngOnInit() {
    this._service.getUsers().then(users => this.users = users)
  }
} 
```

调用的就是service中的`UserService#getUsers`方法。

`Promise`也是es6中的新特性，介绍他需要大量篇幅，这里就简单理解为带有一个上下文的容器。他的上下文就是不久之后的操作会成功或失败。Promise可以代替常见的回调写法，举个jQuery调用AJAX的栗子：

```js
$.ajax({
  url: '/api',
  success: function(data) {
  // 请求成功会执行这个方法
  },
  error: function(err) {
  // 失败时执行的方法
  }
})
```

上面的代码可以转为`Promise`的形式：

```js
$.ajax({ url: '/api' })
 .then(function() {
   // 请求成功会执行这个方法
 }, function() {
   // 失败时执行的方法
 })
```

如此所见，$.ajax返回了一个`Promise`，这个`Promise`可能成功或失败。`then`方法接受两个参数，分别代表了成功和失败时调用的函数。

`Promise`强大的一个体现是可以链式调用，比如说：

```js
function map(fn) {
	return function(a) {
		return a.map(fn)
	}
}
function add10(x) {
  return x + 10
}
function sayHello(x) {
  return 'Hello, ' + x
}
function toString(x) {
  return x.join(' and ')
}

Promise.resolve([1, 2, 3])
  .then(map(add10))
  .then(map(sayHello))
  .then(toString)
  .then(console.log)
  
//=> Hello, 11 and Hello, 12 and Hello, 13
```

Promise对处理异步流起到了非常重要的作用。

更有意思的是后面的`users => this.users = user`这是什么呢？

这个写法是es6中的箭头函数，他可以写为：

```typescript
var _this = this
this._service.getUsers().then(function(users) {
  _this.users = users
})
```

观察上面的代码，除了更优雅之外，还有一个更重要的功能，那就是可以绑定this。用箭头函数，就可以不用考虑this问题了。箭头函数也是es6中使用最多的特性之一。

悲剧的是，浏览器刷新后报错了，ng抱怨说没有提供`UserService`，为什么呢？

在构造函数里声明`UserService`，只说明了一个问题，那就是这个类需要`UserService`。所以必须在某个地方提供他。猜猜要怎么做？

如果猜到是在`AppComponent`类中，那么给你9.9分，剩下的0.1分不给你怕你膨胀。这里要修改一下`app/app.component.ts`：

```typescript
/* @file app/app.component.ts */
import { UserService } from './user.service'

const component = {
  //...
  providers: [UserService],
  //...
}
```

`providers`就用来提供`service`的。

这样就可以了。接下来还是考虑实现增删改吧。

[回到顶部](#)

# 揉揉眼睛，你不会走开的对不

添加功能，一定要有输入框，让我们有诚意的为其添加一个：

```typescript
/* @file app/user-list.component.ts */
//...
const component = {
  template: `
    <div>
      <label>
        添加新用户
        <input type="text" [(ngModel)]="username" placeholder="请输入用户名" />
      </label>
      <button type="button">确定</button>
      <p>要添加的用户为：{{username}}</p>
    </div>
  //...
  `
}
//...
```

当然，除了输入框，还需要一个添加按钮。为了展示绑定的威力还增加了一段用于显示将要添加的用户。

`[(ngModel)]`的作用是双向绑定，这也是ng2的一个核心功能，等号后边就是绑定的值。双向绑定意味着绑定是双向的（这不是废话么。。。），也就是说，输入框输入内容后，等号后边绑定的属性值也会更着改变。而将属性值手动更改后，输入框的值也会随之变化。由于绑定了`newUserName`，我们在组件中添加一个属性：

```typescript
/* @file app/user-list.component.ts */
export class UserListComponent implements OnInit {
  //...
  username: string = ''
  //...
}
```

注意他的类型签名，`string`，而且给他赋了初值。

现在就在里面输入一些字试试看吧。Amazing！绑定功能果然很强大。下面接着来实现添加用户，这需要给按钮绑定点击事件：

```typescript
/* @file app/user-list.component.ts */
const component = {
  template: `
    <button type="text" (click)="createUser()">确定</button>
  `
}
```

`createUser()`就是事件要调取的方法句柄，我们还是在组件中实现他：

```typescript
/* @file app/user-list.component.ts */
export class UserListComponent implements OnInit {
  //...
  createUser(): void {
    //...
  }
  //...
}
```

可是要怎么实现呢？还记得`service`么？

不如我们先来实现`service`中添加新用户的功能：

```typescript
/* @file app/user.service.ts */
export class UserService {
  //...
  createUser(username: string): Promise<boolean> {
    let user = { id: +new Date(), name: username }
    this.users.push(user)
    return Promise.resolve(true)
  }
  //...
}
```

`UserService#createUser`方法接受一个字符串，构造出一个新的`user`，然后返回`Promise`用于模拟从服务器端返回，返回`true`就表示服务器端添加成功了。

在构造`user`时，用当前时间截充当新的`id`，因为时间截是`number`类型，所以完全符合`User`接口的约束。

这样组件中的`UserListComponent#createUser`就很简单了：

```typescript
/* @file app/user-list.component.ts */
export class UserListComponent implements OnInit {
  //...
  createUser(): void {
    if(!this.username.trim()) return
    this._service.createUser(this.username)
  }
  //...
}
```

因为绑定的存在，不需要去管`UserListComponent#users`的值，他会自己更新。当然，`newUserName`为空时没什么暖用，要过滤掉。

来试试看吧，输入一些字，然后点击确定。HOHO～全部都在变，这就是绑定的威力。不过好像少写了一些东西，添加成功后，要把`newUserName`清空，这个简单：

```typescript
/* @file app/user-list.component.ts */
export class UserListComponent implements OnInit {
  //...
  createUser(): void {
    if(!this.username.trim()) return;
	let resetUserName = () => this.username = ''
    this._service.createUser(this.username).then(resetUserName)
  }
  //...
}
```

为了增加用户体验，我想在输入完成后直接按回车就可以添加，而不是去麻烦的点击按钮，这要怎么做呢？也很简单，只需做一些简单修改就好了：

```typescript
/* @file app/user-list.component.ts */
const component = {
  template: `
  //... <button> 现在可以删掉了
  <input type="text" [(ngModel)]="newUser" placeholder="请输入用户名" (keyup.enter)="createUser()" />
  //...
  `
}
```

看吧，简直魔法一般。

OK，接下来实现删除功能。同样的，先修改一下模板，要在每个`user`后面添加一个删除按钮：

```typescript
/* @file app/user-list.component.ts */
const component = {
  template: `
    //...
    <li *ngFor="#user of users">
      {{user.name}}
      <a (click)="deleteUser(user)">删除</a>
    </li>
    //...
  `
}
```

和之前的添加如出一辙，接下来实现`deleteUser`这个方法。注意这里给这个方法传入一个参数，就是对应的`user`。

还是先来实现`service`里面的`deleteUser`：

```typescript
/* @file app/user.service.ts */
export class UserService {
  //...
  deleteUser(deleteUser: User): Promise<boolean> {
    let idx = this.users.indexOf(user)
    this.users.splice(idx, 1)
    return Promise.resolve(true)
  }
  //...
}
```

仅仅返回了`true`，表示删除成功。然后添加组件的`deleteUser`：

```typescript
/* @file app/user-list.component.ts */
export class UserListComponent implements OnInit {
  //...
  deleteUser(user: User): void {
    this._service.deleteUser(user)
  }
  //...
}
```

试一下功能，OK，木有问题。

# 还不到休息的时候，还要再接再厉

很好，一鼓作气实现了增加和删除功能。也对`service`有了一个大概的了解。接下来就来继续实现修改功能。

大致模板应该是这样的：

```typescript
/* @file app/user-list.component.ts */
const component = {
  template: `
    <li *ngFor="#user of users">
      <span *ngIf="!isEdit">{{user.name}}</span>
      <input *ngIf="isEdit" />
      <a *ngIf="!isEdit" (click)="beginEdit()">修改</a>
      <a *ngIf="isEdit" (click)="endEdit()"></a>
      <a (click)="deleteUser(user)">删除</a>
    </li>
  `
}
```

功能可以描述为，有一个属性`isEdit`用来控制是否启用修改，启用则显示为输入框，不启用则显示普通姓名。下面的按钮也是同样的，`beginEdit()`用来将`isEdit`设置成`true`，`endEdit`则相反。

那么问题来了，`isEdit`从哪来？难道要为每个`user`再扩展一个`isEdit`属性么？

```typescript
/* @file app/user.service.ts */
interface User {
  id: number
  name: string
  isEdit? : boolean
}
```

属性后面的`？`表示这是一个可选属性。这么做当然可以，但是现在我想要根据这些内容再创建一个组件，就叫他`UserItemComponent`吧。

新建`app/user-item.component.ts`：

```typescript
/* @file app/user-item.component.ts */
import { Component } from 'angular2/core'

const component = {
    selector: 'user-item',
    template: `
      <span *ngIf="!isEdit">{{user.name}}</span>
      <input *ngIf="isEdit" />
      <a *ngIf="!isEdit" (click)="beginEdit()">修改</a>
      <a *ngIf="isEdit" (click)="endEdit()">完成</a>
    `
}

@Component(component)
export class UserItemComponent { }
```

之前的模板内容移了过来。现在首要先做的是在`UserListComponent`中将他显示出来，还记得我们是怎么往`AppComponent`中塞`<user-list>`的么？

```typescript
/* @file app/user-list.component.ts */
import { UserItemComponent } from './user-item.component'

const component = {
  //...
  directives: [UserItemComponent],
  template: `
    //...
    <li *ngFor="#user of users">
      <user-item></user-item>
      <a (click)="deleteUser(user)">删除</a>
    </li>
    //...
  `
}
```

接下来要把`li`上的`user`传给`<user-item>`，这需要做两件事：

1. 模板中将`user`作为一个属性传递；
2. 在`UserItemComponent`中声明`user`是由外部传入的属性

两个组件都要进行相应的修改：

```typescript
/* @file app/user-list.component.ts */
const component = {
  //...
  template: `
    //...
    <user-item [user]="user"></user-item>
    //...
  `
}
```

还有

```typescript
/* @file app/user-item.component.ts */
import { Component, Input } from 'angular2/core'

export class UserItemComponent {
    @Input()
    user
}
```

又一个注解，这个要好理解一些，`@Input`注释的属性表示由外部提供。

接下来就来实现我们的`beginEdit`和`endEdit`方法，这里还需要一个属性来表示输入框中的值，就用`username`好了：

```typescript
/* @file app/user-item.component.ts */
import { Component, OnInit, Input } from 'angular2/core'

const component = {
  //...
  template: `
    //...
    <input *ngIf="isEdit" [(ngModel)]="username" />
    //...
  `
}

export class UserItemComponent implements OnInit {
  //...
  username: string
  isEdit: boolean = false

  beginEdit() {
    this.isEdit = true
  }

  endEdit() {
    this.isEdit = false
  }

  ngOnInit() {
    this.username = this.user.name
  }
}
```

在初始化时给`username`，赋了初值，这样就不至于输入框为空。

然后，我们要怎么保存结果呢？？？:scream:

方法有很多，但我想聊聊ng2的又一个注解，`@Output`。让我们先来完成`service`中的`UserService#updateUser`方法：

```typescript
/* @file app/app.service.ts */
export class UserService {
  //...
  updateUser(user: User, username: string): Promise<boolean> {
    let idx = this.users.indexOf(user)
    this.users[idx].name = username
    return Promise.resolve(true)
  }
}
```

逻辑很简单，就是简单的替换。再来把列表组件`UserListComponent`的`UserListComponent#updateUser`实现：

```typescript
/* @file app/user-list.component.ts */
export class UserListComponent implements OnInit {
  //...
  updateUser(user: User, username: string): void {
    this._service.updateUser(user, username)
  }
  //...
}
```

好了，万事具备，轮到`@Output`登场了，不过在这之前，我还想让你看一样东西:joy:：

```jsx
class UserList extends React.Component {
  OnUpdateUser() {
    // do something
  }
  render() {
    return (
      <user-item onUpdate={OnUpdateUser}  />
    )
  }
}
```

还记得这个么？在react中，我们把方法名传给子组件，在子组件中调用父组件的方法。如果记忆犹新的话，那就来看看ng2的做法吧：

```typescript
/* @file app/user-list.component.ts */
const component = {
  template: `
    <user-item [user]="user" (updateUser)="updateUser(user, $event)"></user-item>
  `
}
```

```typescript
/* @file app/user-item.component.ts */
export class UserItemComponent implements OnInit {
  //...
  @Output(this.user)
  updateUser = new EventEmitter<string>()
  //...
  endEdit() {
    this.isEdit = false
    this.updateUser.next(this.username)
  }
  //...
}
```





这里需要依赖`user`的`isEdit`属性，还木有怎么办。这有点棘手，需要修改一些地方。首先要修改一下新增方法`createUser`，在新增时给`user.isEdit`加一个默认值`false`：

```typescript
/* @file app/user.service.ts */
createUser(newUser: string): Promise<User> {
  return Promise.resolve({
    id: +new Date(),
    name: newUser,
    isEdit: false
  })
}
```

现在看下控制台服务，糟糕，TypeScript报错了，说与`User`类型不符。当然，我们的`User`类型并没有`isEdit`，给他加一个：

```typescript
/* @file app/user.service.ts */
export interface User {
  id: number
  name: string
  isEdit: boolean
}
```

解决了`User`的类型问题就可以继续实现`updateUser`了，还是老样子，先实现`service`的`updateUser`：

```typescript
/* @file app/user.service.ts */
updateUser(user: User): Promise<boolean> {
  return Promise.resolve(true)
}
```

和`deleteUser`一样，只需简单的返回`true`就好了，接下来实现组件的`updateUser`：

```typescript
/* @file app/user-list.component.ts */
updateUser(user: User): void {
  let toggleEdit: () => void
  toggleEdit = () => {
    user.isEdit = !user.isEdit
  }
  
  if(user.isEdit) {
    this._service.updateUser(user).then(toggleEdit)
  } else {
    toggleEdit()
  }
}
```

`toggleEdit`用来切换`isEdit`的状态，然后在编辑时切换状态，编辑完成点击按钮时发送请求，之后切换状态。

来试一下，没有问题。当然如果你愿意，可以把按钮的`updateUser`移到输入框中。

现在为止，模板的内容已经很多了，是时候把他单独放在一个文件中。新建一个`app/user-list.component.html`，把`template`的内容复制在新文件中：

```html
<!-- @file app/user-list.component.html -->
<div>
  <label>
    添加新用户
    <input type="text" [(ngModel)]="newUser" placeholder="请输入用户名" (keyup.enter)="createUser()" />
  </label>
  <p>要添加的用户为：{{newUser}}</p>
</div>

<div *ngIf="getUsersCount()">
  <ul>
    <li *ngFor="#user of users">
      <span *ngIf="!user.isEdit">{{user.name}}</span>
      <input *ngIf="user.isEdit" [(ngModel)]="user.name" />
      <button type="button" (click)="updateUser(user)">
        <span *ngIf="!user.isEdit">修改</span>
        <span *ngIf="user.isEdit">完成</span>
      </button>
      <button type="button" (click)="deleteUser(user)">删除</button>
    </li>
  </ul>
  <p>用户的数量是：{{getUsersCount()}}</p>
</div>
<div *ngIf="!getUsersCount()">
  <p>木有用户(°Д°)</p>
</div>
```

之前的`template`不再需要了，改为：

```typescript
/* @file app/user-list.component.ts */
templateUrl: 'app/user-list.component.html'
```

让我们再来看看两个重要文件`app/user-list.component.ts`和`app/user.service.ts`：

```typescript
/* @file app/user-list.component.ts */
import { Component, OnInit } from 'angular2/core'
import { User, UserService } from './user.service'

const component = {
  selector: 'user-list',
  templateUrl: 'app/user-list.component.html'
}

@Component(component)
export class UserListComponent implements OnInit {
  constructor(private _service: UserService) {}

  users: User[]
  newUser: string

  getUsersCount(): number {
    if(!this.users) return 0
    return this.users.length
  }

  createUser(): void {
    if(typeof this.newUser !== 'string' || !this.newUser.trim()) return;
    this._service.createUser(this.newUser).then(user => {
      this.users = this.users.concat(user)
      this.newUser = '';
    })
  }

  deleteUser(user: User): void {
    this._service.deleteUser(user).then(() => {
      let idx = this.users.findIndex(userItem => userItem.id === user.id)
      this.users = [].concat(this.users.slice(0, idx)).concat(this.users.slice(idx + 1))
    })
  }

  updateUser(user: User): void {
    let toggleEdit: () => void
    toggleEdit = () => {
      user.isEdit = !user.isEdit
    }
  
    if(user.isEdit) {
      this._service.updateUser(user).then(toggleEdit)
    } else {
      toggleEdit()
    }
  }
		
  ngOnInit(): void {
    this._service.getUsers().then(users => this.users = users)
  }
}
```

```typescript
/* @file app/user.service.ts */
import { Injectable } from 'angular2/core'

export interface User {
  id: number
  name: string
  isEdit: boolean
}

@Injectable()
export class UserService {
  getUsers(): Promise<User[]> {
    return Promise.resolve([])
  }
  createUser(newUser: string): Promise<User> {
    return Promise.resolve({
      id: +new Date(),
      name: newUser,
      isEdit: false
    })
  }
  deleteUser(user: User): Promise<boolean> {
    return Promise.resolve(true)
  }
  updateUser(user: User): Promise<boolean> {
    return Promise.resolve(true)
  }
}
```

# 当然，还有重要的东西没有说

对于修改，我并不是很满意，原因是每个用户往往都有对应的详细页面来去做这些事情。这就要轮到路由出场了，来会会我们的老朋友吧。

使用路由要进行一些麻烦的配置，那就从外往里修改好了，首先就是启动文件`app/boot.ts`：

```typescript
import { bootstrap } from 'angular2/platform/browser'
import { AppComponent } from './app.component'
import { ROUTER_PROVIDERS } from 'angular2/router'

bootstrap(AppComponent, [ROUTER_PROVIDERS])
```

然后是`app/app.component.ts`：

```typescript
/* @file app/app.component.ts */
import { Component } from 'angular2/core'
import { RouteConfig, ROUTER_DIRECTIVES } from 'angular2/router'
import { UserListComponent } from './user-list.component'
import { UserService } from './user.service'

const component = {
  selector: 'my-app',
  directives: [ROUTER_DIRECTIVES],
  providers: [UserService],
  template: `
    <h1>Hello World</h1>
    <router-outlet></router-outlet>
  `
}

const router: RouteDefinition = [
  { path: '/users', name: 'UserList', component: UserListComponent, useAsDefault: true }
]

@Component(component)
@RouteConfig(router)
export class AppComponent {}
```

接下来是熟悉的组件`app/user-list.component.ts`:

```typescript
/* @file app/user-list.component.ts */
import { Router } from 'angular2/router'

constructor(private _service: UserService,
            private _router: Router) {}
```

有点多，来依次看看。

在`app/boot.ts`中，引入了`ROUTER_PROVIDERS`，用来将路由注入到组件中。而在`app/app.component.ts`引入了`RouteConfig`和`ROUTER_DIRECTIVES`。`RouteConfig`就是稍后看到的`@RouteConfig`注解，而`ROUTER_DIRECTIVES`是模板中的`<router-outlet>`，作用是占位符。接下来的：

```typescript
const router = [
  { path: '/user-list', name: 'UserList', component: UserListComponent, useAsDefault: true }
]
```

就是路由的定义了。路由定义和其他框架类似，`path`是必须的，代表了路径；`name`是名称；`component`是替代`<router-outlet>`的组件；`useAsDefault: true`则表示路由到根目录`/`时，默认采用这个组件。

再来看看`app/user-list.component.ts`。更新的地方就是组件类的构造函数，多加了一个参数`private _router: Router`，他的签名是`Router`，已经在上边导入了。

这时更新浏览器，报木有找到`angular2/router`。原因是`router`并没有在核心`core`中实现，需要另外引入，怎么做呢？只需要把脚本仍在`index.html`就好了：

```html
<!-- @file index.html -->
<script src="node_modules/angular2/bundles/router.dev.js"></script>
```

当然，单页App还需要一个标签，那就是：

```html
<!-- @file index.html -->
<base href="/">
```

现在等待浏览器刷新。路径会默认变为`localhost:3000/users`。

接下来回归主题，配合路由，我要实现的功能是：

* 访问`localhost:3000/users/1`时，表示访问`id`为`1`用户的详情；
* 在每个`user`后边加一个链接，跳转到对应的详情页；
* 在详情页添加一个返回按钮，返回`users`，即用户列表

当然，目前为止还没有`user`详情的组件，那就来创建一个吧。新建`app/user-detail.component.ts`和`app/user-detail.component.html`。

```typescript
/* @file app/user-detail.component.ts */
import { Component } from 'angular2/core'
import { Router } from 'angular2/router'

const component = {
  selector: 'user-detail',
  templateUrl: 'app/user-detail.component.html'
}

@Component(component)
export class UserDetailComponent {
  constructor(private _router: Router) {}
}
```

```html
<!-- @file app/user-detail.html -->
<h2>User Detail</h2>
```

接下来就按照我们的计划，先来定义路由，那么还是在`app/app.component.ts`添加一条路由规则：

```typescript
/* @file app/app.component.ts */
import { UserDetailComponent } from './user-detail.component'

const router: RouteDefinition[] = [
  { path: '/users', name: 'UserList', component: UserListComponent, useAsDefault: true },
  { path: '/users/:id', name: 'UserDetail', component: UserDetailComponent }
]
```

路由`path`中的`:id`表示动态段，就是说，这条路由可以匹配`/users/1`，也可以匹配`/users/666666`。当然，这里就不需要`useAsDefault`了。由于用到了组件`UserDetailComponent`，需要在开始处导入。

接下来实现第二条，这需要修改我们的老朋友`app/user-list.component.html`：

```html
<!-- @file app/user-list.html -->
<a *ngIf="!user.isEdit" [routerLink]="['UserDetail', {id: user.id}]">{{user.name}}</a>
```

这里只需要把之前的`<span>`标签改为`<a>`标签就好，需要注意的是`[routerLink]="['UserDetail', {id: user.id}]"`，这是干嘛的呢。我想你已经猜到了，这句就相当于`<a href="/users/:id">`，`UserDetail`我们在`app/app.component.ts`的路由里面定义过，就是`name`值，`{id: user.id}`的意思也很明了，就是把动态段`:id`的值赋予`user.id`。

这样还不算完，用到`[routerLink]`要付出一点代价，那就是需要把他先引入组件中，修改`app/user-list.component.ts`：

```typescript
/* @file app/user-list.component.ts */
import { Router, ROUTER_DIRECTIVES } from 'angular2/router'

const component = {
  selector: 'user-list',
  directives: [ROUTER_DIRECTIVES],
  templateUrl: 'app/user-list.component.html'
}
```

`directives`就是需要修改的地方，和最开始在`app/app.component.ts`需要用`<user-list>`时是一样的。

还有最后要做的，就是添加一个返回链接。修改`app/user-detail.component.ts`：

```html
<!-- @file app/user-detail.html -->
<a [routerLink]="['UserList']">返回</a>
```

这里又用到了`[routerLink]`，处理方式你应该也知道了：

```typescript
/* @file app/user-detail.component.ts */
import { Router, ROUTER_DIRECTIVES } from 'angular2/router'

const component = {
  selector: 'user-detail',
  directives: [ROUTER_DIRECTIVES],
  templateUrl: 'app/user-detail.component.html'
}
```

搞定，来试试看。可以来回跳转，但是，详细页的数据要怎么显示？

# 恩，这确实是个难点

详细页的数据要怎么显示？这有点棘手，原因是并没有保存过任何创建的`user`。看来首先要做的就是保存`users`，怎么做呢？

修改`app/user.service.ts`：

```typescript
/* @file app/user.service.ts */
export class UserService {
  constructor() { this.users = [] }

  users: User[]
}
```

注意他的类型签名，用一个`users`属性来保存创建的users。这样一来，创建方法`UserService#createUser`，也需要修改：

```typescript
/* @file app/user.service.ts */
createUser(newUser: string): Promise<boolean> {
  let user: User = {
    id: +new Date(),
    name: newUser,
    isEdit: false
  }
  this.users.push(user)
  return Promise.resolve(true)
}
```

这里返回`true`来替代之前的`user`，在返回之前把创建的user保存在`users`数组中。

因为有了`users`，返回数据方法`UserService#getUsers`也需要改变：

```typescript
/* @file app/user.service.ts */
getUsers(): Promise<User[]> {
  return Promise.resolve(this.users)
}
```

这样我们还需要一个返回单个user的方法，用来在用户详情页显示数据：

```typescript
/* @file app/user.service.ts */
getUser(id: number): Promise<User> {
  let _user: User = this.users.find(user => user.id === id)
  return Promise.resolve(_user)
}
```

注意这两个方法返回值的签名。这样就有了基本设施。但还不算完，对应`app/user-list.component.ts`组件的`createUser`也需要修改：

```typescript
/* @file app/user-list.component.ts */
createUser(): void {
  if(typeof this.newUser !== 'string' || !this.newUser.trim()) return;
  this._service.createUser(this.newUser)
}
```

这就木问题了，接下来要做的就是在`app/user-detail.component.ts`中添加逻辑，来显示内容。和`user-list`如出一辙，需要一个属性和初始化方法：


```typescript
/* @file app/user-detail.component.ts */
import { User, UserService } from './user.service'

export class UserDetailComponent implements OnInit {
  constructor(private _router: Router,
              private _service: UserService) {}

  user: User

  ngOnInit() {
    /* getUser(id) */
  }
}
```

初始化方法要怎么写呢，现在需要的是地址栏路由中的动态段，也就是`:id`。想要获取这个值，需要用到`RouteParams`：

```typescript
/* @file app/user-detail.component.ts */
import { Router, RouteParams, ROUTER_DIRECTIVES } from 'angular2/router'

export class UserDetailComponent implements OnInit {
  constructor(private _router: Router,
              private _params: RouteParams,
              private _service: UserService) {}

  user: User

  ngOnInit() {
    let id = +this._params.get('id')
    this._service.getUser(id).then(user => this.user = user)
  }
}
```

在构造时就传入组件，然后可以用`this._params.get`来获取动态段的值。

剩下的工作就很简单了，修改模板`app/user-detail.component.html`：

```typescript
<!-- @file app/user-detail.html -->
<div *ngIf="user">{{user.name}}</div>
```

来试试我们的努力吧。

最后来看下我们的所有文件吧，他们是：

* index.html
* app/boot.ts
* app/app.component.ts
* app/user-list.component.ts
* app/user-list.component.html
* app/user-detail.component.ts
* app/user-detail.component.html
* app/user.service.html

```html
<!-- @file index.html -->
<!DOCTYPE html>
<html>
  <head>
    <base href="/">
		
    <title>Angular 2 QuickStart</title>
    <link rel="stylesheet" href="styles/index.css" type="text/css" media="screen" />

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

  <!-- 3. Display the application -->
  <body>
    <my-app>Loading...</my-app>
  </body>

</html>
```

```typescript
/* @file app/boot.ts */
import { bootstrap } from 'angular2/platform/browser'
import { AppComponent } from './app.component'
import { ROUTER_PROVIDERS } from 'angular2/router'

bootstrap(AppComponent, [ROUTER_PROVIDERS])
```

```typescript
/* @file app/app.component.ts */
import { Component } from 'angular2/core'
import { RouteConfig, ROUTER_DIRECTIVES, RouteDefinition } from 'angular2/router'
import { UserListComponent } from './user-list.component'
import { UserDetailComponent } from './user-detail.component'
import { UserService } from './user.service'

const component = {
  selector: 'my-app',
  directives: [ROUTER_DIRECTIVES],
  providers: [UserService],
  template: `
    <h1>Hello World</h1>
    <router-outlet></router-outlet>
    `
}

const router: RouteDefinition[] = [
  { path: '/users', name: 'UserList', component: UserListComponent, useAsDefault: true },
  { path: '/users/:id', name: 'UserDetail', component: UserDetailComponent }
]

@Component(component)
@RouteConfig(router)
export class AppComponent {}
```

```typescript
/* @file app/user-list.component.ts */
import { Component, OnInit } from 'angular2/core'
import { Router, ROUTER_DIRECTIVES } from 'angular2/router'
import { User, UserService } from './user.service'

const component = {
  selector: 'user-list',
  directives: [ROUTER_DIRECTIVES],
  templateUrl: 'app/user-list.component.html'
}

@Component(component)
export class UserListComponent implements OnInit {
  constructor(private _service: UserService,
              private _router: Router) {}
		
  users: User[]
  newUser: string

  getUsersCount(): number {
    if(!this.users) return 0
    return this.users.length
  }
  createUser(): void {
    if(typeof this.newUser !== 'string' || !this.newUser.trim()) return;
    this._service.createUser(this.newUser)
  }
  deleteUser(user: User): void {
    this._service.deleteUser(user).then(() => {
      let idx = this.users.findIndex(userItem => userItem.id === user.id)
      this.users = [].concat(this.users.slice(0, idx)).concat(this.users.slice(idx + 1))
    })
  }
  updateUser(user: User): void {
    let toggleEdit: () => void
    toggleEdit = () => {
      user.isEdit = !user.isEdit
    }
  
    if(user.isEdit) {
      this._service.updateUser(user).then(toggleEdit)
    } else {
      toggleEdit()
    }
  }
  ngOnInit(): void {
    this._service.getUsers().then(users => this.users = users)
  }
}
```

```html
<!-- @file app/user-list.component.html -->
<div>
  <label>
    添加新用户
    <input type="text" [(ngModel)]="newUser" placeholder="请输入用户名" (keyup.enter)="createUser()" />
  </label>
  <p>要添加的用户为：{{newUser}}</p>
</div>

<div *ngIf="getUsersCount()">
  <ul>
    <li *ngFor="#user of users">
      <a *ngIf="!user.isEdit" [routerLink]="['UserDetail', {id: user.id}]">{{user.name}}</a>
      <input *ngIf="user.isEdit" [(ngModel)]="user.name" />
      <button type="button" (click)="updateUser(user)">
        <span *ngIf="!user.isEdit">修改</span>
        <span *ngIf="user.isEdit">完成</span>
      </button>
      <button type="button" (click)="deleteUser(user)">删除</button>
    </li>
  </ul>
  <p>用户的数量是：{{getUsersCount()}}</p>
</div>
<div *ngIf="!getUsersCount()">
  <p>木有用户(°Д°)</p>
</div>
```

```typescript
/* @file app/user-detail.component.ts */
import { Component, OnInit } from 'angular2/core'
import { Router, RouteParams, ROUTER_DIRECTIVES } from 'angular2/router'
import { User, UserService } from './user.service'

const component = {
  selector: 'user-detail',
  directives: [ROUTER_DIRECTIVES],
  templateUrl: 'app/user-detail.component.html'
}

@Component(component)
export class UserDetailComponent implements OnInit {
  constructor(private _router: Router,
              private _params: RouteParams,
              private _service: UserService) {}

  user: User

  ngOnInit() {
    let id = +this._params.get('id')
    this._service.getUser(id).then(user => this.user = user)
  }
}
```

```html
<!-- @file app/user-detail.html -->
<h2>User Detail</h2>
<a [routerLink]="['UserList']">返回</a>
<div *ngIf="user">{{user.name}}</div>
```

```typescript
/* @file app/user.service.ts */
import { Injectable } from 'angular2/core'

export interface User {
  id: number
  name: string
  isEdit: boolean
}

@Injectable()
export class UserService {
  constructor() { this.users = [] }
  
  users: User[]
  
  getUsers(): Promise<User[]> {
    return Promise.resolve(this.users)
  }
  getUser(id: number): Promise<User> {
    let _user: User = this.users.find(user => user.id === id)
    return Promise.resolve(_user)
  }
  createUser(newUser: string): Promise<boolean> {
    let user: User = {
      id: +new Date(),
      name: newUser,
      isEdit: false
    }
    this.users.push(user)
    return Promise.resolve(true)
  }
  deleteUser(user: User): Promise<boolean> {
    return Promise.resolve(true)
  }
  updateUser(user: User): Promise<boolean> {
    return Promise.resolve(true)
  }
}
```

# 回归主题，新年快乐！

草草的结束了，但就作为入门来说足够。还有好多东西没有做，更新和删除方法还没有重写，也有一些好玩的特性没有介绍，比如**pipe**，**@input**和**@output**，也没有真正的持久化数据，打包原生App也没做。但是，这些事情就交给你，我想他们应该很简单。

接下来要做的，我建议自己独立实现一个Todos。Todos完成后就可以踏上真正的ng2之路，这条路虽不会像react那样的平稳，但只要努力，这些都不是问题，对么？:v:

那么，新年快乐(｡◕‿◕｡)

See you again.:two_hearts:

# 附录，TypeScript 101

前面已经介绍了一些，至少你知道了ts是类型版js，那么带着这个理解开始我们的ts之旅。

## 基本类型

最好的解释就是直接看实例。首先是简单的基本类型，包括字符串、数字、布尔值：

```typescript
let foo: number = 42
let bar: string = 'hello world'
let bar: boolean = true
```

变量的类型用`var: type`来表示。

接下来是稍复杂一些的，数组：

```typescript
let list1: number[] = [1, 2, 3]
let list2: Array<string> = ['foo', 'bar', 'baz']
```

他有两种表示方式：

1. type加[]，如number[]；
2. Array<type>的形式

然后是枚举Enum，这有些不太一样：

```typescript
enum Color = {
	red,
	green,
	blue
}

let color = Color.red
```

枚举的默认值从0开始，也就是说`Color.red`的值为0，当然也可以给他赋一个数字，就像这样：

```typescript
enum Color = {red = 1}
```

这之后是一个很有意思的类型，他表示任意类型，用`Any`表示：

```typescript
let foo: any = 42
let foo = 'bar' // 没问题
let foo = true // 没问题
```

最后一个基本类型是`void`他表示不返回东西，通常用在函数上：

```typescript
function addClass(): void {
	$el.addClass('active')
}
```

## 接口类型

有些时候想要定义一些我们自己的类型，`Interfaces`会派上用场。

比如我像定义一个圆，他由原点和半径组成，而原点又由x，y两个数字组成的坐标表示：

```typescript
interface Point {
	x: number
	y: number
}
interface Circle {
	point: Point
	radius: number
}
```

Point和Circle就是新定义的类型：

```typescript
let circle: Circle = {
  point: {
    x: 0,
    y: 0
  },
  radius: 10
}
```

当然，有些类型可能不是必须的，可以在属性后边加`?`表示这个属性可选：

```typescript
interface Point {
  x: number
  y: number
  color?: string
}
```

在js中，函数也是一个类型，在Interface中也有函数的表示：

```typescript
interface toUpperCaseFunc {
  (str: string): string
}

let toUpperCase: toUpperCaseFunc = function(str) {
  return str.toUpperCase()
}
```

这是一个把字符串变成大写的函数，Interface里括号中的内容是参数和他的类型，后边部分是返回值的类型。


