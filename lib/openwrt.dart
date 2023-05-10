import 'dhcp.dart';

class Openwrt extends Config {
  @override
  String get name => "Openwrt";

  @override
  Sink<String> dhcpSink(Sink<DhcpItem> sink) {
    return OpenwrtDhcpSink(sink);
  }
}

class OpenwrtDhcpSink extends DhcpSink {
  OpenwrtDhcpSink(super.sink);

  int currentIndex = 0;
  String? name;
  String? ip;
  String? mac;
  String? gateway;

  @override
  void add(String data) {
    sink.add(DhcpItem(
        name: "name+${currentIndex++}",
        ip: "ip",
        mac: "mac",
        gateway: "gateway"));
  }
}
