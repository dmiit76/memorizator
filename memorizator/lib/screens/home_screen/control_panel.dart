import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/providers/photofile_provider.dart';
import 'package:memorizator/screens/home_screen/edit_record.dart';
import 'package:memorizator/screens/home_screen/view_foto.dart';
import 'package:provider/provider.dart';
import 'package:memorizator/providers/info_provider.dart';
import 'package:memorizator/services/constants.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  //List listPhotoFiles = [];

  @override
  Widget build(BuildContext context) {
    final infoProvider = context.read<InfoProvider>();
    final photofileProvider = context.read<PhotofileProvider>();

    const myButtonStyle = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(aWhite),
      shadowColor: WidgetStatePropertyAll(aGray),
      elevation: WidgetStatePropertyAll(20),
      padding: WidgetStatePropertyAll(EdgeInsets.only(left: 8, right: 8)),
    );
    const myButtonStyleSave = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(aWhite),
      shadowColor: WidgetStatePropertyAll(aGray),
      elevation: WidgetStatePropertyAll(20),
      padding: WidgetStatePropertyAll(EdgeInsets.only(left: 8, right: 8)),
    );
    return Column(
      children: [
        Visibility(
          visible: photofileProvider.listPhotoFiles.isNotEmpty,
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            height: 65,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photofileProvider.listPhotoFiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  //key: UniqueKey(),
                  // Просмотр фотографии:
                  onTap: () async {
                    photofileProvider.setItem = index;
                    bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ViewFoto(
                              photofileProvider
                                  .listPhotoFiles[photofileProvider.setItem],
                              true);
                        },
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        context.read<PhotofileProvider>().removeFoto();
                      });
                    }
                  },
                  onLongPress: () {},
                  child: Container(
                    key: UniqueKey(),
                    margin: const EdgeInsets.only(right: 5),
                    height: 60,
                    width: 60,
                    color: aLightBlack,
                    child: Image(
                      image: FileImage(
                        File(photofileProvider.listPhotoFiles[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          textAlign: TextAlign.center,
                          S.of(context).chooseSource,
                          style: const TextStyle(fontSize: 26, color: aBlue),
                        ),
                        content: SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await photofileProvider
                                          .selectImageFromCamera();

                                      if (mounted) {
                                        setState(() {});

                                        // Безопасный вызов Navigator.pop
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if (mounted &&
                                              Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        });
                                      }
                                    },
                                    iconSize: 60,
                                    highlightColor: aBlue,
                                    icon:
                                        const Icon(Icons.add_a_photo_outlined),
                                  ),
                                  Text(
                                    S.of(context).camera,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await photofileProvider
                                          .selectImageFromGallery();

                                      // Проверяем mounted перед использованием Navigator и setState
                                      if (mounted) {
                                        setState(() {});

                                        // Безопасный вызов Navigator.pop
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if (mounted &&
                                              Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        });
                                      }
                                    },
                                    iconSize: 60,
                                    highlightColor: aBlue,
                                    icon:
                                        const Icon(Icons.image_search_outlined),
                                  ),
                                  Text(
                                    S.of(context).gallery,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Text(S.of(context).cancel),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: myButtonStyle,
                child: Row(
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      color: photofileProvider.listPhotoFiles.isNotEmpty
                          ? Colors.green
                          : aBlue,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      '+${S.of(context).fotoButton}',
                      style: TextStyle(
                        fontSize: 12,
                        color: photofileProvider.listPhotoFiles.isNotEmpty
                            ? Colors.green
                            : aBlue,
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: () async {
                await photofileProvider.scanBarcode(true);
                setState(() {});
              },
              style: myButtonStyle,
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.barcode,
                    color: photofileProvider.barcodeResult.isNotEmpty
                        ? Colors.green
                        : aBlue,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    '+${S.of(context).barcodeButton}',
                    style: TextStyle(
                      fontSize: 12,
                      color: photofileProvider.barcodeResult.isNotEmpty
                          ? Colors.green
                          : aBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextButton(
                  onPressed: () async {
                    await editRecord(context, infoProvider);
                    setState(() {});
                    //Navigator.pop(context);
                  },
                  style: myButtonStyleSave,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.floppy_disk),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        S.of(context).save,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
