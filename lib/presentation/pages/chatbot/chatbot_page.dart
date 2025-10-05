import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulima_app/domain/entity/menu_entity.dart';
import 'package:ulima_app/domain/usecase/menu_usecase.dart';

class ChatbotPage extends StatefulWidget {
  final List<Map<String, String>> messages;
  final GetMenuItems getMenuItemsUseCase;

  const ChatbotPage(
      {super.key, required this.messages, required this.getMenuItemsUseCase});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  List<MenuItem> _menu = [];

  static const String _apiKey = 'AIzaSyC7JUhWtyhyt2pCf3MirQBM2guSSQmZr64';
  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    try {
      final items = await widget.getMenuItemsUseCase();
      setState(() {
        _menu = items;
      });
    } catch (e) {
      debugPrint('Error al cargar el menú: $e');
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      widget.messages.add({'role': 'user', 'text': text});
    });

    final menuText = _menu.isNotEmpty
        ? _menu
            .map((item) => '- ${item.nombre} (${item.descripcion})')
            .join('\n')
        : 'No hay menú disponible.';

    final systemContext = '''
Menú disponible hoy para que tengas en contexto (No lo menciones al usuario, solo si te lo pide):
$menuText

Eres un asistente virtual especializado en alimentos de la Universidad de Lima.
Tu tarea es recomendar los mejores platos del menú según lo que pida el usuario.

Responde siempre en español, de forma clara, amable y breve.
''';

    final contents = [
      {
        'role': 'user',
        'parts': [
          {'text': systemContext}
        ]
      },
      ...widget.messages.map((msg) => {
            'role': msg['role'] == 'model' ? 'model' : 'user',
            'parts': [
              {'text': msg['text']}
            ],
          }),
      {
        'role': 'user',
        'parts': [
          {'text': text}
        ]
      }
    ];

    final payload = {'contents': contents};

    try {
      final response = await http.post(
        Uri.parse('$_endpoint?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botText =
            data['candidates'][0]['content']['parts'][0]['text'] ?? '...';
        setState(() {
          widget.messages.add({'role': 'model', 'text': botText});
        });
      } else {
        setState(() {
          widget.messages.add({
            'role': 'model',
            'text': 'Error: ${response.statusCode}\n${response.body}'
          });
        });
      }
    } catch (e) {
      setState(() {
        widget.messages.add({'role': 'model', 'text': 'Error: $e'});
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente de Alimentos 🍽️'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Column(
        children: [
          if (_menu.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Cargando menú...'),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser
                          ? theme.colorScheme.primary.withOpacity(0.85)
                          : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.clear_outlined,
                        color: theme.colorScheme.primary),
                    onPressed: () {
                      setState(() {
                        widget.messages.clear();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          hintText: 'Pregunta sobre el menú...',
                          hintStyle: TextStyle(
                              color: theme.colorScheme.onSecondary
                                  .withOpacity(0.6)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: theme.colorScheme.secondary,
                              width: 2,
                            ),
                          )),
                      onSubmitted: (value) {
                        final text = value.trim();
                        if (text.isNotEmpty && !_isLoading) {
                          sendMessage(text);
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: theme.colorScheme.primary),
                    onPressed: _isLoading
                        ? null
                        : () {
                            final text = _controller.text.trim();
                            if (text.isNotEmpty) {
                              sendMessage(text);
                              _controller.clear();
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
