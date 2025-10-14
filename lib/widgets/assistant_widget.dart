
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../services/gemini_api_service.dart';

class AssistantWidget extends StatefulWidget {
  const AssistantWidget({super.key});

  @override
  _AssistantWidgetState createState() => _AssistantWidgetState();
}

class _AssistantWidgetState extends State<AssistantWidget> {
  final _formKey = GlobalKey<FormState>();
  String _userQuery = '';
  String _apiResponse = '';
  bool _isLoading = false;

  void _getApiResponse() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final response = await GeminiApiService().getFitnessResponse(_userQuery);
      setState(() {
        _apiResponse = response;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Ask your fitness question'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a question.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userQuery = value!;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.tealAccent),
                onPressed: _getApiResponse,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_isLoading)
          const CircularProgressIndicator()
        else if (_apiResponse.isNotEmpty)
          Expanded(
            child: Markdown(
              data: _apiResponse,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
      ],
    );
  }
}
