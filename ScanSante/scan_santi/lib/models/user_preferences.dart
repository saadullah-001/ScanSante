class UserPreferences {
  String selectedCondition;

  // Default value is the prompt text
  UserPreferences({this.selectedCondition = 'Health Conditions'});

  // Helpers to make logic easier later
  bool get isDiabetic => selectedCondition == 'Diabetes';
  bool get isHypertensive =>
      selectedCondition == 'Hypertension'; // High Blood Pressure
  bool get isVegan => selectedCondition == 'Vegan';
  bool get hasNutAllergy => selectedCondition == 'Nut Allergy';
  bool get isGlutenFree => selectedCondition == 'Gluten Intolerance';
  bool get isLactoseIntolerant => selectedCondition == 'Lactose Intolerance';
  bool get isNormal => selectedCondition == 'Normal';
}
