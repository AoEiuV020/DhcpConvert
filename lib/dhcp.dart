import 'dart:async';
import 'dart:convert';

abstract class Config {
  late String name;

  StreamTransformer<String, DhcpItem> get transform =>
      DhcpStreamTransformer(this);

  Stream<DhcpItem> convertString(Stream<String> input) {
    return input.transform(transform);
  }

  Stream<DhcpItem> convert(Stream<List<int>> input) {
    return convertString(
        input.transform(utf8.decoder).transform(LineSplitter()));
  }

  Sink<String> dhcpSink(Sink<DhcpItem> sink);
}

class DhcpStreamTransformer extends Converter<String, DhcpItem> {
  final Config config;

  DhcpStreamTransformer(this.config);

  @override
  DhcpItem convert(String input) {
    // unreachable,
    throw UnimplementedError();
  }

  @override
  Sink<String> startChunkedConversion(Sink<DhcpItem> sink) {
    return config.dhcpSink(sink);
  }
}

abstract class DhcpSink extends Sink<String> {
  DhcpSink(this.sink);

  final Sink<DhcpItem> sink;

  @override
  void close() {
    sink.close();
  }
}

class DhcpItem {
  final String name;
  final String ip;
  final String mac;
  final String gateway;

  DhcpItem({
    this.name = "",
    required this.ip,
    required this.mac,
    this.gateway = "",
  });

  factory DhcpItem.fromJson(Map<String, dynamic> json) {
    return DhcpItem(
      name: json["name"],
      ip: json["ip"],
      mac: json["mac"],
      gateway: json["gateway"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "ip": ip,
      "mac": mac,
      "gateway": gateway,
    };
  }
}
