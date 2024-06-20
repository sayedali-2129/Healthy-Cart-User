import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfScreen extends StatelessWidget {
  final String pdfUrl;
  final String title;
  final Color headingColor;
  final void Function()? onDownload;
  final String pdfName;
  const ViewPdfScreen(
      {super.key,
      required this.pdfUrl,
      required this.title,
      required this.headingColor,
      this.onDownload,
      required this.pdfName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
              size: 22,
            )),
        leadingWidth: 36,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          title,
          style: TextStyle(
            color: headingColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                color: Colors.white,
                itemBuilder: (context) => [
                      PopupMenuItem(
                          onTap: () {
                            FileDownloader.downloadFile(
                                url: pdfUrl,
                                name: pdfName,
                                onDownloadCompleted: (path) {
                                  CustomToast.sucessToast(
                                      text: 'Result Downloaded Successfully');
                                },
                                notificationType: NotificationType.all);
                          },
                          child: const Text('Download'))
                    ]),
          )
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: GestureDetector(
          //     onTap: () {

          //     },
          //     child: const Icon(
          //       Icons.more_vert_rounded,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: SfPdfViewer.network(
        pdfUrl,
      ),
    );
  }
}
