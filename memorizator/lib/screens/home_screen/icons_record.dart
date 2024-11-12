import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorizator/models/calcrec.dart';

class IconsRecord extends StatelessWidget {
  const IconsRecord({super.key, required this.item});
  final CalcRec item;

  @override
  Widget build(BuildContext context) {
    const double sizeIcon = 20;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconBarcode(item.barcode, sizeIcon),
        iconLocation(item.latitude! + item.longitude!, sizeIcon),
        iconCamera(item.listPhotoPath!.length, sizeIcon),
      ],
    );
  }

  iconBarcode(String? barcode, double sizeIcon) {
    if (barcode == null) {
      return const SizedBox();
    } else if (barcode.isEmpty) {
      return const SizedBox();
    }
    return Icon(
      CupertinoIcons.barcode,
      size: sizeIcon,
    );
  }

  iconLocation(double loc, double sizeIcon) {
    if (loc == 0) {
      return const SizedBox();
    }
    return Icon(
      Icons.location_on_outlined,
      size: sizeIcon,
    );
  }

  iconCamera(int count, double sizeIcon) {
    if (count == 0) {
      return const SizedBox();
    }
    return Icon(Icons.photo_camera_outlined, size: sizeIcon);
  }
}
