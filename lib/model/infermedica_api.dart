import 'dart:convert';

import 'package:http/http.dart' as http;

class Infermedica {
  static Map<String, String> inferHeader = {
    'App-Id': '0defd36e',
    'App-Key': 'c216e2f6f7eff06a3e978d1adf8850b1',
    'Content-Type': 'application/json'
  };
  static final url = 'https://api.infermedica.com/v3';
  static final parse = '/parse';
  static final diagnos = '/diagnosis';
  static final recommend = '/recommend_specialist';

  static Future diagnosis(List<Map> evidence) async {
    String diagnosUrl = url + diagnos;
    final respone = await http.post(
      diagnosUrl,
      headers: {
        'App-Id': '0defd36e',
        'App-Key': 'c216e2f6f7eff06a3e978d1adf8850b1',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(
        {
          "sex": "male",
          "age": {"value": 17},
          'evidence': evidence,
        },
      ),
    );
    final interview = jsonDecode(respone.body);
    print(interview);
    return interview;
  }

  static Future<List> parseText(String text) async {
    String parseUrl = url + parse;
    final respone = await http.post(parseUrl,
        headers: {
          'App-Id': '0defd36e',
          'App-Key': 'c216e2f6f7eff06a3e978d1adf8850b1',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "text": text,
          "age": {"value": 30}
        }));
    var symRes = jsonDecode(respone.body);
    List symptomsList = symRes["mentions"] as List;
    print(symptomsList);
    return symptomsList;
  }

  static Future<Map> suggestDoctor(List<Map> evidence) async {
    String recommendationUrl = url + recommend;
    final respone = await http.post(
      recommendationUrl,
      headers: {
        'App-Id': '0defd36e',
        'App-Key': 'c216e2f6f7eff06a3e978d1adf8850b1',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(
        {
          "sex": "male",
          "age": {"value": 17},
          'evidence': evidence,
        },
      ),
    );
    return jsonDecode(respone.body);
  }
}

/*[{"id": "s_274", "name": "Feeling hot", "common_name": "Feeling hot", "orth": "feel fever", "choice_id": "present", "type": "symptom"}, 
{"id": "s_21", "name": "Headache", "common_name": "Headache", "orth": "headache", "choice_id": "present", "type": "symptom"}], "obvious": false}*/
