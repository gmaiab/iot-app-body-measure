class PatientsData {

  static PatientsData _instance;
  factory PatientsData() => _instance ??= new PatientsData._();
  PatientsData._();

  Map completeHistory = {
    '012': {
      'name': 'Maria Silva',
      'history': [
        {
          'date': '02/11/2019',
          'value': 21,
          'rating': 5,
        },
        {
          'date': '12/10/2018',
          'value': 23,
          'rating': 5,
        },
        {
          'date': '16/02/2018',
          'value': 23,
          'rating': 5,
        },
      ]
    },
    '123': {
      'name': 'João Pereira',
      'history': [
        {
          'date': '02/10/2019',
          'value': 17,
          'rating': 5,
        },
        {
          'date': '21/12/2018',
          'value': 14,
          'rating': 5,
        },
        {
          'date': '16/04/2018',
          'value': 13,
          'rating': 5,
        },
        {
          'date': '15/09/2017',
          'value': 11,
          'rating': 5,
        },
        {
          'date': '31/01/2017',
          'value': 9,
          'rating': 5,
        },
        {
          'date': '02/10/2016',
          'value': 7,
          'rating': 5,
        },
        {
          'date': '21/12/2015',
          'value': 9,
          'rating': 5,
        },
        {
          'date': '16/04/2014',
          'value': 10,
          'rating': 5,
        },
        {
          'date': '15/09/2013',
          'value': 11,
          'rating': 5,
        },
        {
          'date': '31/01/2012',
          'value': 9,
          'rating': 5,
        },
        {
          'date': '02/10/2011',
          'value': 12,
          'rating': 5,
        },
        {
          'date': '21/12/2010',
          'value': 14,
          'rating': 5,
        },
      ]
    },
    '000': {
      'name': 'Francisco Neto',
      'history': [
        {
          'date': '12/07/2020',
          'value': 16,
          'rating': 5,
        },
      ]
    },
  };

  void addMeasurement(String cpf, int measure){
    var _currentHistory = completeHistory[cpf]['history'];
    DateTime now = new DateTime.now();
    var _newMeasure =
    {
      'date': '${now.day}/${now.month}/${now.year}',
      'value': measure,
      'rating': 5,
    };
    _currentHistory.insert(0, _newMeasure);
    completeHistory[cpf]['history'] = _currentHistory;
  }

  bool isNewPatient(String cpf){
    if (!completeHistory.containsKey(cpf)){
      return true;
    } else {
      return false;
    }
  }

  void registerNewPatient(String cpf, String name){
    var _newPatient =
    {
      'name': name,
      'history': [],
    };
    completeHistory[cpf] = _newPatient;
  }
}