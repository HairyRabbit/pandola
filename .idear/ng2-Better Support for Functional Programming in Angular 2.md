# ng2更好的支持函数式编程

本文来自于 [Better Support for Functional Programming in Angular 2](http://victorsavkin.com/post/108837493941/better-support-for-functional-programming-in)

这篇文章将讨论Angular2中的变化，以及对函数式编程的支持情况。

Angular2目前依然处于开发阶段，还没有稳定，本文例子可能会变化。但请把关注点放在功能和理论的讨论上，而不揪着API不放。

## 为什么要使用函数式编程

想象程序是由一个个嵌套组件构成的。并且我们应该这样做：

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

由于ng2不使用KVO（Key-Value-Observing），而是用脏值检查代替，他不需要我们用我们的数据模型类。所以我们通常可以使用数组和简单对象做为我们的模型。

> KVO是一种观察者机制，就是说当属性被修改后，响应的观察者会得到通知。

> 脏值检查

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

这里，todos是一个数组。请注意，我们没有改变任何对象，我们可以这样做是因为ng2不强迫必须用可变量。

We can already write this kind of code in Angular today. What we want is to make it smoother, and take advantage of it performance wise.

我们现在已经可以把这种代码写在今天了。我们所希望的是使他更顺畅，并充分利用他的性能。

## Using Persistent Data Structures

使用持久化数据结构

For example, we want to improve the support of persistent data structures.

例如，我们要改进持久性数据结构的支持。

First, we want to support even most exotic collections. And, of course, we do not want to hardcode this support into the framework. Instead, we are making the new change detection system pluggable. So we will be able to pass any collection to ng-repeat or other directives, and it will work. The directives will not have to have special logic to handle them.

首先，我们要支持各式各样的集合。当然，我们不想硬编码到框架中。相反，我们正在制定新的变化检测系统插件。因此，我们将能够通过任何收集到的重复或其他指令，它将工作。指令将不需要有特殊的逻辑来处理他们。

```typescript
<todo template=”ng-repeat: #t in: todos” [todo]=”t”></todo> // what is todos? array? immutable list? does not matter.
```

Second, we can also take advantage of the fact that these collections are immutable. For example, we can replace an expensive structural check to see if anything changed with a simple reference check, which is much faster. And it will be completely transparent to the developer.

其实，我们也可以利用这些集合是不可变的事实。例如我们可以更换一个结构检查，看看是否有任何改变了一个简单的参考检查，这是更快的。对于开发者而言，这是完全透明的。

## Controlling Change Detection

控制变化检测

Functional programming limits the number of ways things change, and it makes the changes more explicit. So because our application written in a functional way, we will have stronger guarantees, even though the JavaScript language itself does not provide those guarantees.

函数式编程限制了状态的改变，他使得改变更加明显。因为我们编写的应用程序功能的方式，我们将有更强的保证，即便Javascript语言本身并不提供这种担保。

For example, we may know that a component will not change until we receive some event. Now, we will be able to use this knowledge and disable the dirty-checking of that component and its children altogether.

例如，我们可以知道，一个组件不会变化直到我们收到一些事件。现在，我们将能够使用这方面的知识，并禁用该组件和它的子组件的脏值检查。

A few examples where this feature can come handy: * If a component depends on only observable objects, we can disable the dirty-checking of the component until one of the observables fires an event. * If we use the FLUX pattern, we can disable the dirty-checking of the component until the store fires an event.

下面的例子，这个功能可以派上用场：如果一个组件只依赖于observable，我们就可以禁用组件的脏值检查直到observable触发一个事件；如果我们使用flux模式，我们可以禁用组件的脏值检查，直到store触发一个事件。

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

我们的程序不只是检测数据到dom。我们需要处理用户输入，今天的主要方式是使用NgModel


NgModel is a convenient way of dealing with the input, but it has a few drawbacks:

NgModel 是一个处理用户输入很方便的方式，但他有一些缺点：

* It does not work with immutable objects.
* 他不能作用于不可变对象
* It does not allow us to work with the form as a whole.
* 他不能允许我们以一个整体的form来工作

For instance, if in the example below todo is immutable, which we would prefer, NgModel just will not work.

例如，如果下面的例子中todo是不可变的，我们就希望NgModel不要工作。

```html
<form>
 <input [ng-model]="todo.description">
 <input [ng-model]="todo.checked">
 <button (click)="updateTodo(todo)">Update</button>
</form>
```

So NgModel forces us to copy the attributes over and reassemble them back after we are done editing them.

所以，NgModel 迫使我们编辑完他们后复制属性和组装他们。

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

This is not a bad solution, but we can do better than that.

这不是一个坏的办法，但是我们可以做的更好。

A better way of dealing with forms is treating them as streams of values. We can listen to them, map them to another stream, and apply FRP techniques.

处理表单更好的方法是将他们作为流来处理流的值。我们可以监听他们，遍历其他流或是应用FRP技术。

Template:
模板

```html
<form [control-group]="filtersForm">
  <input control-name="description">
  <input control-name="checked">
</form>
```

Component:
组件

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

We can also take the current value of the whole form, like shown below.

我们也可以采取当前整个表单的值，像下面这样。

Template:

模板

```html
<form #todoForm [new-control-group]="todo">
  <input control-name="description">
  <input control-name="checked">
  <button (click)="updateTodo(todoForm.value)">Update</button>
</form>
```

Component:

组件

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

Summary

总结

* We want to be able to reason about every component in isolation. And we want changes to be predictable and controlled. Functional programming is a common way of achieving it.
* Data-oriented programming is a big part of it. Although Angular has always supported it, there are ways to make it even better. For example, by improving support of persistent data structures.
* When using functional programming we have stronger guarantees about how things change. We will be able to use this knowledge to control change detection.
* The current way of dealing with dealing with the user input, although convenient, promotes mutability. A more elegant way is to treat forms as values, and streams of values.

* 我们希望能够对每一个组件隔离。我们希望改变是可预测和可控的。函数式编程是实现他的一种常见方法。
* 面向数据编程是他的一个重要部分，虽然ng2一直支持他，有办法让他更好。例如通过改进支持数据结构的支持。
* 当使用函数式编程时，我们有更强的保证，关于如何改变。我们将能够使用这方面的只是来控制变化检测。
* 目前的处理方式，处理用户输入，虽然方便，促进性。一个更优雅的方式是把表单作为一个值和一个流的值。
