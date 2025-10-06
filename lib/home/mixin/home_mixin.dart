part of 'package:rf_id_test/home/home_page_old.dart';

mixin HomeMixin on State<HomePage> {
  late final ValueNotifier<String> nfcReaderResult;
  late final ValueNotifier<bool> isLoading;
  late final ValueNotifier<String> scannedText;

  static const platform = MethodChannel('rfid_channel');

  @override
  void initState() {
    super.initState();
    nfcReaderResult = ValueNotifier('Start NFC Scan');
    scannedText = ValueNotifier('empty');
    isLoading = ValueNotifier(false);

    _initTask();
  }

  FutureOr<void> _initTask() async {
    isLoading.value = true;
    try {
      final String result = await platform.invokeMethod('initTask');
      nfcReaderResult.value = result;
    } on PlatformException catch (e) {
      nfcReaderResult.value = 'fail';
      await Fluttertoast.showToast(msg: 'code: ${e.code}\nmsg: ${e.message}');
    }
    isLoading.value = false;
  }

  Future<void> _start() async {
    try {
      await platform.invokeMethod('start');
    } on PlatformException catch (e) {
      await Fluttertoast.showToast(msg: 'code: ${e.code}\nmsg: ${e.message}');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
