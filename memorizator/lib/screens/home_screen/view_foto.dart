import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/services/constants.dart';

class ViewFoto extends StatelessWidget {
  final String image;
  final bool delete;
  const ViewFoto(this.image, this.delete, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: aLightGray,
      appBar: AppBar(
        title: Text(S.of(context).viewFoto),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Image(
                image: FileImage(
                  File(image),
                ),
              ),
            ),
            FittedBox(child: Text(image)),
            Visibility(
              visible: delete,
              child: Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 40),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  tooltip: S.of(context).removeFotoFromSaving,
                  backgroundColor: aGray,
                  child: const Icon(
                    Icons.delete_outline,
                    size: 40,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
