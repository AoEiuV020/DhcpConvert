import 'dart:io';

import 'package:dhcp_convert/dhcp.dart';
import 'package:dhcp_convert/openwrt.dart';
import 'package:json5/json5.dart';

Future<void> main(List<String> arguments) async {
  var file = File("example/dhcp_openwrt.txt");
  print('read: ${file.absolute}!');
  Config dhcp = Openwrt();
  print('type: ${dhcp.name}');
  var result = dhcp.convert(file.openRead());
  var list = await result.map((event) => event.toJson()).toList();
  print(JSON5.stringify(list, space: 2));
}
