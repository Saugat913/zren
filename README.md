# Zren

A modular, lightweight Flutter framework for modern state management, form handling, and result-oriented programming.

## Features

- **Async State Management**: Cleanly handle initial, loading, success, and failure states.
- **Form Handling**: Simple and type-safe form validation and state tracking.
- **MVVM Pattern**: Streamlined Model-View-ViewModel implementation using `ChangeNotifier` and `InheritedWidget`.
- **Result Type**: Robust error handling using a functional `Result` type.

## Getting Started

Add `zren` to your `pubspec.yaml` (once published or as a path dependency).

```yaml
dependencies:
  zren:
    path: ./zren
```

## Usage

### 1. Async State Management

`AsyncState` helps you model asynchronous data flow without boilerplate.

```dart
import 'package:zren/zren.dart';

AsyncState<String> state = const AsyncState.loading();

// Use in UI
state.when(
  initial: () => const Text('Initial'),
  loading: () => const CircularProgressIndicator(),
  success: (data) => Text('Data: $data'),
  failure: (error, {stackTrace}) => Text('Error: $error'),
);
```

### 2. Form Handling

Handle form fields with ease using `FormController` and `FormFieldBuilder`.

```dart
import 'package:zren/zren.dart';

final controller = FormController();

// In your build method:
FormFieldBuilder<String>(
  formController: controller,
  name: 'email',
  initialValue: '',
  builder: (state) => TextField(
    onChanged: (value) => controller.setValue('email', value),
    decoration: InputDecoration(
      errorText: state.error,
      labelText: 'Email',
    ),
  ),
);

// Validate
if (controller.validate()) {
  print('Form is valid: ${controller.getValue('email')}');
}
```

### 3. MVVM Pattern

`Zren` provides a simplified MVVM architecture.

```dart
import 'package:zren/zren.dart';

// Your Controller
class MyController extends ZrenController<MyState, MyEffect> {
  MyController() : super(MyInitialState());

  void load() {
    emit(MyLoadingState());
    // ... logic
    emit(MySuccessState(data));
    emitEffect(MyShowToastEffect());
  }
}

// In UI
ZrenProvider<MyController>(
  create: () => MyController(),
  child: ZrenConsumer<MyController, MyState, MyEffect>(
    listener: (context, effect) {
      if (effect is MyShowToastEffect) {
        // Show toast
      }
    },
    builder: (context, state, controller) {
      return state.when(
        initial: () => ElevatedButton(
          onPressed: controller.load,
          child: Text('Load'),
        ),
        // ...
      );
    },
  ),
);
```

### 4. Result Type

Avoid exceptions for expected errors.

```dart
import 'package:zren/result.dart';

Result<int> divide(int a, int b) {
  if (b == 0) return Result.failure('Division by zero');
  return Result.success(a ~/ b);
}

final res = divide(10, 2);
res.when(
  success: (val) => print('Result: $val'),
  failure: (err) => print('Error: $err'),
);
```

## Project Structure

This package follows the recommended Dart structure:
- `lib/src/`: Internal implementation.
- `lib/*.dart`: Public API entry points (e.g., `form.dart`, `async.dart`, `mvvm.dart`).
- `lib/zren.dart`: Unified entry point exporting all features.
