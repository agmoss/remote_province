# RemoteState

> `import 'package:remote_province/remote_province.dart';`

> A province is a political division within a country, typically used in countries that are federal or have a federal system of government. A state, on the other hand, is a political entity that is typically sovereign and has defined geographic boundaries.

[![pub package](https://img.shields.io/pub/v/remote_province.svg)](https://pub.dev/packages/remote_province)

Tools for mapping data from remote sources in Dart, similar to Elm's RemoteData: https://elmprogramming.com/remote-data.html

## Slaying a UI Antipattern with Flutter.

Library inspired by a blog post by [Kris Jenkins](https://twitter.com/krisajenkins) about [How Elm slays a UI antipattern](https://bit.ly/3j4HFzy).

## What problem does this package solve?

You are making an API request, and you want to display or do different things based on the status of the request.

## Why RemoteState, not RemoteData?

I gained secondary inspiration from a talk by [Jed Watson](https://twitter.com/jedwatson), [A Treatise on State](https://www.youtube.com/watch?v=tBz3UmZG_bk). As much as possible, I try to categorize state correctly in my applications.

## The RemoteState approach

Instead of using a complex object we use a single data type to express all possible request states. This approach makes it impossible to create invalid states.

## Usage

A common use case for RemoteState would be mapping it into a UI transition or component state. Here is an example that uses [StateNotifier](https://pub.dev/documentation/state_notifier/latest/state_notifier/StateNotifier-class.html), found in [examples/counter_state_notifier](https://github.com/agmoss/remote_province/blob/master/examples/counter_state_notifier)

### [counter/notifier/counter.dart](https://github.com/agmoss/remote_province/blob/master/examples/counter_state_notifier/lib/counter/notifier/counter.dart)

```dart
import 'package:remote_province/remote_province.dart';

class CounterNotifier extends StateNotifier<RemoteState<int>> {
  var _counterClient = CounterClient();

  CounterNotifier() : super(RemoteState.initial()) {
    getCount();
  }

  getCount() async {
    state = RemoteState.loading();

    state = await RemoteState.guard(() => _counterClient.getCount());
  }

  increment() async {
    state = await RemoteState.guard(() => _counterClient.increment());
  }

  decrement() async {
    state = await RemoteState.guard(() => _counterClient.decrement());
  }
}

```

### [main.dart](https://github.com/agmoss/remote_province/blob/master/examples/counter_state_notifier/lib/main.dart)

```dart
import 'package:remote_province/remote_province.dart';

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StateNotifierProvider<CounterNotifier, RemoteState<int>>.value(
        value: CounterNotifier(),
        child: HomePage(),
      ),
    );
  }
}
```

### [home.dart](https://github.com/agmoss/remote_province/blob/master/examples/counter_state_notifier/lib/home.dart)

```dart
import 'package:remote_province/remote_province.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //2. Resolve counter notifier to update state
    var counterNotifier = Provider.of<CounterNotifier>(context);
    var counterState = Provider.of<RemoteState<int>>(context);

    var textStyle = Theme.of(context).textTheme.headline4;
    final fabPadding = EdgeInsets.symmetric(vertical: 5.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('RemoteState with StateNotifier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            //3. Render state changes
            counterState.when(
              initial: () => Text('Not loaded', style: textStyle),
              success: (value) => Text('$value', style: textStyle),
              loading: () => Text('Loading...', style: textStyle),
              error: (_) => Text('Error', style: textStyle),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: fabPadding,
            child: FloatingActionButton(
              heroTag: 'inc',
              child: Icon(Icons.add),
              //4. Perform increment action
              onPressed: () => counterNotifier.increment(),
            ),
          ),
          Padding(
            padding: fabPadding,
            child: FloatingActionButton(
              heroTag: 'dec',
              child: Icon(Icons.remove),
              //5. Perform decrement action
              onPressed: () => counterNotifier.decrement(),
            ),
          ),
        ],
      ),
    );
  }
}
```


### maybeWhen

```dart
import 'package:remote_province/remote_province.dart';
var result = remoteState.maybeWhen(
  initial: () => "It's initial",
  loading: () => "It's loading",
  // Don’t provide handlers for success and error.
  orElse: () => "It's either success or error", // Wildcard
);
```

## API

### RemoteState

`RemoteState<T>` is usedto annotate your request variables. It wraps all possible request states into one single union type. Use the parameters to specify.

- T: The success value type.

### RemoteState.initial

`RemoteState.initial` is an instance of RemoteState that signifies the request hasn't been made yet.

### RemoteState.loading

`RemoteState.loading` is an instance of RemoteState that signifies the request has been made, but it hasn't returned any data yet.

### RemoteState.success

`RemoteState.success` is an instance of RemoteState that signifies the request has completed successfully and the new data (of type T) is available.

### RemoteState.error

`RemoteState.error` is an instance of RemoteState that signifies the request has failed.

### RemoteState.guard

`RemoteState.guard` is a static function that converts a Future to RemoteState. It will emit RemoteState.error if the future fails or RemoteState.success if the future completes.

## Pattern matching high order functions

### When

The `when` method is a high order function that accepts a method for each state and matches the request state with the appropriate callback function. All callbacks are **required** and must not be null.

### MaybeWhen

The `maybeWhen` method is a high order function that accepts a method for each state and matches the request state with the appropriate callback function or a fallback callback for missing methods. Only `orElse` is required.

### Map

The `map` method is the equivalent of `when` without the destructuring.

### MaybeMap

The `maybeWhen` method is the equivalent of `when` without the destructuring.

## State Predicates

### isInitial

The `isInitial` predicate returns true if we haven't asked for data yet.

### isLoading

The `isLoading` predicate returns true if we're loading.

### isSuccess

The `isSuccess` predicate returns true if we've successfully loaded some data.

### isError

The `isError` predicate returns true if we've failed to load some data.

## Maintainers

- [Ryan Edge](https://github.com/agmoss)

## References

- [How to fix a bad user interface](https://www.scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack/)

- [Slaying a UI Antipattern with Web Components (and TypeScript)](https://bendyworks.com/blog/slaying-a-ui-antipattern-with-web-components-and-typescript)

- [How Elm Slays a UI Antipattern](https://bit.ly/3j4HFzy)

- [Slaying a UI Antipattern with Angular](https://medium.com/@joanllenas/slaying-a-ui-antipattern-with-angular-4c7536fafc54)

- [Slaying a UI Antipattern with Flow](https://medium.com/@gcanti/slaying-a-ui-antipattern-with-flow-5eed0cfb627b)

- [Slaying a UI Antipattern in React](https://medium.com/javascript-inside/slaying-a-ui-antipattern-in-react-64a3b98242c)

- [Slaying a UI Antipattern in Fantasyland](https://medium.com/javascript-inside/slaying-a-ui-antipattern-in-fantasyland-907cbc322d2a)

## Dev

### 1. **Fetching Dependencies**

```bash
dart pub get
```

### 2. **Running Tests**

```bash
dart test
```

### 3. **Code Generation (freezed, json_serializable, etc.)**

```bash
dart pub run build_runner build
```

For continuous rebuilding as you change the code:

```bash
dart pub run build_runner watch
```

### 4. **Code Analysis**

```bash
dart analyze
```

### 5. **Formatting Code**

```bash
dart format lib
```

### 6. **Running the Package/Application**

```bash
dart run
```

### 7. **Compiling the Package/Application**

```bash
dart compile exe <dart_file>
```

### 8. **Publishing the Package**

```bash
dart pub publish
```

### 9. **Release**

```bash
./scripts/prepare_release.sh
```
