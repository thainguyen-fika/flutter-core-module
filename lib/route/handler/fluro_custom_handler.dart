import 'package:fk_core_package/fk_core_package.dart';
import 'package:fluro/fluro.dart';

class CustomHandler extends Handler {
  CustomHandler({HandlerType type = HandlerType.route, HandlerFunc handlerFunc})
      : super(
      type: type,
      handlerFunc: (context, Map<String, List<String>> params) {
        //Clean data before sending data to User handle
        Map<String, List<String>> newData =
        params.map((String key, value) {
          List<String> newValue = value.map((e) {
            return e.replaceAll(CoreRouter.ENCODE_OF_ROUTER_KEY, "\/");
          }).toList();
          return MapEntry(key, newValue);
        });
        return handlerFunc(context, newData);
      });
}
