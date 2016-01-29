# Server Communication

Learn to build applications that talk to a server.

Whew! We already learned quite a lot about how Angular 2 works. One thing that we haven't looked into yet is how to communicate with a backend. Most applications will come to a point where they either want to read from or write to a remote location. Angular 2 has excellent support for such scenarios so let's dive right into it.

Try the [live example](http://localhost:3000/resources/live-examples/server-communication/ts/plnkr.html).

## The Basics

When we look at the broad task of connecting multiple devices to talk to each other, there really are plenty of different options. If we zoom in a little and restrict us to only look at the options that allow a web application that runs in a browser to communicate with a backend we are basically left with communication via the [HTTP]() or [WebSocket]() protocol.

For web apps to communicate via **HTTP** there are basically two different techniques which are **XMLHttpRequest (XHR)** and **JSONP**. They are quite different from each other both in purpose and implementation. Angular comes with its own built-in abstractions that allow us to exploit both techniques in a nicely well integrated way.

## Http Client

We use the Angular **Http** client to communicate via **XMLHttpRequest (XHR)**.

We'll illustrate with a mini-version of the [tutorial](http://localhost:3000/docs/ts/latest/guide/tutorial.html)'s "Tour of Heroes" (ToH) application. This one gets some heroes from the server, displays them in a list, lets us add new heroes, and save them to the server.

It works like this.

It's implemented with two components — a parent `TohComponent` shell and the `HeroListComponent` child. We've seen these kinds of component in many other documentation samples. Let's see how they change to support communication with a server.

> We're overdoing the "separation of concerns" by creating two components for a tiny demo. We're making a point about application structure that is easier to justify when the app grows.

Here is the `TohComponent` shell:

```typescript
    import {Component}         from 'angular2/core';
    import {HTTP_PROVIDERS}    from 'angular2/http';
    import {Hero}              from './hero';
    import {HeroListComponent} from './hero-list.component';
    import {HeroService}       from './hero.service';
    @Component({
      selector: 'my-toh',
      template: `
      <h1>Tour of Heroes</h1>
      <hero-list></hero-list>
      `,
      directives:[HeroListComponent],
      providers: [
        HTTP_PROVIDERS,
        HeroService,
      ]
    })
export class TohComponent { }
```

As usual, we import the symbols we need. The newcomer is `HTTP_Providers`, an array of service providers from the Angular HTTP library. We'll be using that library to access the server. We also import a `HeroService` that we'll look at shortly.

The component specifies both the `HTTP_Providers` and the `HeroService` in the metadata providers array, making them available to the child components of this "Tour of Heroes" application.

> Learn about providers in the [Dependency Injection](http://localhost:3000/docs/ts/latest/guide/dependency-injection.html) chapter.

This sample only has one child, the `HeroListComponent` shown here in full:

```typescript
    import {Component, OnInit} from 'angular2/core';
    import {Hero}              from './hero';
    import {HeroService}       from './hero.service';
    @Component({
      selector: 'hero-list',
      template: `
      <h3>Heroes:</h3>
      <ul>
        <li *ngFor="#hero of heroes">
          {{ hero.name }}
        </li>
      </ul>
      New Hero:
      <input #newHero />
      <button (click)="addHero(newHero.value); newHero.value=''">
        Add Hero
      </button>
      `,
    })
    export class HeroListComponent implements OnInit {
      constructor (private _heroService: HeroService) {}
      heroes:Hero[];
      ngOnInit() {
        this._heroService.getHeroes()
                         .subscribe(
                           heroes => this.heroes = heroes,
                           error => alert(`Server error. Try again later`));
      }
      addHero (name: string) {
        if (!name) {return;}
        this._heroService.addHero(name)
                         .subscribe(
                           hero  => this.heroes.push(hero),
                           error => alert(error));
      }
    }
```

The component template displays a list of heroes with the `NgFor` repeater directive.

Beneath the heroes is an input box and an Add Hero button where we can enter the names of new heroes and add them to the database. We use a [local template variable](http://localhost:3000/docs/ts/latest/guide/template-syntax.html#local-vars), `newHero`, to access the value of the input box in the `(click)` event binding. When the user clicks the button, we pass that value to the component's `addHero` method and then clear it to make ready for a new hero name.

### The HeroListComponent class

We [inject](http://localhost:3000/docs/ts/latest/guide/dependency-injection.html) the `HeroService` into the constructor. That's the instance of the `HeroService` that we provided in the parent shell `TohComponent`.

Notice that the component **does not talk to the server directly!**.The component doesn't know or care how we get the data. Those details it delegates to the `heroService` class (which we'll get to in a moment). This is a golden rule: always delegate data access to a supporting service class.

Although the component should request heroes immediately, we do **not** call the service `get` method in the component's constructor. We call it inside the `ngOnInit` [lifecycle hook](http://localhost:3000/docs/ts/latest/guide/lifecycle-hooks.html) instead and count on Angular to call `ngOnInit` when it instantiates this component. 

> This is a "best practice". Components are easier to test and debug when their constructors are simple and all real work (especially calling a remote server) is handled in a separate method.

Now that the component is square away, we can turn to development of the backend data source and the client-side HeroService that talks to it.

### Fetching data

In many of our previous samples we faked the interaction with the server by returning mock heroes in a service like this one:

```typescript
import {Hero} from './hero';
import {HEROES} from './mock-heroes';
import {Injectable} from 'angular2/core';

@Injectable()
export class HeroService {
  getHeroes() {
    return Promise.resolve(HEROES);
  }
}
```

In this chapter, we get the heroes from the server using Angular's own HTTP Client service. Here's the new `HeroService`: 

```typescript
import {Injectable} from 'angular2/core';
import {Http}       from 'angular2/http';
import {Hero}       from './hero';
import {Observable} from 'rxjs/Observable';

@Injectable()
export class HeroService {
  constructor (private http: Http) {}

  private _heroesUrl = 'app/heroes.json';

  getHeroes () {
    return this.http.get(this._heroesUrl)
                    .map(res => <Hero[]> res.json().data)
                    .catch(this.logAndPassOn);
  }

  private logAndPassOn (error: Error) {
    // in a real world app, we may send the server to some remote logging infrastructure
    // instead of just logging it to the console
    console.error(error);
    return Observable.throw(error);
  }
}
```

We begin by importing Angular's `Http` client service and [inject it](http://localhost:3000/docs/ts/latest/guide/dependency-injection.html) into the `HeroService` constructor.

`Http` is not part of the Angular core. It's an optional service in its own `angular2/http` library. Moreover, this library isn't even part of the main Angular script file. It's in its own script file (included in the Angular npm bundle) which we must load in `index.html`.

```html
<script src="node_modules/angular2/bundles/http.dev.js"></script>
```

Look closely at how we call `http.get`

```typescript
return this.http.get(this._heroesUrl)
                .map(res => <Hero[]> res.json().data)
                .catch(this.logAndPassOn);
```

We pass the resource URL to `get` and it calls the server which returns data from the `heroes.json` file. 

The return value may surprise us. Many of us would expect a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise). We'd expect to chain a call to `then()` and extract the heroes. Instead we're calling a `map()` method. Clearly this is not a promise.

### RxJS Observables

The `http.get` method returns an Observable from the [RxJS library](https://github.com/ReactiveX/RxJS).

> We cover the rudiments of RxJS in the [Observables](http://localhost:3000/docs/ts/latest/guide/observables.html) chapter. 

RxJS is a 3rd party library endorsed by Angular. All of our documenations samples have installed the RxJS npm package and loaded the script in `index.html` because observables are used widely in Angular applications.

```html
<script src="node_modules/rxjs/bundles/Rx.js"></script>
```

We certainly need it now when working with the HTTP client. And we must take a critical extra step to make RxJS observables usable.

### Enable RxJS Operators

The RxJS library is quite large. Size matters when we build a production application and deploy it to mobile devices. We should include only those features that we actually need.

Accordingly, Angular exposes a stripped down version of `Observable` in the rxjs/Observable module, a version that lacks almost all operators including the ones we'd like to use here such as the `map` method we called above in `getHeroes`.

It's up to us to add the operators we need. We could add each operator, one-by-one, until we had a custom Observable implementation tuned precisely to our requirements.

That would be a distraction today. We're learning HTTP, not counting bytes. So we'll make it easy on ourselves and enrich Observable with the full set of operators. It only takes one `import` statement. It's best to add that statement early when we're bootstrapping the application. :

```typescript
// Add all operators to Observable
import 'rxjs/Rx';
```

### Map the response object

Let's come back to the `HeroService` and look at the `http.get` call again to see why we needed `map()`

```typescript
return this.http.get(this._heroesUrl)
                .map(res => <Hero[]> res.json().data)
                .catch(this.logAndPassOn);
```

The `response` object does not hold our data in a form we can use directly. It takes an additional step — calling `response.json()` — to transform the bytes from the server into a JSON object.

> This is not Angular's own design. The Angular HTTP client follows the ES2015 specification for the [response object](https://fetch.spec.whatwg.org/#response-class) returned by the `Fetch` function. That spec defines a `json()` method that parses the response body into a JavaScript object.

> We must also know the shape of the data returned by the server API. We shouldn't expect `json()` to return the heroes array directly. The server we're calling always wraps JSON results in an object with a `data` property. We have to unwrap it to get the heroes. This is conventional web api behavior, driven by security concerns.

### Do not return the response object

Our `getHeroes()` could have returned returned the `Observable<Response>`.

Bad idea! The point of a data service is to hide the server interaction details from consumers. The component that calls the `HeroService` wants heroes. It has no interest in what we do to get them. It doesn't care where they come from. And it certainly doesn't want to deal with a response object.


### Always handle errors

The eagle-eyed reader may have spotted that we used the `catch` operator in conjunction with the `logAndPassOn` method that we defined in our service. We haven't discussed so far how that actually works. Generally speaking, whenever we deal with I/O we have to account for the cases where something goes wrong. It may just be an unreachable server or something more subtile.

We could just ignore any errors in our `HeroService` and rely on the component to handle such cases. But it's often better to handle errors on both levels: Service and Component. In our case that may be as simple as logging the errors to the console at the service level and blowing up an alert box in the user's face at the component level.

The `catch` operator lets us do exactly that. This operator reacts to the error case of an Observable. It takes a function that can handle the error and then return a new Observable to continue with. Because we like to keep things simple here, we just defined a function `logAndPassOn` that calls `console.error(error)` and returns a new Observable that re-emits the error with `Observable.throw(error)`.

```typescript
getHeroes () {
    return this.http.get(this._heroesUrl)
                    .map(res => <Hero[]> res.json().data)
                    .catch(this.logAndPassOn);
  }

  private logAndPassOn (error: Error) {
    // in a real world app, we may send the server to some remote logging infrastructure
    // instead of just logging it to the console
    console.error(error);
    return Observable.throw(error);
  }
```

Back in the `HeroListComponent` where we call `heroService.get`, we pass a second parameter to the `subscribe` function to handle the error case at this level too.

```typescript
    ngOnInit() {
      this._heroService.getHeroes()
                       .subscribe(
                         heroes => this.heroes = heroes,
                         error => alert(`Server error. Try again later`));
    }
```

### Sending data to the server

So far we've seen how to retrieve data from a remote location using Angular's built-in `Http` service. Let's add the ability to create new heroes and save them in the backend.

We'll create an easy method for the `HeroListComponent` to call, an `addHero` method that takes just the name of a new hero and returns an observable holding the newly-saved hero:

```typescript
addHero (name: string) : Observable<Hero>
```

To implement it, we need to know some details about the server's api for creating heroes.

[Our data server](http://localhost:3000/docs/ts/latest/guide/server-communication.html#server) follows typical REST guidelines. It expects a [POST](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.5) request at the same endpoint where we `GET` heroes. It expects the new hero data to arrive in the body of the request, structured like a `Hero` entity but without the `id` property. The body of the request should look like this:

```typescript
{ "name": "Windstorm" }
```

The server will generate the `id` and return the entire `JSON` representation of the new hero including its generated id for our convenience.

Now that we know how the API works, we implement `addHero` like this:

```typescript
addHero (name: string) : Observable<Hero>  {
  return this.http.post(this._heroesUrl, JSON.stringify({ name }))
                  .map(res =>  <Hero> res.json().data)
                  .catch(this.logAndPassOn)
}
```

Notice that the second body parameter of the `post` method requires a JSON **string** so we have to `JSON.stringify` the hero content first.

> We may be able to skip stringify in the near future.

Back in the `HeroListComponent`, we see that its `addHero` method subscribes to the observable returned by the service's `addHero` method. When the data arrive it pushes the new hero object into its `heroes` array for presentation to the user.

```typescript
addHero (name: string) {
  if (!name) {return;}
  this._heroService.addHero(name)
                   .subscribe(
                     hero  => this.heroes.push(hero),
                     error => alert(error));

}
```

## Communication with JSONP

We just learned how to make `XMLHttpRequests` using Angulars built-in `Http` service. This is the most common approach for server Communication. It doesn't work in all scenarios though.

For security reasons web browser do not permit to make `XHR` calls if the origin of the remote server is different from the one the web page runs in. The origin is defined as the combination of URI scheme, hostname and port number. The policy that prevents such `XHR` requests is called [Same-origin Policy](https://en.wikipedia.org/wiki/Same-origin_policy) accordingly.

> That's not entirely true. Modern browsers do allow `XHR` requests against foreign origins if the server sends the appropriate [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) headers. In such cases there's nothing specific to do for the client unless we want our `XHR` request to include credentials (e.g Cookies) which we then have to explicitly enable for the request.

But let's not go too deep into the rabbit hole of `JSONP`. If you like to learn how this technique works under the cover, you may like to read up on this [answer](http://stackoverflow.com/questions/2067472/what-is-jsonp-all-about/2067584#2067584) on StackOverflow. For now, let's focus on how we can use `JSONP` in Angular.

### Let's fetch some data from wikipedia

Wikipedia offers a `JSONP` search api. Let's build a simple search that shows suggestions from wikipedia as we type in a text box.

Angular provides us with a `Jsonp` services which has the same API surface as the `Http` service with the only difference that it restricts us to use `GET` requests only. This is because the nature of `JSONP` does not allow any other kind of requests. In order to use the Jsonp service we have to specify the JSONP_`PROVIDERS`.

Again, we'll make sure to do the server communication in a dedicated service that we call `WikipediaService`.

```typescript
// app/wiki/wikipedia.service.ts

    import {Injectable} from 'angular2/core';
    import {Jsonp, URLSearchParams} from 'angular2/http';
    @Injectable()
    export class WikipediaService {
      constructor(private jsonp: Jsonp) {}
      search (term: string) {
        var params = new URLSearchParams();
        params.set('search', term);
        params.set('action', 'opensearch');
        params.set('format', 'json');
        let wikiUrl = 'http://en.wikipedia.org/w/api.php?callback=JSONP_CALLBACK';
        // TODO: Error handling
        return this.jsonp
                   .get(wikiUrl, { search: params })
                   .map(request => request.json()[1]);
      }
    }
```

We use the `URLSearchParams` helper to define a `params` object with the key/value pairs that define the wikipedia query. The keys are `search`, `action`, and `format`. The value of the `search` key is the user-supplied search term that we'll lookup in wikipedia.

We call `Jsonp` with two arguments: the `wikiUrl` and an options object with a `search` property whose value is the `params` object. `Jsonp` flattens the `params` object into a query string such as

```url
&search=foo&action=opensearch&format=json`
```

and appends it to the `wikiUrl`. Notice that the `wikiUrl` contains `callback=JSONP_CALLBACK`. The nature of JSONP requires that we pass a unique function name to the server so that the server can pick up that name in the response. Many JSONP APIs pass this function name through an URL parameter called they call `callback`. But that's more common sense than a strict rule. Since Angular doesn't assume a fixed name for that parameter it requires us to put it in the URL and asign the placeholder `JSONP_CALLBACK` to it. Angular will make sure to replace the placeholder with a unique function name for each request for us.

Now that we have the service ready to query the Wikipedia API, let's look at the actual component that should accept the user input and shows the search results.

```typescript
//app/wiki/wiki.component.ts

    import {Component}        from 'angular2/core';
    import {JSONP_PROVIDERS}  from 'angular2/http';
    import {Observable}       from 'rxjs/Observable';
    import {WikipediaService} from './wikipedia.service';
    @Component({
      selector: 'my-wiki',
      template: `
        <h1>Wikipedia Demo</h1>
        <p><i>Fetches after each keystroke</i></p>
        <input #term (keyup)="search(term.value)"/>
        <ul>
          <li *ngFor="#item of items | async">{{item}}</li>
        </ul>
      `,
      providers:[JSONP_PROVIDERS, WikipediaService]
    })
    export class WikiComponent {
      constructor (private _wikipediaService: WikipediaService) {}
      items: Observable<string>;
      search (term: string) {
        this.items = this._wikipediaService.search(term);
      }
    }
```

There shouldn't be much of a surprise here. Our component defines an `<input>` and calls a `search(term)` method for each `keyup` event. The `search(term)` method delegates to our `WikipediaService` which returns an `Observable<Array<string>>` to us. Instead of subscribing to it manually we use the [async pipe](http://localhost:3000/docs/ts/latest/guide/pipes.html#async-pipe) in the `ngFor` to let the view subscribe to the Observable directly.

> As a rule of thumb we can use the [async pipe](http://localhost:3000/docs/ts/latest/guide/pipes.html#async-pipe) whenever we don't need to interact with the unwrapped payload from the `Observable/Promise` other than from the view directly. In our previous example we couldn't use it since we needed to keep a reference to the bare array of heros so that we can push new objects into the array as we create new heros.

There are a bunch of things in our wikipedia demo that we could do better. This is a perfect opportunity to show off some nifty `Observable` tricks that can make server communication much simpler and more fun.

## Taking advantage of Observables

If you ever wrote a search-as-you-type control yourself before, you are probably aware of some typical corner cases that arise with this task.

### 1. Don't hit the search endpoint on every key stroke

Treat the search endpoint as if you pay for it on a per-request basis. No matter if it's your own hardware or not. We shouldn't be hammering the search enpoint more often than needed. What we want is to hit the search endpoint as soon as the user stops typing instead of after every keystroke.

Here's how it **should** work — and **will** work — when we're done refactoring:

### 2. Don't hit the search endpoint for the same term again

Consider you type **foo**, stop, type another **o**, hit return and stop back at **foo**. That should be just one request with the term **foo** and not two even if we technically stopped twice after we had foo in the search box.


### 3. Cope with out-of-order responses

When we have multiple requests in-flight at the same time we must account for cases where they come back in unexpected order. Consider we first typed *computer*, stop, a request goes out, we type *car*, stop, a request goes out but then the request that carries the results for computer comes back after the request that carries the results for *car*. If we don't deal with such cases properly we can get a buggy application that shows results for computer even if the search box reads *car*.

Now that we identified the problems that need to be solved, let's make a couple of trivial changes to our code to fix them in a functional reactive way. Here is the entire example with all changes. 

There are no changes for our `WikipediaService` so we can skip that one. We'll go over each change to briefly describe what it does.

```typescript
//app/wiki/wiki-form.component.ts

    import {Component, OnInit} from 'angular2/core';
    import {Control} from 'angular2/common';
    import {Observable} from 'rxjs/Observable';
    import {JSONP_PROVIDERS, Jsonp, URLSearchParams} from 'angular2/http';
    import {WikipediaService} from './wikipedia.service';
    @Component({
      selector: 'my-wiki-form',
      template: `
        <h1>Wikipedia Form Demo</h1>
        <p><i>Fetches when typing stops</i></p>
        <input [ngFormControl]="inputs"/>
        <ul>
          <li *ngFor="#item of items | async">{{item}}</li>
        </ul>
      `,
      providers:[JSONP_PROVIDERS, WikipediaService]
    })
    export class WikiFormComponent implements OnInit {
      constructor (private _wikipediaService: WikipediaService) {}
      items: Observable<string>;
      inputs = new Control();
      ngOnInit() {
        this.items = this.inputs.valueChanges
          .debounceTime(300)
          .distinctUntilChanged()
          .switchMap((term:string) => this._wikipediaService.search(term));
      }
    }
```

The first thing we need to do to unveil the full magic of a observable-based solution is to get an `Observable<string>` for our `<input>` control. The best way to do that is to change `<input #term (keyup)="search(term.value)"/>` into `<input [ng-form-control]="inputs"/>` and to create an `inputs` `Control` accordingly.

```typescript
inputs = new Control();
```

We now have an `Observable<string>` at `this.inputs.valueChanges`. We can simply use the `debounceTime(ms)` and `distinctUntilChanged()` operators to fix the first two problems. We basically get a new `Observable<string>` that emits new values exactly the way we want them to be emitted.

```typescript
this.items = this.inputs.valueChanges
  .debounceTime(300)
  .distinctUntilChanged()
```

With the previous change we tamed the input but we still need to deal with the out-of-order cases. At this point we have an `Observable<string>` and a `search(term)` method on the `WikipediaService` that returns an `Observable<Array<string>>`. What we want is an `Observable<Array<string>>` that carries the results of the last term that was emitted from the `Observable<string>`.

If we would just map our current `Observable<string>` like `.map(term => wikipediaService.search(term))` we would transform it into an `Observable<Observable<Array<string>>` which isn't quite what we want. Enter [switchMap](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/core/operators/flatmaplatest.md) to the rescue. Basically `switchMap` flattens from an `Observable<Observable<T>` into an `Observable<T>` by emitting values only from the most recent `Observable<T>` that was produced from the outer Observable.

This may sound a lot like black magic for people unfamiliar with Observables but as soon as the coin sinks in it's starting to make a whole world of difficult programming tasks appear much simpler.

## Appendix: Tour of Heroes in-memory server

If we only cared to retrieve data, we could tell Angular to get the heroes from a `heroes.json` file like this one:

```typescript
// app/heroes.json

{
  "data": [
    { "id": "1", "name": "Windstorm" },
    { "id": "2", "name": "Bombasto" },
    { "id": "3", "name": "Magneta" },
    { "id": "4", "name": "Tornado" }
  ]
}
```

> We wrap the heroes array in an object with a `data` property for the same reason that a data server does: to mitigate the [security risk](http://stackoverflow.com/questions/3503102/what-are-top-level-json-arrays-and-why-are-they-a-security-risk) posed by top-level JSON arrays.

Our sample saves data. We can't save to a JSON file. We'll need a server ... or a server simulation. This sample uses an in-memory web api simulator that we first installed with `npm`:

```shell
npm install a2-in-memory-web-api --save
```

and then loaded it in our html below the angular script:

```html
<!-- index.html -->

<script src="node_modules/a2-in-memory-web-api/web-api.js"></script>
```

The in-memory web api gets its data from a class with a `createDb()` method that returns a "database" object whose keys are collection names ("heroes") and whose values are arrays of objects in those collections.

Here's the class we created for this sample by copy-and-pasting the JSON data:

```typescript
// app/hero-data.ts

export class HeroData {
  createDb() {
    let heroes = [
      { "id": "1", "name": "Windstorm" },
      { "id": "2", "name": "Bombasto" },
      { "id": "3", "name": "Magneta" },
      { "id": "4", "name": "Tornado" }
    ];
    return {heroes};
  }
}
```

Finally, we tell Angular to direct its http requests to the in-memory web api service rather than to a remote server.

This redirection is easy in Angular because `http` delegates the client/server communication tasks to a helper service called the `XHRBackend`.

To enable our server simulation, we replace the `XHRBackend` service with the in-memory web api backend using standard Angular provider registration in the `TohComponent`. We supply the hero data to the in-memory web api in the same way at the same time.

Here are the pertinent details, excerpted from `TohComponent`, starting with the imports:

```typescript
// toh.component.ts (web api imports)

import {provide}           from 'angular2/core';
import {XHRBackend}        from 'angular2/http';

// in-memory web api imports
import {InMemoryBackendService,
        SEED_DATA}         from 'a2-in-memory-web-api/core';
import {HeroData}          from '../hero-data';
```

Then add these two provider definitions to the component's `providers` array in metadata:

```typescript
toh.component.ts (web api providers)

// in-memory web api providers
provide(XHRBackend, { useClass: InMemoryBackendService }), // in-mem server
provide(SEED_DATA,  { useClass: HeroData }) // in-mem server data
```

See the full source code in the [live example](http://localhost:3000/resources/live-examples/server-communication/ts/plnkr.html).
