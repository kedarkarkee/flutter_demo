import 'package:demo/features/form/data/model/form_field.dart';
import 'package:demo/features/form/data/sources/form_source.dart';

class FormRepository {
  final FormSource _source;

  FormRepository(this._source);

  FormModel getFormFields() {
    final data = _source.getFormData();
    return FormModel.fromJson(data['form'] as Map<String, dynamic>);
  }
}
