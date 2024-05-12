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

  int currentIndex = -1;
  int currentSize = 0;
  String? name;
  String? ip;
  String? mac;

  @override
  void add(String data) {
    var wordList = split(data);
    if (getOrEmpty(wordList, 0) == "config") {
      save();
      if (getOrEmpty(wordList, 1) == "host") {
        currentIndex = currentSize;
      } else {
        currentIndex = -1;
      }
      return;
    }
    if (getOrEmpty(wordList, 0) == "option") {
      switch (getOrEmpty(wordList, 1)) {
        case "name":
          {
            name = unquote(getOrEmpty(wordList, 2));
          }
          break;
        case "mac":
          {
            mac = unquote(getOrEmpty(wordList, 2));
          }
          break;
        case "ip":
          {
            ip = unquote(getOrEmpty(wordList, 2));
          }
          break;
      }
    }
  }

  @override
  void close() {
    save();
    super.close();
  }

  String getOrEmpty(List<String> list, int index) {
    if (index < 0 || index >= list.length) {
      return "";
    }
    return list[index];
  }

  List<String> split(String line) {
    return line
        .split(" ")
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  void save() {
    if (currentIndex < 0) {
      return;
    }
    var ip = this.ip;
    var mac = this.mac;
    if (ip == null || mac == null) {
      return;
    }
    sink.add(DhcpItem(
      name: name ?? "",
      ip: ip,
      mac: mac,
    ));
  }

  String unquote(String value) {
    return value.replaceAll(RegExp("^'|'\$"), "");
  }
}
