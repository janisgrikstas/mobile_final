import 'dart:convert';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'secrets.dart';

class RapydClient {
  final _baseURL = 'https://sandboxapi.rapyd.net';
  final _accessKey = RAPYD_ACCESS_KEY;
  final _secretKey = RAPYD_SECRET_KEY;

  Future<Transfer?> transferMoney({
    required String sourceWallet,
    required String destinationWallet,
    required int amount,
  }) async {
    Transfer? transferDetails;

    var method = "post";
    var transferEndpoint = '/v1/account/transfer';

    final transferURL = Uri.parse(_baseURL + transferEndpoint);

    var data = jsonEncode({
      "source_ewallet": sourceWallet,
      "amount": amount,
      "currency": "USD",
      "destination_ewallet": destinationWallet,
    });

    final headers =
        _generateHeader(method: method, endpoint: transferEndpoint, body: data);
  
  try {
    var response = await http.post(
      transferURL,
      headers: headers,
      body: data,
    );

    print(response.body);

    if (response.statusCode == 200) {
      print('SUCCESSFULLY TRANSFERRED');
      transferDetails = Transfer.fromJson(jsonDecode(response.body));
    }
  } catch (e) {
    print('Failed to transfer amount');
  }

  return transferDetails;
}
  
  

  Map<String, String> _generateHeader({
    required String method,
    required String endpoint,
    String body = '',
  }) {
    int unixTimetamp = DateTime.now().millisecondsSinceEpoch;
    String timestamp = (unixTimetamp / 1000).round().toString();

    var salt = _generateSalt();

    var toSign =
        method + endpoint + salt + timestamp + _accessKey + _secretKey + body;

    var keyEncoded = ascii.encode(_secretKey);
    var toSignEncoded = ascii.encode(toSign);

    var hmacSha256 = Hmac(sha256, keyEncoded); // HMAC-SHA256
    var digest = hmacSha256.convert(toSignEncoded);
    var ss = hex.encode(digest.bytes);
    var tt = ss.codeUnits;
    var signature = base64.encode(tt);

    var headers = {
      'Content-Type': 'application/json',
      'access_key': _accessKey,
      'salt': salt,
      'timestamp': timestamp,
      'signature': signature,
    };

    return headers;
  }

  String _generateSalt() {
    final _random = Random.secure();
    // Generate 16 characters for salt by generating 16 random bytes
    // and encoding it.
    final randomBytes = List<int>.generate(16, (index) => _random.nextInt(256));
    return base64UrlEncode(randomBytes);
  }

Future<Transfer?> transferResponse({
  required String id,
  required String response,
}) async {
  Transfer? transferDetails;

  var method = "post";
  var responseEndpoint = '/v1/account/transfer/response';

  final responseURL = Uri.parse(_baseURL + responseEndpoint);

  var data = jsonEncode({
    "id": id,
    "status": response,
  });

final headers = _generateHeader(
    method: method,
    endpoint: responseEndpoint,
    body: data,
  );

  try {
    var response = await http.post(
      responseURL,
      headers: headers,
      body: data,
    );

    print(response.body);

    if (response.statusCode == 200) {
      print('TRANSFER STATUS UPDATED: $response');
      transferDetails = Transfer.fromJson(jsonDecode(response.body));
    }
  } catch (e) {
    print('Failed to update transfer status');
  }

  return transferDetails;

}

}







class Transfer {
  Transfer({
    required this.status,
    required this.data,
  });

  Status status;
  Data data;

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
        status: Status.fromJson(json["status"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.status,
    required this.amount,
    required this.currencyCode,
    required this.destinationPhoneNumber,
    required this.destinationEwalletId,
    required this.destinationTransactionId,
    required this.sourceEwalletId,
    required this.sourceTransactionId,
    required this.createdAt,
  });

  String id;
  String status;
  int amount;
  String currencyCode;
  String destinationPhoneNumber;
  String destinationEwalletId;
  String destinationTransactionId;
  String sourceEwalletId;
  String sourceTransactionId;
  int createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        status: json["status"],
        amount: json["amount"],
        currencyCode: json["currency_code"],
        destinationPhoneNumber: json["destination_phone_number"],
        destinationEwalletId: json["destination_ewallet_id"],
        destinationTransactionId: json["destination_transaction_id"],
        sourceEwalletId: json["source_ewallet_id"],
        sourceTransactionId: json["source_transaction_id"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "amount": amount,
        "currency_code": currencyCode,
        "destination_phone_number": destinationPhoneNumber,
        "destination_ewallet_id": destinationEwalletId,
        "destination_transaction_id": destinationTransactionId,
        "source_ewallet_id": sourceEwalletId,
        "source_transaction_id": sourceTransactionId,
        "created_at": createdAt,
      };
}

class Status {
  Status({
    required this.status,
    required this.operationId,
  });

  String status;
  String operationId;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        status: json["status"],
        operationId: json["operation_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "operation_id": operationId,
      };
}
