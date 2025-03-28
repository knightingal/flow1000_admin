Map<String, String> albumMap = {
  "1000": "source",
  "1803": "1803",
  "1804": "1804",
  "1805": "1805",
  "1806": "1806",
  "1807": "1807",
};

class AlbumInfo {
  final int index;
  final String name;
  final String cover;
  final int coverWidth;
  final int coverHeight;
  final String album;
  final String clientStatus;
  double realWidth = 0;
  double realHeight = 0;

  String toCoverUrl() {
    // return "http://192.168.2.12:3002/linux1000/encrypted/$name/$cover";
    return "http://192.168.2.12:3002/linux1000/${albumMap[album]}/$name/${cover.replaceAll(".bin", "")}";
  }


  AlbumInfo({required this.index, required this.name, required this.cover, required this.coverWidth, required this.coverHeight, required this.album, required this.clientStatus});

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
      index: json["index"], 
      name: json["name"], 
      cover: json["cover"], 
      coverWidth: json["coverWidth"], 
      coverHeight: json["coverHeight"], 
      album: json["album"], 
      clientStatus: json["clientStatus"]);
  }
}