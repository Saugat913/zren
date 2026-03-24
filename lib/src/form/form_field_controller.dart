import 'package:flutter/foundation.dart';

import 'form_field_state.dart';

class FormFieldController<T> {
  ValueNotifier<FormFieldState<T>> state;
  FormFieldController(FormFieldState<T> state) : state = ValueNotifier(state);

  void setValue(T value) {
    state.value = state.value.copyWith(value: value);
  }

  void setError(String error) {
    state.value = state.value.copyWith(error: error);
  }

  void clearError() {
    state.value = state.value.copyWith(clearError: true);
  }

  void validate() {
    state.value = state.value.validate();
  }

  void onChanged(T value) {
    state.value = state.value.copyWith(value: value);
  }

  void onTouched() {
    state.value = state.value.copyWith(touched: true);
  }

  void dispose() {
    state.dispose();
  }
}
