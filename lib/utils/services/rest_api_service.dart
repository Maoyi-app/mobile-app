import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fishapp/constants/api_path.dart' as apiPaths;
import 'package:fishapp/entities/commodity.dart';
import 'package:fishapp/entities/listing.dart';
import 'package:fishapp/utils/services/fishapp_rest_client.dart';

import '../../constants/api_path.dart';
import '../../entities/listing.dart';

class CommodityService {
  final FishappRestClient _client = FishappRestClient();

  Future<Commodity> getCommodity(BuildContext context, num id) async {
    var uri = getAppUri(apiPaths.getAllCommodity);
    var response = await _client.get(context, uri);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body["data"] != null) {
        return Commodity.fromJson(body["data"]);
      }
    }
    return null;
  }

  Future<List<Commodity>> getAllCommodities(BuildContext context) async {
    var uri = getAppUri(apiPaths.getAllCommodity);
    var response = await _client.get(context, uri, addAuth: true);
    List returnList;

    switch (response.statusCode) {
      case 200:
        var body = jsonDecode(response.body);
        returnList = Commodity.fromJsonList(body);
        break;
      case 401:
        throw HttpException(HttpStatus.unauthorized.toString());
        break;
      case 500:
        throw HttpException(HttpStatus.internalServerError.toString());
        break;
      default:
        returnList = List();
        break;
    }
    return returnList;
  }
}

class ListingService {
  final FishappRestClient _client = FishappRestClient();

  Future<Listing> getListing(BuildContext context, num id) async {
    var uri = getAppUri(apiPaths.getListing);
    var response = await _client.get(context, uri);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body["data"] != null) {
        return Listing.fromJson(body["data"]);
      }
    }
    return null;
  }

  Future<OfferListing> createOfferListing(
      BuildContext context, OfferListing offerListing) async {
    var uri = getAppUri(apiPaths.createOfferListing);
    OfferListing offerListing;
    try {
      var response = await _client.post(context, uri,
          headers: {'Content-type': "application/json"},
          body: offerListing.toJsonString(),
          addAuth: true);
      switch (response.statusCode) {
        case 200:
          return offerListing =
              OfferListing.fromJson(jsonDecode(response.body));
          break;
        case 401:
          throw HttpException(HttpStatus.unauthorized.toString());
          break;
        case 403:
          throw HttpException(HttpStatus.forbidden.toString());
          break;
        case 409:
          break;
        case 500:
        default:
          throw HttpException(HttpStatus.internalServerError.toString());
          break;
      }
    } on IOException catch (e) {
      log("IO failure " + e.toString(), time: DateTime.now());
      throw HttpException("Service unavailable");
    }
    return offerListing;
  }
}
