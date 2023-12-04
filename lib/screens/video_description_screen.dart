import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:model_company/my_theme.dart';
import 'package:model_company/helpers/shared_value_helper.dart';
import 'package:video_player/video_player.dart';
class VideoDescription extends StatefulWidget {
  String url;
  String video;

  VideoDescription({Key key, this.url, this.video}) : super(key: key);

  @override
  _VideoDescriptionState createState() => _VideoDescriptionState();
}

class _VideoDescriptionState extends State<VideoDescription> {
 // WebViewController _webViewController;
 VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(
        widget.video))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        }
        return Future.value(true);
      },
      child: Directionality(
        textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: widget.video != null ? buildVideoBody() : buildBody(),
        ),
      ),
    );
  }

  buildBody() {
    return SizedBox.expand(
      child: Container(
        child: Stack(
          children: [
            // WebView(
            //   debuggingEnabled: false,
            //   javascriptMode: JavascriptMode.unrestricted,
            //   onWebViewCreated: (controller) {
            //     _webViewController = controller;
            //     _webViewController.loadUrl(widget.url);
            //
            //   },
            //   onWebResourceError: (error) {},
            //   onPageFinished: (page) {
            //     print(page.toString());
            //   },
            // ),
            Align(
              alignment: app_language_rtl.$ ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(

                decoration: ShapeDecoration(
                  color: MyTheme.medium_grey_50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                ),

                width: 40,
                height: 40,
                child: IconButton(
                  icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.white),
                  onPressed: () {
                    if (MediaQuery.of(context).orientation == Orientation.landscape) {
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                    }
                    return Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildVideoBody() {
    return Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        );
  }
}
