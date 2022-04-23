import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stremio/screens/transactionwidget.dart';

import '../apyd_client.dart';
import 'transaction_box.dart';
import 'transaction_page.dart';

class ChannelPage extends StatefulWidget {
  final Channel channel;
  const ChannelPage(this.channel);

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}



class _ChannelPageState extends State<ChannelPage> {
  GlobalKey<MessageInputState> _messageInputKey = GlobalKey();
  
  Future<void> _onPaymentRequestPressed() async {
    final String? amount = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => TransactionPage(
          destinationWalletAddress: 'ewallet-123',
        ),
      ),
    );
    if (amount != null) {
      _messageInputKey.currentState?.addAttachment(
        Attachment(
          type: 'payment',
          uploadState: UploadState.success(),
          extraData: {"amount": int.parse(amount)},
        ),
      );
    }
  }
late final String _sourceWalletId;
late final String _destinationWalletId;

getWallets() async {
  var members = await widget.channel.queryMembers();
  var destId = members.members[1].user!.extraData['wallet_id'] as String;
  var sourceId = members.members[0].user!.extraData['wallet_id'] as String;

  _sourceWalletId = sourceId;
  _destinationWalletId = destId;
}

bool _isSending = false;
RapydClient _rapydClient = RapydClient();

Future<Message> _performTransaction(Message msg) async {
  if (msg.attachments.isNotEmpty &&
      msg.attachments[0].extraData['amount'] != null) {
    setState(() {
      _isSending = true;
    });

    // Retrieve the amount
    int amount = msg.attachments[0].extraData['amount'] as int;

    // Process the transaction
    var transactionInfo = await _rapydClient.transferMoney(
      amount: amount,
      sourceWallet: _sourceWalletId,
      destinationWallet: _destinationWalletId,
    );

    // Confirm the transaction
    var updatedInfo = await _rapydClient.transferResponse(
        id: transactionInfo!.data.id, response: 'accept');

    // Update the attachment
    msg.attachments[0] = Attachment(
      type: 'payment',
      uploadState: UploadState.success(),
      extraData: updatedInfo!.toJson(),
    );

    setState(() {
      _isSending = false;
    });
  }

  return msg;
}

Widget _buildPaymentMessage(
  BuildContext context,
  Message details,
  List<Attachment> _,
) {
  final transaction = Transfer.fromJson(details.attachments.first.extraData);
  final transactionInfo = transaction.data;

  int amount = transactionInfo.amount;
  String destWalletAddress = transactionInfo.destinationEwalletId;
  String status = transactionInfo.status;

  return wrapAttachmentWidget(
    context,
    TransactionWidget(
      transaction: transaction,
      destWalletAddress: destWalletAddress,
      amount: amount,
      status: status,
    ),
    RoundedRectangleBorder(),
    true,
  );
}

@override
void initState() {
  super.initState();
  getWallets();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              
            )
          ),
          MessageInput(
            key:_messageInputKey,
            preMessageSending: (msg) => _performTransaction(msg),
            attachmentThumbnailBuilders: {
              'payment': (context, attachment) => TransactionAttachment(
                amount: attachment.extraData['amount'] as int,
                )
              },
            actions: [
              IconButton(
                icon: Icon(Icons.payment),
                onPressed: _onPaymentRequestPressed,
              ), // custom action
            ],
          ),
        ],
      ),
    );
  }
}

