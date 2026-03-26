# Zren

A lightweight Flutter framework for type-safe form handling, async state management, and MVVM patterns.

## Features

- **Type-Safe Forms**: Compile-time type checking with `FormFieldKey<T>`
- **Async States**: Reactive async state management with `AsyncValue`
- **MVVM Pattern**: Simple controller-based architecture
- **Result Type**: Functional error handling

## Installation

```yaml
dependencies:
  zren: ^0.1.0
```

## Forms

Type-safe form handling with field keys.

```dart
import 'package:zren/zren.dart';

// Define fields
class LoginFields {
  static const email = FormFieldKey<String>('email');
  static const password = FormFieldKey<String>('password');
}

// Build form
class LoginForm extends StatelessWidget {
  final controller = FormController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormFieldBuilder<String>(
          formController: controller,
          fieldKey: LoginFields.email,
          initialValue: '',
          validators: [Validators.required(), Validators.email()],
          builder: (state, fieldController) => TextField(
            onChanged: fieldController.setValue,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: state.error,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.validate()) {
              final email = controller.getValue(LoginFields.email);
              print('Email: $email');
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
```

## AsyncValue

Reactive async state management.

```dart
final userValue = AsyncValue<User>();

// In UI
ValueListenableBuilder(
  valueListenable: userValue,
  builder: (context, _, __) => userValue.when(
    initial: () => Text('Tap to load'),
    loading: () => CircularProgressIndicator(),
    success: (user) => Text('Hello, ${user.name}'),
    failure: (error, _) => Text('Error: $error'),
  ),
);

// Update state
userValue.loading();
userValue.success(User('John'));
userValue.failure('Network error');
```

## MVVM

Controller-based state management.

```dart
class CounterController extends ZrenController<CounterState, CounterEffect> {
  CounterController() : super(CounterState(0));

  void increment() {
    emit(CounterState(state.count + 1));
  }
}

// In UI
ZrenProvider<CounterController>(
  create: () => CounterController(),
  child: ZrenBuilder<CounterController, CounterState, CounterEffect>(
    builder: (context, state, controller) {
      return Text('Count: ${state.count}');
    },
  ),
)
```

## Result Type

Functional error handling.

```dart
ZrenResult<int> divide(int a, int b) {
  if (b == 0) return ZrenResult.failure('Cannot divide by zero');
  return ZrenResult.success(a ~/ b);
}

final result = divide(10, 2);
result.when(
  success: (value) => print(value),
  failure: (error, stackTrace) => print(error),
);
```
