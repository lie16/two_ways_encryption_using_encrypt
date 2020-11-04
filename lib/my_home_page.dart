import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text = 'Text 1, Text 2, Text 3';
  // var key;
  int _counter = 0;

  void _incrementCounter() {
    _aesEncryption();
    _salsaEncryption();
    // _fernet();
    setState(() {
      _counter++;
    });
  }

  void _aesEncryption() {
    final _key = encrypt.Key.fromUtf8('my 32 length key................');
    final _iv = encrypt.IV.fromLength(16);
    final _encrypter =
        encrypt.Encrypter(encrypt.AES(_key)); // Could change mode
    final _encrypted = _encrypter.encrypt(_text, iv: _iv);
    final _decrypted = _encrypter.decrypt(_encrypted, iv: _iv);
    print('AES Encryption _encrypted: ${_encrypted.base64}');
    print('AES Encryption _encrypted: ${_encrypted.base16}');
    print('AES Encryption _decrypted: $_decrypted');
  }

  void _salsaEncryption() {
    final _key = encrypt.Key.fromLength(32);
    final _iv = encrypt.IV.fromLength(8);
    final _encrypter = encrypt.Encrypter(encrypt.Salsa20(_key));

    final _encrypted = _encrypter.encrypt(_text, iv: _iv);
    final _decrypted = _encrypter.decrypt(_encrypted, iv: _iv);
    print('SALSA20 Encryption _encrypted: ${_encrypted.base64}');
    print('SALSA20 Encryption _encrypted: ${_encrypted.base16}');
    print('SALSA20 Encryption _decrypted: $_decrypted');
  }

  //TODO: error cause unknown
  void _fernet() {
    final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');

    final _b64key = encrypt.Key.fromUtf8(base64Url.encode(_key.bytes));
    // if you need to use the ttl feature, you'll need to use APIs in the algorithm itself
    final _fernet = encrypt.Fernet(_b64key);
    final _encrypter = encrypt.Encrypter(_fernet);

    final _encrypted = _encrypter.encrypt(_text);
    final _decrypted = _encrypter.decrypt(_encrypted);

    print('Fernet Encryption _encrypted: ${_encrypted.base64}');
    print('Fernet Encryption _decrypted: $_decrypted');
    print(
        'Fernet ExtractTimeStamp: ${_fernet.extractTimestamp(_encrypted.bytes)}'); // unix timestamp
  }

  // void _stretch() {
  //   final salt = Uint8List(16);
  //   final key = encrypt.Key.fromUtf8('short').stretch(32, salt: salt);

  //   print('Stretch key: ${key.base64}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _text,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
