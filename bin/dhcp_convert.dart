import 'dart:convert';
import 'dart:io';

import 'package:dhcp_convert/dhcp.dart';
import 'package:dhcp_convert/openwrt.dart';

void main(List<String> arguments) {
  var file = File("example/dhcp_openwrt.txt");
  print('read: ${file.absolute}!');
  Config dhcp = Openwrt();
  print('type: ${dhcp.name}');
  var result = dhcp.convert(file.openRead());
  result.forEach((element) {
    print(json.encode(element.toJson()));
  });
}
