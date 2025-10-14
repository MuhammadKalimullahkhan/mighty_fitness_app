
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String _apiKey = 'AIzaSyDQqfEeKWod2ynntB4tGiPJscJWWzybyRE'; // Replace with your API key
  final String _apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent';

  Future<String> getFitnessResponse(String userQuery) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': userQuery}
              ]
            }
          ],
          'systemInstruction': {
            'parts': [
              {'text': 'You are a fitness assistant. Based on the user\'s query, provide a detailed and helpful response. Use markdown for formatting, including bold for key terms and bullet points for lists. Do not use external links. Do not answer questions that are not about fitness, nutrition, or wellness. If a query is outside your scope, politely decline and explain your purpose.'}
            ]
          }
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Error: ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
