import 'dart:convert';
import 'dart:io';
//import 'package:pointycastle/export.dart';
import 'package:external_path/external_path.dart';

//import 'package:intl/intl.dart';
import 'package:pointycastle/pointycastle.dart';
//import 'package:asn1lib/asn1lib.dart';

class Security {
  static const String base64PublicKey =
      'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxgE1/K951nyOkvFJX2dvAHcB3SpyhiXtxoskhlVBEDx6Xd7aBcM75fat+SItKaQRWCsYiO+wyDYflAkmoiAsYsixacbL422ofiFsvk7yjVPRHB38ADCGMDetVDFTLxhXXJmGXz6OQVcGskksXMwsaE2p8og79jvbHHx3tiy9FdchPQvzIcyXzEYiTuYaVufRFO23DoFpe/gPXCdegUJNm8cJDZSdpYzyVvbhhYPlkwSfH6lWzcRCArH8sXk3rCPeWTgsMCrdQt/bq3Wt/YuKI358trd2bio1K38nzSAVjY5JjEvuvyrL+fEz5SQGM2K6x7Oj+Vw8+hzdE1XFMo5McwIDAQAB';
  static StringBuffer logBuffer = StringBuffer();

  static RSAPublicKey parsePublicKey(String pem) {
    logBuffer
        .writeln('${DateTime.now().toString()}:  Start log parsePublicKey');
    var bytes = base64.decode(pem);
    logBuffer.writeln('${DateTime.now().toString()}:  bytes=$bytes');
    var asn1Parser = ASN1Parser(bytes);
    logBuffer.writeln('${DateTime.now().toString()}:  asn1Parser=$asn1Parser');
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    logBuffer
        .writeln('${DateTime.now().toString()}:  topLevelSeq=$topLevelSeq');
    var publicKeyBitString = topLevelSeq.elements![1] as ASN1BitString;
    logBuffer.writeln(
        '${DateTime.now().toString()}:  publicKeyBitString=$publicKeyBitString');

    var publicKeyAsn =
        ASN1Parser(publicKeyBitString.valueBytes); // Использование valueBytes
    logBuffer
        .writeln('${DateTime.now().toString()}:  publicKeyAsn=$publicKeyAsn');
    var publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    logBuffer
        .writeln('${DateTime.now().toString()}:  publicKeySeq=$publicKeySeq');

    if (publicKeySeq.elements!.isNotEmpty) {
      logBuffer.writeln(
          'First element type: ${publicKeySeq.elements![0].runtimeType}');
      logBuffer.writeln('First element content: ${publicKeySeq.elements![0]}');
      logBuffer.writeln(
          'Second element type: ${publicKeySeq.elements![1].runtimeType}');
      logBuffer.writeln('Second element content: ${publicKeySeq.elements![1]}');
    } else {
      logBuffer.writeln('No elements found in publicKeySeq');
    }

    var modulus = publicKeySeq.elements![0] as ASN1Integer;

    logBuffer.writeln('${DateTime.now().toString()}:  modulus=$modulus');
    var exponent = publicKeySeq.elements![1] as ASN1Integer;
    logBuffer.writeln('${DateTime.now().toString()}:  exponent=$exponent');
    return RSAPublicKey(modulus.integer!, exponent.integer!);
  }

  static bool verifyPurchase(String signedData, String signature) {
    bool ret = false;
    try {
      logBuffer.writeln('${DateTime.now().toString()}:  Start log');
      var publicKey = parsePublicKey(base64PublicKey);
      logBuffer.writeln('${DateTime.now().toString()}: publicKey=$publicKey');
      var signer = Signer('SHA-256/RSA');
      logBuffer.writeln('${DateTime.now().toString()}: signer=$signer');
      signer.init(
          false,
          PublicKeyParameter<RSAPublicKey>(
              publicKey)); // false indicates verification
      logBuffer.writeln('${DateTime.now().toString()}: after signer.init');
      var dataBytes = utf8.encode(signedData);
      logBuffer.writeln('${DateTime.now().toString()}: dataBytes=$dataBytes');
      var sigBytes = base64.decode(signature);
      logBuffer.writeln('${DateTime.now().toString()}: sigBytes=$sigBytes');

      ret = signer.verifySignature(dataBytes, RSASignature(sigBytes));
      logBuffer.writeln('${DateTime.now().toString()}: return1 $ret');
    } catch (e) {
      logBuffer.writeln(
          '${DateTime.now().toString()}: Ошибка при проверке parsePublicKey: $e');
      //print('Ошибка при проверке parsePublicKey: $e');
      ret = false;
      logBuffer.writeln('${DateTime.now().toString()}: return2 $ret');
    }
    logBuffer.writeln('${DateTime.now().toString()}: return0 $ret');
    writeLog(logBuffer);
    return ret;
  }

  static Future<void> writeLog(StringBuffer logBuffer) async {
    final directory = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final filePath = '$directory/logSec.txt';

    final file = File(filePath);
    logBuffer.writeln('${DateTime.now().toString()}: filePath $filePath');
    String finalString = logBuffer.toString();
    try {
      await file.writeAsString(finalString, mode: FileMode.append);
      logBuffer.clear(); // Очищаем буфер после записи
    } catch (e) {
      var time = DateTime.now().toString();
      await file.writeAsString("$time: Error: $e\n", mode: FileMode.append);
    }
  }

  // static void addLog(String message) {
  //   logBuffer.writeln('${DateTime.now().toString()}:  $message');
  // }
}
