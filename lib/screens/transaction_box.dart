// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../apyd_client.dart';
import 'payment_details.dart';

class TransactionWidget extends StatefulWidget {
  TransactionWidget({Key? key, 
    required this.transaction,
    required this.destWalletAddress,
    required this.amount,
    required this.status,
  }) : super(key: key);

  final Transfer transaction;
  final String destWalletAddress;
  final int amount;
  final String status;

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => DetailPage(
              transaction: widget.transaction,
            ),
          ),
        );
      },
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.maxFinite,
              
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sending To',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.destWalletAddress,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.blue.withOpacity(0.1),
              width: double.maxFinite,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$',
                      style: TextStyle(fontSize: 50.0),
                    ),
                    Text(
                      '${widget.amount}',
                      style: TextStyle(fontSize: 80.0),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'STATUS: ${widget.status == 'PEN' ? 'Pending' : widget.status == 'DEC' ? 'Declined' : 'Completed'}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}