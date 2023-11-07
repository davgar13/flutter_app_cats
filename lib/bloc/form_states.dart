class FormStates {}

class InitialState extends FormStates {}

class UpdateState extends FormStates {
  String succes = "n";
  UpdateState(this.succes);
}
