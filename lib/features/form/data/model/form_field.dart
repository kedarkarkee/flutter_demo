enum FormType { text, dropdown, toggle }

class FormModel {
  final String title;
  final List<FormStepModel> steps;

  const FormModel({required this.title, required this.steps});

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      title: json['title'] as String,
      steps: (json['steps'] as List)
          .map((e) => FormStepModel.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'FormModel(title: $title, steps: $steps)';
  }
}

class FormStepModel {
  final String title;
  final String description;
  final List<FormInputModel> inputs;

  const FormStepModel({
    required this.title,
    required this.description,
    required this.inputs,
  });

  factory FormStepModel.fromJson(Map<String, dynamic> json) {
    return FormStepModel(
      title: json['title'] as String,
      description: json['description'] as String,
      inputs: (json['inputs'] as List)
          .map((e) => FormInputModel.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'FormFieldModel(title: $title, description: $description, inputs: $inputs)';
  }
}

sealed class FormInputModel {
  final String key;
  final FormType type;
  final String label;
  final bool isRequired;

  const FormInputModel({
    required this.key,
    required this.type,
    required this.label,
    required this.isRequired,
  });

  String? validator(String? text) {
    if (isRequired && (text == null || text.isEmpty)) {
      return '$label is required';
    }
    return null;
  }

  factory FormInputModel.fromJson(Map<String, dynamic> json) {
    final type = FormType.values.byName(json['type'] as String);
    switch (type) {
      case FormType.text:
        return TextFormInputModel(
          key: json['key'] as String,
          label: json['label'] as String,
          isRequired: json['required'] as bool,
          defaultValue: json['default']?.toString(),
          validation: json['validation'] != null
              ? FormValidationModel.fromJson(
                  json['validation'] as Map<String, dynamic>,
                )
              : null,
        );
      case FormType.dropdown:
        return DropdownFormInputModel(
          key: json['key'] as String,
          label: json['label'] as String,
          isRequired: json['required'] as bool,
          options: (json['options'] as List).map((e) => e as String).toList(),
        );
      case FormType.toggle:
        return ToggleFormInputModel(
          key: json['key'] as String,
          label: json['label'] as String,
          isRequired: json['required'] as bool,
          defaultValue: json['default'] as bool? ?? false,
        );
    }
  }
}

class TextFormInputModel extends FormInputModel {
  final String? defaultValue;
  final FormValidationModel? validation;

  const TextFormInputModel({
    required super.key,
    required super.label,
    required super.isRequired,
    this.defaultValue,
    this.validation,
  }) : super(type: FormType.text);

  @override
  String? validator(String? text) {
    final error = super.validator(text);
    if (error != null) return error;
    if (validation case final v?) {
      if (v.numberOnly && text != null && !RegExp(r'^\d+$').hasMatch(text)) {
        return '$label must be a number';
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'TextFormInputModel(key: $key, label: $label, isRequired: $isRequired, defaultValue: $defaultValue, validation: $validation)';
  }
}

class DropdownFormInputModel extends FormInputModel {
  final List<String> options;

  const DropdownFormInputModel({
    required super.key,
    required super.label,
    required super.isRequired,
    required this.options,
  }) : super(type: FormType.dropdown);

  @override
  String toString() {
    return 'DropdownFormInputModel(key: $key, label: $label, isRequired: $isRequired, options: $options)';
  }
}

class ToggleFormInputModel extends FormInputModel {
  final bool defaultValue;

  const ToggleFormInputModel({
    required super.key,
    required super.label,
    required super.isRequired,
    required this.defaultValue,
  }) : super(type: FormType.dropdown);

  @override
  String toString() {
    return 'ToggleFormInputModel(key: $key, label: $label, isRequired: $isRequired, defaultValue: $defaultValue)';
  }
}

class FormValidationModel {
  final bool numberOnly;

  const FormValidationModel({required this.numberOnly});

  factory FormValidationModel.fromJson(Map<String, dynamic> json) {
    return FormValidationModel(numberOnly: json['numberOnly'] as bool);
  }
}
