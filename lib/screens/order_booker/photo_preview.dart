import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPreview extends StatefulWidget {
  final index;
  final url;
  const PhotoPreview({Key? key, this.index, this.url}) : super(key: key);

  @override
  _PhotoPreviewState createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image(
          height: 60,
          fit: BoxFit.contain,
          image: AssetImage(
            'assets/images/distrho_logo.png',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: (widget.url != null)
            ? Hero(
                tag: 'stock_image_${widget.index}',
                child: Image.network(widget.url))
            : Text('No Image Found'),
      ),
    );
  }
}
