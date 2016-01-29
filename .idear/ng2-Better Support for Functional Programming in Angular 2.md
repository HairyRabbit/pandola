# Angular2更好的支持函数式编程

本文来自于 [Better Support for Functional Programming in Angular 2](http://victorsavkin.com/post/108837493941/better-support-for-functional-programming-in)

这篇文章将讨论Angular2中的变化，以及对函数式编程的支持情况。

Angular2目前依然处于开发阶段，还没有稳定，本文的例子可能会变化。但请不要在意这些细节，把关注点放在功能和理论的讨论上，而不揪着API不放。

## 为什么要使用函数式编程

如果想象程序是由一个个嵌套组件构成的，我们就应该这样做：

* 组件只决定于自身值绑定和他的子组件
* 组件只能影响他的子组件

例如，`Todo Component`不应该影响除了`Input`外的任何其他组件。

If we write our application in this way, we get the property:

如果我们按照这个方式来写我们的程序，就会得到如下结论：

We can effectively reason about every single component without knowing where it is used. In other words, we can reason about a component just by looking at its class/function and its template.

我们仅仅对每个组件自身编程，还不需要去关心他被使用的环境。换句话说，仅仅通过查看他的代码和模板就可以推敲出这个组件的功能。

我们想要实现对可变状态的控制，利用函数式编程就可以实现这一点。

## 面向数据编程

使用可变model时，我们说组件中的model也是可变的，当model被更新时，引用model的其他组件也会被同时更新。

Instead we should model our domain using dumb data structures, such as record-like objects and arrays, and transform them using map, filter, and reduce.

恰恰相反，我们应该使用不可变数据结构，如数组可类数组对象来充当我们的model，然后利用**map** **filter** **reduce** 来改变他们。

> map filter reduce 是函数式编程中三个最重要的函数，分别代表了转换，过滤，以及聚合。

Since Angular does not use KVO, and uses dirty-checking instead, it does not require us to wrap our data into model classes. So we could always use arrays and simple objects as our model.

由于ng2没有使用KVO（Key-Value-Observing），而是用了脏值检查代替，所以我们不需要在数据外套一层壳子，仅仅使用数组和对象来做为我们的model就可以了。

> KVO是一种观察者机制，就是说当属性被修改后，响应的观察者会得到通知。这个机制可以用来实现双向绑定。

> 脏值检查和KVO一样，也是实现双向绑定的一种机制。Angular2中脏值检查使用[zone.js]((https://github.com/angular/zone.js))库来实现。

```typescript
class TodosComponent {
  constructor(http:Http) {
    this.todos = [];

    http.get("/todos").
      then((resp) => {
        this.todos = resp.map((todo) =>
          replaceProperty(todo, "date", humanizeDate))
      });
  }

  checkAll() {
    this.todos = this.todos.map((todo) =>
      replaceProperty(todo, 'checked', true));
  }

  numberOfChecked() {
    return this.todos.filter((todo) => todo.checked).length;
  }
}
```

Here, for example, todos is an array of simple objects. Note, we do not mutate any of the objects. And we can do it because the framework does not force us to build a mutable domain model.

这里，todos是一个简单数组。但要注意，我们并没有改变任何属性（map，filter会返回一个新的绑定，而不是改变原来变量的值），我们可以这样做是因为ng2不要求必须使用可变量。

函数式的代码看起来更优雅，并且性能也不错。

## 持久化数据结构

For example, we want to improve the support of persistent data structures.

现在，我们要改进对持久化数据结构的支持。

First, we want to support even most exotic collections. And, of course, we do not want to hardcode this support into the framework. Instead, we are making the new change detection system pluggable. So we will be able to pass any collection to ng-repeat or other directives, and it will work. The directives will not have to have special logic to handle them.

首先，我们要支持各式各样的集合数据结构（例如Immutable.js定义的数据结构，或是es6中的Set，Map等等）。

当然，我们可不能直接写在框架中。与之相反的是，我们会实现检测变化的逻辑。因此，我们能够使用`ng-repeat`或其他指令来工作。这些指令将不需要有特殊的逻辑来处理他们。

```typescript
<todo template=”ng-for: #t in todos” [todo]=”t”></todo> 

// todos是什么？数组？immutable的list？无所谓。
```

其实，我们可以充分利用不可变性的特征。

对于检查一个值是否变了，用直接给他赋新的值的方式，显然要更快一些。并且对于开发者而言，这是完全透明的操作。

## 控制状态的改变

函数式编程限制了状态的改变，他使得属性在变化时格外明显。这为我们编写可扩展应用程序提供了强有力的武器。即便Javascript语言本身并不提供这种保证。

例如，我们知道，事件会引起属性的改变。现在，我们将演示如何通过不可变性，绕过脏值检查。

A few examples where this feature can come handy: * If a component depends on only observable objects, we can disable the dirty-checking of the component until one of the observables fires an event. * If we use the FLUX pattern, we can disable the dirty-checking of the component until the store fires an event.

下面的例子，这个功能可以派上用场：

* 如果组件依赖于observable，我们就可以利用他触发`onChange`事件来绕过脏值检查。；
* 也可以使用flux模式触发store的action来绕过脏值检查检查。

```typescript
class TodosComponent {
  constructor(bingings:BindingPropagationConfig, store:TodoStore) {
    this.todos = ImmutableList.empty();
    store.onChange(() => {
      this.todos = store.todos();
      bingings.shouldBePropagated();
    });
  }
}
```

## Forms & Ng-Model

表单和ngModel

Our applications are not just projections of immutable data onto the DOM. We need to handle the user input. And the primary way of doing it today is NgModel.

我们的程序不仅仅是把数据绑定到dom。有时还需要处理用户输入。目前使用最多的就是NgModel。


NgModel is a convenient way of dealing with the input, but it has a few drawbacks:

NgModel 是一个处理用户输入很方便的方式，但他有一些缺点：

* 他不能作用于不可变对象
* It does not allow us to work with the form as a whole.
* 他不允许我们以一个整体的form来工作

For instance, if in the example below todo is immutable, which we would prefer, NgModel just will not work.

例如，如果下面的例子中todo是不可变的，我们就希望NgModel不要自动更新属性。

```html
<form>
 <input [ng-model]="todo.description">
 <input [ng-model]="todo.checked">
 <button (click)="updateTodo(todo)">Update</button>
</form>
```

所以，这样不得不在编辑完成后对属性重新赋值。

```typescript
class TodoComponent {
  todo:Todo;
  description:string;
  checked:boolean;

  actions:Actions;
  constructor(actions:Actions){
    this.actions = actions;
  }

  set todo(t) {
    this.todo = t;
    this.description = t.description;
    this.checked = t.checked;
  }

  updateTodo() {
    this.actions.updateTodo(this.todo.id,
      {description: this.description, checked: this.checked});
  }
}
```

使用set这也是一个办法，但我们可以做的更好。

处理表单更好的方式是将他们作为流来处理。应用FRP技术，我们可以监听这些流，map他们。

模板：

```html
<form [control-group]="filtersForm">
  <input control-name="description">
  <input control-name="checked">
</form>
```

组件：

```typescript
class FiltersComponent {
  constructor(fb:FormBuilder, actions:Actions) {
    this.filtersForm = fb({
      description: string, checked: boolean
    });

    this.filtersForm.values.debounce(500).forEach((formValue) => {
      actions.filterTodos(formValue);
    });
  }
}
```

我们也可以采用当前整个表单的值，像下面这样。

模板：

```html
<form #todoForm [new-control-group]="todo">
  <input control-name="description">
  <input control-name="checked">
  <button (click)="updateTodo(todoForm.value)">Update</button>
</form>
```

组件：

```typescript
class TodoComponent {
  todo:Todo;

  actions:Actions;
  constructor(actions:Actions) {
    this.actions = actions;
  }

  updateTodo(formValue) {
    this.actions.updateTodo(this.todo.id, formValue);
  }
}
```

总结

* 组件应该是独立的，状态应该是可控的，而函数式编程可以实现这一点。
* 面向数据编程是ng2的一个重要部分，虽然ng2一直支持他，但是使用不可变性可以做的他更好。
* 当使用函数式编程时，我们就有了一个强大的武器来控制可变状态。
* 使用ngModel，处理用户输入，虽然方便。但把表单作为一个流来看待无疑会更优雅。
