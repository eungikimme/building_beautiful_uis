import 'package:flutter/material.dart';

void main() {
  runApp(FriendlychatApp());
}
const String _name = "김은기";

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat",
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Friendlychat")),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length
            ),
          ),
          Divider(height: 1.0,),
          Container(
            decoration: BoxDecoration(color: Theme
                .of(context)
                .cardColor),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }


  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(color: Theme
            .of(context)
            .accentColor),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _handleSubmitted,
                      decoration: InputDecoration.collapsed(
                        hintText: "Send a message",
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text),
                  ),
                )
              ],
            )
        )
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
          duration: Duration(milliseconds: 700),
          vsync: this
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward(); // 이거 왜 여따둠?
  }

}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_name, style: Theme.of(context).textTheme.subhead),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                )
              ],
            )
          ],
        ),
      )
    );
  }

}