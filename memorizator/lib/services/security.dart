import 'dart:convert';
//import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';
//import 'package:asn1lib/asn1lib.dart';

class Security {
  static const String base64PublicKey =
      'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxgE1/K951nyOkvFJX2dvAHcB3SpyhiXtxoskhlVBEDx6Xd7aBcM75fat+SItKaQRWCsYiO+wyDYflAkmoiAsYsixacbL422ofiFsvk7yjVPRHB38ADCGMDetVDFTLxhXXJmGXz6OQVcGskksXMwsaE2p8og79jvbHHx3tiy9FdchPQvzIcyXzEYiTuYaVufRFO23DoFpe/gPXCdegUJNm8cJDZSdpYzyVvbhhYPlkwSfH6lWzcRCArH8sXk3rCPeWTgsMCrdQt/bq3Wt/YuKI358trd2bio1K38nzSAVjY5JjEvuvyrL+fEz5SQGM2K6x7Oj+Vw8+hzdE1XFMo5McwIDAQAB';

  static RSAPublicKey parsePublicKey(String pem) {
    var bytes = base64.decode(pem);
    var asn1Parser = ASN1Parser(bytes);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var publicKeyBitString = topLevelSeq.elements![1] as ASN1BitString;

    var publicKeyAsn =
        ASN1Parser(publicKeyBitString.valueBytes); // Использование valueBytes
    var publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    var modulus = publicKeySeq.elements![0] as ASN1Integer;
    var exponent = publicKeySeq.elements![1] as ASN1Integer;

    return RSAPublicKey(modulus.integer!, exponent.integer!);
  }

  static bool verifyPurchase(String signedData, String signature) {
    try {
      var publicKey = parsePublicKey(base64PublicKey);
      var signer = Signer('SHA-256/RSA');
      signer.init(
          false,
          PublicKeyParameter<RSAPublicKey>(
              publicKey)); // false indicates verification

      var dataBytes = utf8.encode(signedData);
      var sigBytes = base64.decode(signature);

      return signer.verifySignature(dataBytes, RSASignature(sigBytes));
    } catch (e) {
      print('Ошибка при проверке parsePublicKey: $e');
      return false;
    }
  }
}
