import 'package:demo/core/locator/locator.dart';
import 'package:demo/features/form/data/model/form_field.dart';
import 'package:demo/features/form/domain/repository/form_repository.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late final GlobalKey<FormState> _formKey;
  late final FormModel form;

  int currentStep = 0;
  late int totalStep;

  bool get isLastStep => currentStep == totalStep - 1;

  final _userInput = <String, dynamic>{};

  FormInputModel? findInputByKey(String key) {
    for (final step in form.steps) {
      try {
        return step.inputs.firstWhere((element) => element.key == key);
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _loadForm();
  }

  void _loadForm() {
    form = locator<FormRepository>().getFormFields();
    totalStep = form.steps.length;
    _loadDefaultValues();
  }

  void _loadDefaultValues() {
    for (final step in form.steps) {
      for (final input in step.inputs) {
        _userInput[input.key] = switch (input) {
          TextFormInputModel() => input.defaultValue,
          DropdownFormInputModel() => null,
          ToggleFormInputModel() => input.defaultValue,
        };
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentForm = form.steps[currentStep];
    return Scaffold(
      appBar: AppBar(title: Text(form.title)),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Step ${currentStep + 1}.  ${currentForm.title}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  currentForm.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (isLastStep)
                  for (final userInput in _userInput.entries)
                    ListTile(
                      title: Text(
                        findInputByKey(userInput.key)?.label ?? userInput.key,
                      ),
                      trailing: Text("${userInput.value}"),
                    )
                else
                  for (final input in currentForm.inputs)
                    switch (input) {
                      TextFormInputModel() => TextFormField(
                        key: ValueKey(input.key),
                        decoration: InputDecoration(labelText: input.label),
                        initialValue:
                            _userInput[input.key] ?? input.defaultValue,
                        validator: input.validator,
                        keyboardType: input.validation?.numberOnly ?? false
                            ? TextInputType.number
                            : TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          _userInput[input.key] = value;
                        },
                      ),
                      DropdownFormInputModel() =>
                        DropdownButtonFormField<String>(
                          key: ValueKey(input.key),
                          validator: input.validator,
                          value: _userInput[input.key],
                          hint: Text(input.label),
                          items: [
                            for (final item in input.options)
                              DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ),
                          ],
                          onChanged: (value) {
                            _userInput[input.key] = value;
                          },
                        ),
                      ToggleFormInputModel() => SwitchListTile.adaptive(
                        key: ValueKey(input.key),
                        title: Text(input.label),
                        value:
                            _userInput[input.key] ??
                            input.defaultValue ??
                            false,
                        onChanged: (value) {
                          _userInput[input.key] = value;
                          setState(() {});
                        },
                      ),
                    },

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      if (isLastStep) {
                        _loadDefaultValues();
                        currentStep = 0;
                        setState(() {});
                      } else {
                        currentStep++;
                        setState(() {});
                      }
                    },
                    child: isLastStep ? Text('Restart') : Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
