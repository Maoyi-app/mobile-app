

/// CHAT
const getUserConversationList = "/chat/myconversations";
const _startChatEndpoint = "/chat/new";

String startConversationFromListing(int listingId) {
  return _startChatEndpoint + "/" + listingId.toString();
}

String sendMessageFromConversation(int conversationId) {
  return "/chat/" + conversationId.toString();
}

String getMessageListFromId(int conversation) {
  return "/chat/" + conversation.toString() + "/latest";
}

String getMessageListInRange(int conversation) {
  return "/chat/" + conversation.toString() + "/range";
}
/// CHAT END



// needs login //

/// -- Commodity -- ///

const getCommodity = "aa";
const getAllCommodity = "/commodity/all";
// needs login //

/// -- Listing -- ///

const getListing = "aa";

// needs login //
const createOfferListing = "/listing/newOfferListing";

/// -- user auth -- ///

const loginUserEndpoint = "/authentication/login";

/// -- buyer register -- ///

const createBuyerEndpoint = "/buyer/create";

/// -- seller register -- ///

const createSellerEndpoint = "/seller/create";

/// -- user reset password -- ///

const changePasswordEndpoint = "/authentication/changepassword";

/// -- rating -- ///
const ratingEndpoint = "/rating/";

Uri getAppUri(String path, {Map<String, String> queryParameters}) {
  return Uri(
      scheme: "http",
      host: "10.0.2.2",
      port: 8080,
      path: "/api" + path,
      queryParameters: queryParameters);
}
