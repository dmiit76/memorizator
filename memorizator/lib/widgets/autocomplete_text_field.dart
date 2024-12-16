import 'package:flutter/material.dart';

class AutocompleteTextField extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemSelect;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final String? defaultValue; // Добавлен параметр для значения по умолчанию
  final int? minLines; // Минимальное количество строк
  final int? maxLines; // Максимальное количество строк

  const AutocompleteTextField({
    super.key,
    required this.items,
    required this.onItemSelect,
    this.decoration,
    this.validator,
    this.defaultValue,
    this.minLines,
    this.maxLines,
  });

  @override
  State<AutocompleteTextField> createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<AutocompleteTextField> {
  final FocusNode _focusNode = FocusNode();
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late List<String> _filteredItems;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;

    // Если передано значение по умолчанию, устанавливаем его в контроллер
    if (widget.defaultValue != null) {
      _controller.text = widget.defaultValue!;
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onFieldChange,
        decoration: widget.decoration,
        validator: widget.validator,
        minLines: widget.minLines, // Минимальное количество строк
        maxLines: widget.maxLines, // Максимальное количество строк
        style: const TextStyle(
          height:
              1.1, // Здесь регулируем межстрочное расстояние (по умолчанию 1.0)
        ),
      ),
    );
  }

  void _onFieldChange(String val) {
    setState(() {
      if (val == '') {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where(
                (element) => element.toLowerCase().contains(val.toLowerCase()))
            .toList();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    title: Text(
                      item,
                      style: const TextStyle(height: 1.1),
                    ),
                    onTap: () {
                      _controller.text = item;
                      _focusNode.unfocus();
                      widget.onItemSelect(item);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// class AutocompleteTextField extends StatefulWidget {
//   final List<String> items;
//   final Function(String) onItemSelect;
//   final InputDecoration? decoration;
//   final String? Function(String?)? validator;
//   final String? defaultValue; // Добавлен параметр для значения по умолчанию

//   const AutocompleteTextField(
//       {super.key,
//       required this.items,
//       required this.onItemSelect,
//       this.decoration,
//       this.validator,
//       this.defaultValue}); // Принимаем значение по умолчанию

//   @override
//   State<AutocompleteTextField> createState() => _AutocompleteTextFieldState();
// }

// class _AutocompleteTextFieldState extends State<AutocompleteTextField> {
//   final FocusNode _focusNode = FocusNode();
//   late OverlayEntry _overlayEntry;
//   final LayerLink _layerLink = LayerLink();
//   late List<String> _filteredItems;

//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _filteredItems = widget.items;

//     // Если передано значение по умолчанию, устанавливаем его в контроллер
//     if (widget.defaultValue != null) {
//       _controller.text = widget.defaultValue!;
//     }

//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus) {
//         _overlayEntry = _createOverlayEntry();
//         Overlay.of(context).insert(_overlayEntry);
//       } else {
//         _overlayEntry.remove();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(
//       link: _layerLink,
//       child: TextFormField(
//         controller: _controller,
//         focusNode: _focusNode,
//         onChanged: _onFieldChange,
//         decoration: widget.decoration,
//         validator: widget.validator,
//       ),
//     );
//   }

//   void _onFieldChange(String val) {
//     setState(() {
//       if (val == '') {
//         _filteredItems = widget.items;
//       } else {
//         _filteredItems = widget.items
//             .where(
//                 (element) => element.toLowerCase().contains(val.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     var size = renderBox.size;

//     return OverlayEntry(
//       builder: (context) => Positioned(
//         width: size.width,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           showWhenUnlinked: false,
//           offset: Offset(0.0, size.height + 5.0),
//           child: Material(
//             elevation: 4.0,
//             child: Container(
//               constraints: const BoxConstraints(maxHeight: 200),
//               child: ListView.builder(
//                 itemCount: _filteredItems.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final item = _filteredItems[index];
//                   return ListTile(
//                     title: Text(item),
//                     onTap: () {
//                       _controller.text = item;
//                       _focusNode.unfocus();
//                       widget.onItemSelect(item);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

