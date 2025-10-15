
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../services/gemini_api_service.dart';

class AssistantWidget extends StatefulWidget {
  const AssistantWidget({super.key});

  @override
  AssistantWidgetState createState() => AssistantWidgetState();
}

class AssistantWidgetState extends State<AssistantWidget> {
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
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Ask your fitness question'),
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
                icon: Icon(Icons.send, color: theme.colorScheme.secondary),
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
            child: MarkdownWidget(
              data: _apiResponse,
              config: MarkdownConfig(
                configs: [
                  PConfig(
                    textStyle: GoogleFonts.poppins(
                      textStyle: theme.textTheme.bodyLarge ?? const TextStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
