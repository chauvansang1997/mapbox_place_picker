class MapBoxLocation {
  String? type;
  List<double>? query;
  List<Features>? features;
  String? attribution;

  MapBoxLocation({type, query, features, attribution});

  MapBoxLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    query = json['query'].cast<double>();
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features?.add(Features.fromJson(v));
      });
    }
    attribution = json['attribution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['query'] = query;
    if (features != null) {
      data['features'] = features?.map((v) => v.toJson()).toList();
    }
    data['attribution'] = attribution;
    return data;
  }
}

class Features {
  String? id;
  String? type;
  List<String>? placeType;
  int? relevance;
  Properties? properties;
  String? text;
  String? placeName;
  List<double>? center;
  Geometry? geometry;
  String? address;
  List<Context>? context;
  List<double>? bbox;

  Features(
      {id,
      type,
      placeType,
      relevance,
      properties,
      text,
      placeName,
      center,
      geometry,
      address,
      context,
      bbox});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    placeType = json['place_type'].cast<String>();
    relevance = json['relevance'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
    text = json['text'];
    placeName = json['place_name'];
    center = json['center'].cast<double>();
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    address = json['address'];
    if (json['context'] != null) {
      context = <Context>[];
      json['context'].forEach((v) {
        context!.add(Context.fromJson(v));
      });
    }
    bbox = json['bbox'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['type'] = type;
    data['place_type'] = placeType;
    data['relevance'] = relevance;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    data['text'] = text;
    data['place_name'] = placeName;
    data['center'] = center;
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    data['address'] = address;
    if (context != null) {
      data['context'] = context!.map((v) => v.toJson()).toList();
    }
    data['bbox'] = bbox;
    return data;
  }
}

class Properties {
  String? accuracy;
  String? mapboxId;
  String? wikidata;
  String? shortCode;

  Properties({accuracy, mapboxId, wikidata, shortCode});

  Properties.fromJson(Map<String, dynamic> json) {
    accuracy = json['accuracy'];
    mapboxId = json['mapbox_id'];
    wikidata = json['wikidata'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['accuracy'] = accuracy;
    data['mapbox_id'] = mapboxId;
    data['wikidata'] = wikidata;
    data['short_code'] = shortCode;
    return data;
  }
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({type, coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class Context {
  String? id;
  String? mapboxId;
  String? wikidata;
  String? text;
  String? shortCode;

  Context({id, mapboxId, wikidata, text, shortCode});

  Context.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mapboxId = json['mapbox_id'];
    wikidata = json['wikidata'];
    text = json['text'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['mapbox_id'] = mapboxId;
    data['wikidata'] = wikidata;
    data['text'] = text;
    data['short_code'] = shortCode;
    return data;
  }
}
