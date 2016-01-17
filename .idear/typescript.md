#TypeScript

## 基本类型

For programs to be useful, we need to be able to work with some of the simplest units of data: numbers, strings, structures, boolean values, and the like. In TypeScript, we support much the same types as you would expected in JavaScript, with a convenient enumeration type thrown in to help things along.

### Boolean 布尔值

最基本的数据类型是值`true`和`false`，JavaScript和TypeScript（其他一些语言）称之为布尔（boolean）值。

```typescript
var isDone: boolean = false;
```

### Number 数字

和JavaScript一样，所有的数字在TypeScript中都是浮点值，这些值的类型为数字（number）类型。

```typescript
var height: number = 6;
```

### String 字符串

Another fundamental part of creating programs in JavaScript for webpages and servers alike is working with textual data. As in other languages, we use the type 'string' to refer to these textual datatypes. Just like JavaScript, TypeScript also uses the double quote (") or single quote (') to surround string data.

```typescript
var name: string = "bob";
name = 'smith';
```

### Array 数组

TypeScript, like JavaScript, allows you to work with arrays of values. Array types can be written in one of two ways. In the first, you use the type of the elements followed by '[]' to denote an array of that element type:

```typescript
var list:number[] = [1, 2, 3];
```

The second way uses a generic array type, Array<elemType>:

```typescript
var list:Array<number> = [1, 2, 3];
```

### Enum 枚举

A helpful addition to the standard set of datatypes from JavaScript is the 'enum'. Like languages like C#, an enum is a way of giving more friendly names to sets of numeric values.

```typescript
enum Color {Red, Green, Blue};
var c: Color = Color.Green;
```

By default, enums begin numbering their members starting at 0. You can change this by manually setting the value of one its members. For example, we can start the previous example at 1 instead of 0:

```typescript
enum Color {Red, Green, Blue};
var c: Color = Color.Green;
```

Or, even manually set all the values in the enum:

```typescript
enum Color {Red = 1, Green = 2, Blue = 4};
var c: Color = Color.Green;
```

A handy feature of enums is that you can also go from a numeric value to the name of that value in the enum. For example, if we had the value 2 but weren't sure which that mapped to in the Color enum above, we could look up the corresponding name:

```typescript
enum Color {Red = 1, Green, Blue};
var colorName: string = Color[2];

alert(colorName);
```

### Any 任意

We may need to describe the type of variables that we may not know when we are writing the application. These values may come from dynamic content, eg from the user or 3rd party library. In these cases, we want to opt-out of type-checking and let the values pass through compile-time checks. To do so, we label these with the 'any' type:

```typescript
var notSure: any = 4;
notSure = "maybe a string instead";
notSure = false; // okay, definitely a boolean
```

The 'any' type is a powerful way to work with existing JavaScript, allowing you to gradually opt-in and opt-out of type-checking during compilation.

The 'any' type is also handy if you know some part of the type, but perhaps not all of it. For example, you may have an array but the array has a mix of different types:

```typescript
var list:any[] = [1, true, "free"];

list[1] = 100;
```

### Void 空

Perhaps the opposite in some ways to 'any' is 'void', the absence of having any type at all. You may commonly see this as the return type of functions that do not return a value:

```typescript
function warnUser(): void {
    alert("This is my warning message");
}
```


