import 'dart:convert';
//import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:login_app/Pages/dashboard.dart';
import 'package:login_app/main.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
      id: '82091008-a484-4a89-ae75-a22bf8d6f3ac', firstName: 'User');
  final _Alice = const types.User(
      id: '82091008-a484-4a89-ae75-a22bf8d6f3ab', firstName: 'Alice');

  List<Widget> tilelist = [];
  BuildContext? gcontext;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    sendText("اهلا", false);
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');
    return token;
  }

  var Data, Options;
  String output = "";

  Future<String> EndSession() async {
    var response = await http.post(
      Uri.https('iic-project.herokuapp.com', '/api/v1/endSession'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': await getStringValuesSF(),
      },
      body: jsonEncode(
        {},
      ),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'failure';
    }
  }

  Future<void> sendText(String _text, bool isListTile) async {
    // clear all the options in the tilelist
    tilelist = [];

    var response = await http.post(
      Uri.https('iic-project.herokuapp.com', '/api/v1/sendText'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': await getStringValuesSF(),
      },
      body: jsonEncode(
        {
          "input": {
            "component": {"value": _text, "type": "text"}
          }
        },
      ),
    );

    var data = jsonDecode(response.body) as Map<String, dynamic>;
    var answerList = data['output'][0];

    if (response.statusCode == 200) {
      // handle simple responses from Alice which is a text
      if (answerList['message_type'] == "text") {
        for (int i = 0; i < data['output'].length; i++) {
          final msg = data['output'][i]['component']['text'];
          print("MSG: $msg");
          _handleRecievedMessages(msg);
          // _handleRecievedMessages(answerList['component']['text']);
        }
      } else if (answerList['message_type'] == "option") {
        // here we display several options to the user
        data = answerList['component'];

        String outputToUser = data['title'] + ":" + '\n' + '\n';
        output = outputToUser;
        var options = data['options'];
        // optionList = options;

        // createBottomSheet();

        for (var i = 0; i < options.length; i++) {
          var optionLabel = options[i]['label'];
          var optionValue = options[i]['value']['input']['text'];

          outputToUser = outputToUser + "$optionValue - $optionLabel" + '\n';
          // _handleRecievedMessages("$optionLabel ادخل $optionValue");

          tilelist.add(ListTile(
              title: Text(optionLabel),
              onTap: () {
                sendText(optionValue, true);

                _addMessage(types.TextMessage(
                  author: _user,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                  id: const Uuid().v4(),
                  text: optionLabel,
                ));

                Navigator.pop(gcontext!);
              }));

          // optionList![i] = ListTile(
          //   title: Text(optionLabel),
          //   onTap: () => sendText(optionValue),
          // );
        }

        outputToUser = outputToUser +
            '\n' +
            "ادخل رقم الاختيار الذى ترغب به او اضغط على علامة زائد اسفل يسار الشاشة لاختيار الاختيار الذي ترغب به";
        _handleRecievedMessages(outputToUser);
      }
    } else {
      print(response);
    }
  }

  void showOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // children: optionList!
            //     .map((option) => ListTile(
            //           title: Text(option['label']),
            //         ))
            //     .toList());
            children: tilelist,
          ),
        );
      },
    );
  }

  String selectedItem = '';
  @override
  Widget build(BuildContext context) {
    gcontext = context;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "أليس",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 2, 47, 98),
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () async {
            var statues = await EndSession();
            if (statues == 'failure') {
              print('failed');
            } else {
              print(statues);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            }

            ;
          },
          icon: const Icon(Icons.arrow_left_sharp),
          label: const Text('الرجوع'),
          style: ElevatedButton.styleFrom(
              elevation: 0, primary: Colors.transparent),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Chat(
          messages: _messages,
          onAttachmentPressed: showOptions,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
        ),
      ),
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
    sendText(message.text, false);
  }

  void _handleRecievedMessages(String text) {
    final textMessage = types.TextMessage(
      author: _Alice,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }
}
