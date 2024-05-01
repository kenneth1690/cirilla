import 'dart:convert';

import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/models/message/message.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/order/order.dart';
import 'package:cirilla/models/order_note/order_node.dart';
import 'package:cirilla/models/post_author/post_author.dart';
import 'package:cirilla/models/product/attributes.dart';
import 'package:cirilla/models/product/product_prices.dart';
import 'package:cirilla/models/product/product_variable.dart';
import 'package:cirilla/models/product_review/product_review.dart';
import 'package:cirilla/screens/press/press.dart';
import 'package:cirilla/service/constants/endpoints.dart';
import 'package:cirilla/service/modules/network_module.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/mixins/mixins.dart' as mixins;
import 'package:dio/dio.dart';

/// The RequestHelper contain all API for app request and serialize data
class RequestHelper {
  final DioClient _dioClient;

  RequestHelper(this._dioClient);

  Future<Map<String, dynamic>> getSettings() async {
    try {
      final res = await _dioClient.get(Endpoints.getSettings);

      if (res is String) {
        return jsonDecode(res);
      }

      return res;
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- Product ------------------------------------------------------------

  /// Returns list of product in response
  Future<List<Product>?> getProducts({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getProducts,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Product>? products = <Product>[];
      products = data.map((product) => Product.fromJson(product)).toList().cast<Product>();
      return products;
    } on DioException {
      rethrow;
    }
  }

  /// Retrieve a product in response
  Future<Product> getProduct({int? id, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        "${Endpoints.getProducts}/$id",
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Product.fromJson(data);
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of product in response
  Future<List<Brand>?> getBrands({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getBrands,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Brand>? brands = <Brand>[];
      brands = data.map((value) => Brand.fromJson(value)).toList().cast<Brand>();
      return brands;
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of product in response
  Future<Brand> getBrand({required int id, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        "${Endpoints.getBrands}/$id",
        cancelToken: cancelToken,
      );
      return Brand.fromJson(data);
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of product category in response
  Future<dynamic> getProductCategories({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCategories,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return data;
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of post in response
  Future<List<PostCategory>?> getPostCategories(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostCategories,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostCategory>? postCategories = <PostCategory>[];
      postCategories = data.map((post) => PostCategory.fromJson(post)).toList().cast<PostCategory>();
      return postCategories;
    } on DioException {
      rethrow;
    }
  }

  /// Returns product variable data
  Future<ProductVariable> getProductVariations({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final json = await _dioClient.get(
        Endpoints.getProductVariable,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return ProductVariable.fromJson(json);
    } on DioException {
      rethrow;
    }
  }

  /// Get attributes by terms
  Future<Attributes> getAttributes({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final json = await _dioClient.get(
        Endpoints.getAttributes,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Attributes.fromJson(json);
    } on DioException {
      rethrow;
    }
  }

  // Get Min - Max prices
  Future<ProductPrices> getMinMaxPrices({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final json = await _dioClient.get(
        Endpoints.getMinMaxPrices,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return ProductPrices.fromJson(json);
    } on DioException {
      rethrow;
    }
  }

  /// Get active hours in appointments product
  Future<Map<String, dynamic>> getActiveHours({
    Map<String, dynamic>? queryParameters,
    String? endPoint,
  }) async {
    try {
      final data = await _dioClient.get(
        endPoint ?? Endpoints.getAppointmentTimeStamp,
        queryParameters: queryParameters,
      );
      return data is Map ? data.map((key, value) => MapEntry(key.toString(), value)) : {};
    } on DioException {
      rethrow;
    }
  }

  /// Get staffs in appointments product
  Future<List> getStaffs({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getAppointmentStaffs,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return data is List ? data : [];
    } on DioException {
      rethrow;
    }
  }

  /// Get appointments product
  Future<Map<String, dynamic>> getAppointmentProduct({
    Map<String, dynamic>? queryParameters,
    required String productId,
    String? endPoint,
  }) async {
    try {
      final data = await _dioClient.get(
        "${endPoint ?? Endpoints.getAppointmentProduct}/$productId",
        queryParameters: queryParameters,
      );
      return data is Map ? data.map((key, value) => MapEntry(key.toString(), value)) : {};
    } on DioException {
      rethrow;
    }
  }

  /// get bookable day
  Future<Map<String, dynamic>> getBookableDays({
    Map<String, dynamic>? queryParameters,
    required String endPoint,
  }) async {
    try {
      final data = await _dioClient.get(
        endPoint,
        queryParameters: queryParameters,
      );
      return data is Map ? data.map((key, value) => MapEntry(key.toString(), value)) : {};
    } on DioException {
      rethrow;
    }
  }

  /// Like product video
  Future<void> likeProductVideo({
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dioClient.post(
        Endpoints.likeProductVideo,
        queryParameters: queryParameters,
        data: body,
        cancelToken: cancelToken,
      );
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- Post ---------------------------------------------------------------

  /// Returns list of post in response
  Future<List<Post>?> getPosts({
    String postType = 'posts',
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        '/wp/v2/$postType',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Post>? posts = <Post>[];
      posts = data.map((post) => Post.fromJson(post)).toList().cast<Post>();
      return posts;
    } on DioException {
      rethrow;
    }
  }

  /// Retrieve a post in response
  Future<Post> getPost({String postType = 'posts', int? id, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '/wp/v2/$postType/$id',
        cancelToken: cancelToken,
      );
      return Post.fromJson(data);
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of comment in response
  Future<List<PostComment>?> getPostComments({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostComments,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostComment>? comments = <PostComment>[];
      comments = data.map((comment) => PostComment.fromJson(comment)).toList().cast<PostComment>();
      return comments;
    } on DioException {
      rethrow;
    }
  }

  /// Write a comment
  Future<PostComment> writeComments({required Map<String, dynamic> queryParameters, CancelToken? cancelToken}) async {
    try {
      final json = await _dioClient.post(
        Endpoints.getPostComments,
        queryParameters: {
          ...queryParameters,
          'app-builder-decode': true,
        },
        cancelToken: cancelToken,
      );
      return PostComment.fromJson(json);
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of tags in response
  Future<List<PostTag>?> getPostTags({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostTags,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostTag>? tags = <PostTag>[];
      tags = data.map((comment) => PostTag.fromJson(comment)).toList().cast<PostTag>();
      return tags;
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of tags in response
  Future<List<PostAuthor>?> getPostAuthors({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostAuthor,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostAuthor>? users = <PostAuthor>[];
      users = data.map((comment) => PostAuthor.fromJson(comment)).toList().cast<PostAuthor>();
      return users;
    } on DioException {
      rethrow;
    }
  }

  /// Retrieve a post in response
  Future<PostAuthor> getPostAuthor({int? id, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        "${Endpoints.getPostAuthor}/$id",
        cancelToken: cancelToken,
      );
      return PostAuthor.fromJson(data);
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of tags in response
  Future<List<PostArchive>?> getPostArchives({CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.archives,
        cancelToken: cancelToken,
      );
      List<PostArchive>? archives = <PostArchive>[];
      archives = data.map((value) => PostArchive.fromJson(value)).toList().cast<PostArchive>();
      return archives;
    } on DioException {
      rethrow;
    }
  }

  /// Search post
  Future<List<PostSearch>?> searchPost({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.search,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostSearch>? search = <PostSearch>[];
      search = data.map((value) => PostSearch.fromJson(value)).toList().cast<PostSearch>();
      return search;
    } on DioException {
      rethrow;
    }
  }

  /// Search with plugin
  Future<List<dynamic>> searchWithPlugin({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    required String endPoint,
  }) async {
    try {
      final data = await _dioClient.get(
        endPoint,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return data;
    } on DioException {
      rethrow;
    }
  }

  /// Get amount balance
  Future<double> getAmountBalance({required String userId, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getAmountBalance}/$userId',
        queryParameters: {
          'app-builder-decode': true,
        },
        cancelToken: cancelToken,
      );
      return ConvertData.stringToDouble(data);
    } on DioException {
      rethrow;
    }
  }

  /// Get transaction wallet
  Future<List<TransactionWallet>?> getTransactionWallet({required String userId, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getTransactionWallet}/$userId',
        queryParameters: {
          'app-builder-decode': true,
        },
        cancelToken: cancelToken,
      );
      List<TransactionWallet>? result = <TransactionWallet>[];
      result = data.map((value) => TransactionWallet.fromJson(value)).toList().cast<TransactionWallet>();
      return result;
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- Media ---------------------------------------------------------------

  /// Get list media
  Future<List> getListMedia({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getMedia,
        queryParameters: {
          if (queryParameters != null) ...queryParameters,
          'app-builder-decode': true,
        },
        cancelToken: cancelToken,
      );
      return data;
    } on DioException {
      rethrow;
    }
  }

  /// Get a media
  Future<Map?> getMedia({required String mediaId, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getMedia}/$mediaId',
        queryParameters: {
          'app-builder-decode': true,
        },
        cancelToken: cancelToken,
      );
      return data;
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- Auth ---------------------------------------------------------------

  /// Login with Email or Username
  Future<Map<String, dynamic>> login({Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post(Endpoints.login, queryParameters: queryParameters);
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Register user
  Future<Map<String, dynamic>> register(Map<String, dynamic> queryParameters) async {
    try {
      final res = await _dioClient.post(Endpoints.register, queryParameters: queryParameters);
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Forgot password
  Future<dynamic> forgotPassword({String? userLogin}) async {
    try {
      final res = await _dioClient.post(Endpoints.forgotPassword, queryParameters: {'user_login': userLogin});
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Forgot password from the app
  Future<dynamic> resetPassword({String? userLogin}) async {
    try {
      final res = await _dioClient.post(Endpoints.resetPassword, queryParameters: {'user_login': userLogin});
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Verify otp forgot password
  Future<dynamic> verifyOtpResetPassword({String? userLogin, required int otp}) async {
    try {
      final res = await _dioClient.post(Endpoints.verifyOtpResetPassword, queryParameters: {
        'user_login': userLogin,
        'otp': otp,
      });
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Update password
  Future<dynamic> updatePassword({required String token, required String newPassWord}) async {
    try {
      final res = await _dioClient.post(Endpoints.updatePassword, queryParameters: {
        'token': token,
        'new_password': newPassWord,
      });
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Change password
  Future<dynamic> changePassword({Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post('${Endpoints.changePassword}?app-builder-decode=true',
          queryParameters: queryParameters);

      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Current user
  Future<Map<String, dynamic>> current() async {
    try {
      final res = await _dioClient.get(Endpoints.current, queryParameters: {'app-builder-decode': true});
      return res;
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- Digits -------------------------------------------------------------
  /// Digits login
  Future<Map<String, dynamic>> digitsLogin({required Map<String, dynamic> dataParameters}) async {
    try {
      final res = await _dioClient.post(Endpoints.digitsLogin,
          data: dataParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Digits create user
  Future<Map<String, dynamic>> digitsRegister({required Map<String, dynamic> dataParameters}) async {
    try {
      final res = await _dioClient.post(Endpoints.digitsRegister,
          data: dataParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Digits send otp
  Future<Map<String, dynamic>> digitsSendOtp(Map<String, dynamic> dataParameters) async {
    try {
      final res = await _dioClient.post(Endpoints.digitsSendOtp,
          data: dataParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Digits re send otp
  Future<Map<String, dynamic>> digitsReSendOtp(Map<String, dynamic> dataParameters) async {
    try {
      final res = await _dioClient.post(Endpoints.digitsReSendOtp,
          data: dataParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Register verify otp
  Future<Map<String, dynamic>> digitsVerifyOtp(Map<String, dynamic> dataParameters) async {
    try {
      final res = await _dioClient.post(Endpoints.digitsVerifyOtp,
          data: dataParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Delete account
  Future<Map<String, dynamic>> deleteAccount({
    Map<String, dynamic>? dataParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
  }) async {
    try {
      Map<String, dynamic> query = {
        ...?dataParameters,
        'app-builder-decode': true,
      };
      final res = await _dioClient.post(
        Endpoints.deleteAccount,
        queryParameters: query,
        data: data,
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Send opt delete account
  Future<Map<String, dynamic>> sendOptDeleteAccount({
    Map<String, dynamic>? dataParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
  }) async {
    try {
      Map<String, dynamic> query = {
        ...?dataParameters,
        'app-builder-decode': true,
      };
      final res = await _dioClient.post(
        Endpoints.sendOptDeleteAccount,
        queryParameters: query,
        data: data,
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- Token --------------------------------------------------------------

  /// Update user token
  Future<Map<String, dynamic>?> updateUserToken(String? token) async {
    try {
      final res = await _dioClient.post(
        Endpoints.updateUserToken,
        data: {'token': token},
        queryParameters: {'app-builder-decode': true},
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Update user token
  Future<Map<String, dynamic>?> removeUserToken(String? token, String? userId) async {
    try {
      final res = await _dioClient.post(
        Endpoints.removeUserToken,
        data: {'token': token, 'user_id': userId},
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Get captcha
  Future<Map?> getCaptcha({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCaptcha,
        queryParameters: queryParameters,
      );
      return data;
    } on DioException {
      rethrow;
    }
  }

  /// Validate captcha
  Future<dynamic> validateCaptcha({Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
    try {
      final res = await _dioClient.post(
        Endpoints.validateCaptcha,
        queryParameters: queryParameters,
        data: data,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Get list notification by user_id
  Future<List<MessageData>?> getListNotify({Map<String, dynamic>? queryParameters, String? userId}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getNotify}?user_id=$userId&app-builder-decode=true',
        queryParameters: queryParameters,
      );
      List<MessageData>? res = <MessageData>[];
      res = data.map((mess) => MessageData.fromJson(mess)).toList().cast<MessageData>();
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Get a notification by user_id
  Future<Map<String, dynamic>?> getANotify({int? id, String? userId}) async {
    try {
      final res = await _dioClient.get('${Endpoints.getNotify}/$id?user_id=$userId&app-builder-decode=true');
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Get unRead
  Future<Map<String, dynamic>?> getUnRead() async {
    try {
      final res = await _dioClient.get('${Endpoints.getUnRead}?app-builder-decode=true');
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Get postRead
  Future<void> putRead({Map<String, dynamic>? data}) async {
    try {
      final res = await _dioClient.post(
        '${Endpoints.putRead}?app-builder-decode=true',
        data: data,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Delete a notification by user_id
  Future<Map<String, dynamic>?> removeMessageById({String? id, String? userId}) async {
    try {
      final res = await _dioClient.delete('${Endpoints.getNotify}/$id?user_id=$userId&app-builder-decode=true');
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Delete a notification by user_id
  Future<Map<String, dynamic>?> removeAllNotify() async {
    try {
      final res = await _dioClient.delete('${Endpoints.removeAllNotify}?app-builder-decode=true');
      return res;
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- Cart ---------------------------------------------------------------
  /// Get list cart
  Future<Response<dynamic>> getCart({
    Map<String, dynamic>? params,
    Map<String, dynamic>? header,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.get(
        Endpoints.getCart,
        cancelToken: cancelToken,
        isFullResponse: true,
        queryParameters: params,
        options: Options(
          headers: {
            ...header ?? {},
          },
        ),
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Add to cart
  Future<Map<String, dynamic>> addToCart({
    required Map<String, dynamic> params,
    Map<String, dynamic>? data,
    Map<String, dynamic>? header,
  }) async {
    try {
      FormData formData = FormData.fromMap(data ?? {});
      final res = await _dioClient.post(Endpoints.addToCart,
          queryParameters: params,
          data: formData,
          options: Options(
            headers: header,
          ));
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Update quantity
  Future<Map<String, dynamic>> updateQuantity({
    String? cartKey,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
  }) async {
    try {
      final res = await _dioClient.post(
        Endpoints.updateCart,
        queryParameters: queryParameters,
        options: Options(
          headers: header,
        ),
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Select shipping cart
  Future<Map<String, dynamic>> selectShipping({String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post('${Endpoints.shippingCart}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters);
      return res;
    } on DioException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateCustomerCart({
    Map<String, dynamic>? params,
    Map<String, dynamic>? data,
    Map<String, dynamic>? header,
  }) async {
    try {
      final res = await _dioClient.post(
        Endpoints.updateCustomerCart,
        queryParameters: params,
        data: data,
        options: Options(
          headers: header,
        ),
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Apply Coupon
  Future<Map<String, dynamic>> applyCoupon({
    Map<String, dynamic>? params,
    Map<String, dynamic>? header,
  }) async {
    try {
      final res = await _dioClient.post(
        Endpoints.applyCoupon,
        queryParameters: params,
        options: Options(
          headers: header,
        ),
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Remove Coupon
    Future<Map<String, dynamic>> removeCoupon({
      Map<String, dynamic>? params,
      Map<String, dynamic>? header,
    }) async {
      try {
        final res = await _dioClient.post(
          Endpoints.removeCoupon,
          queryParameters: params,
          options: Options(
            headers: header,
          ),
        );
        return res;
      } on DioException {
        rethrow;
      }
    }

  /// Coupon list
  Future<List<Coupon>> getCouponList({Map<String, dynamic>? query}) async {
    try {
      final res = await _dioClient.get(
        Endpoints.couponList,
        queryParameters: {
          ...?query,
          'app-builder-decode': true,
        },
      );
      List<Coupon> data = <Coupon>[];
      data = res.map((value) => Coupon.fromJson(value)).toList().cast<Coupon>();
      return data;
    } on DioException {
      rethrow;
    }
  }

  /// Remove cart
  Future<Map<String, dynamic>> removeCart({
    Map<String, dynamic>? params,
    Map<String, dynamic>? data,
    Map<String, dynamic>? header,
  }) async {
    try {
      final res = await _dioClient.post(
        Endpoints.removeCart,
        queryParameters: params,
        data: data,
        options: Options(
          headers: header,
        ),
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Clean cart
  Future<bool> cleanCart({
    Map<String, dynamic>? params,
    Map<String, dynamic>? header,
  }) async {
    try {
      final res = await _dioClient.post(
          Endpoints.cleanCart,
          queryParameters: params,
          options: Options(
            headers: header,
          ),
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Checkout
  Future<dynamic> checkout({Map<String, dynamic>? queryParameters, dynamic data}) async {
    try {
      final res = await _dioClient.post(Endpoints.checkout, queryParameters: queryParameters, data: data);
      return res;
    } on DioException {
      rethrow;
    }
  }

  Future<dynamic> progressServer({
    String? cartKey,
    required Map<String, dynamic> data,
  }) async {
    Map<String, dynamic> body = Map<String, dynamic>.of(data);
    body.addAll({"cart_key": cartKey});
    try {
      final res =
          await _dioClient.post(Endpoints.progressServer, queryParameters: {"app-builder-decode": true}, data: body);
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Checkout
  Future<dynamic> gateways() async {
    try {
      final res = await _dioClient.get(Endpoints.gateways);
      return res;
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- Order --------------------------------------------------------------
  /// Get list orders
  Future<List<OrderData>?> getOrders({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getOrders,
        queryParameters: queryParameters,
      );
      List<OrderData>? orders = <OrderData>[];
      orders = data.map((order) => OrderData.fromJson(order)).toList().cast<OrderData>();
      return orders;
    } on DioException {
      rethrow;
    }
  }

  /// Get orders detail
  Future<OrderData> getOrderDetail({Map<String, dynamic>? queryParameters, int? orderId}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getOrders}/$orderId',
        queryParameters: queryParameters,
      );
      OrderData result = OrderData.fromJson(data);
      return result;
    } on DioException {
      rethrow;
    }
  }

  /// Get list orders node
  Future<List<OrderNode>?> getOrderNodes({Map<String, dynamic>? queryParameters, int? orderId}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getOrders}/$orderId/notes',
        queryParameters: queryParameters,
      );
      List<OrderNode>? orders = <OrderNode>[];
      orders = data.map((order) => OrderNode.fromJson(order)).toList().cast<OrderNode>();
      return orders;
    } on DioException {
      rethrow;
    }
  }

  /// Get cancel order
  Future<List<dynamic>> getCancelOrder() async {
    try {
      final data = await _dioClient.get(Endpoints.cancelOrder);
      return data;
    } on DioException {
      rethrow;
    }
  }

  /// Post cancel order
  Future<void> postCancelOrder({Map<String, dynamic>? dataCancel}) async {
    try {
      await _dioClient.post(
        '${Endpoints.cancelOrder}/post?app-builder-decode=true',
        queryParameters: dataCancel,
      );
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- Contact ------------------------------------------------------------
  /// Send contact or Subscription
  Future<Map<String, dynamic>> sendContact({required Map<String, dynamic> queryParameters, String? formId}) async {
    try {
      final data = await _dioClient.post('${Endpoints.contactForm7}/$formId/feedback',
          data: FormData.fromMap(queryParameters),
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return data;
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- My Account ---------------------------------------------------------
  /// Address book
  Future<List<CountryData>> getCountry({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCountries,
        queryParameters: queryParameters,
      );
      List<CountryData> countries = <CountryData>[];
      countries = data.map((country) => CountryData.fromJson(country)).toList().cast<CountryData>();
      return countries;
    } on DioException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCountryLocale({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCountryLocale,
        queryParameters: queryParameters,
      );
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {};
    } on DioException {
      rethrow;
    }
  }

  Future<AddressData> getAddress({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getAddress,
        queryParameters: queryParameters,
      );
      if (data is Map) {
        Map<String, dynamic> dataJson = data.map((key, value) => MapEntry(key.toString(), value));
        return AddressData.fromJson(dataJson);
      }
      return AddressData();
    } on DioException {
      rethrow;
    }
  }

  Future<AddressBook> getAddressBook({Map<String, dynamic>? queryParameters}) async {
    try {
      Map<String, dynamic> query = {
        ...?queryParameters,
        'app-builder-decode': true,
      };

      final data = await _dioClient.get(
        Endpoints.addressBooks,
        queryParameters: query,
      );
      if (data is Map) {
        Map<String, dynamic> dataJson = data.map((key, value) => MapEntry(key.toString(), value));
        return AddressBook.fromJson(dataJson);
      }
      return AddressBook();
    } on DioException {
      rethrow;
    }
  }

  Future<bool> makePrimaryAddressBook({Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> query = {
        ...?queryParameters,
        'app-builder-decode': true,
      };
      final result = await _dioClient.post(
        '${Endpoints.addressBooks}/make-primary',
        queryParameters: query,
        data: data,
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/x-www-form-urlencoded', // set content-length
          },
        ),
      );
      return result is Map && result['success'] == true;
    } on DioException {
      rethrow;
    }
  }

  Future<bool> deleteAddressBook({Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> query = {
        ...?queryParameters,
        'app-builder-decode': true,
      };
      final result = await _dioClient.post(
        '${Endpoints.addressBooks}/delete',
        queryParameters: query,
        data: data,
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/x-www-form-urlencoded', // set content-length
          },
        ),
      );
      return result is Map && result['success'] == true;
    } on DioException {
      rethrow;
    }
  }

  Future<Customer> postCustomer(
      {String? userId, Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> query = queryParameters != null
          ? {
              ...queryParameters,
              'app-builder-decode': true,
            }
          : {
              'app-builder-decode': true,
            };

      final res = await _dioClient.post(
        '${Endpoints.postCustomer}/$userId',
        queryParameters: query,
        data: data,
      );
      return Customer.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> postAccount(
      {String? userId, Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> query = queryParameters != null
          ? {
              ...queryParameters,
              'app-builder-decode': true,
            }
          : {
              'app-builder-decode': true,
            };

      final res = await _dioClient.post(
        '${Endpoints.postAccount}/$userId',
        queryParameters: query,
        data: data,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  Future<List<Customer>> getCustomers({
    String? userId,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.get(
        Endpoints.getCustomer,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Customer> customers = <Customer>[];
      customers = res.map((c) => Customer.fromJson(c)).toList().cast<Customer>();

      return customers;
    } on DioException {
      rethrow;
    }
  }

  Future<Customer> getCustomer({
    String? userId,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _dioClient.get(
        '${Endpoints.getCustomer}/$userId',
        queryParameters: queryParameters,
      );
      return Customer.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<Customer> createCustomer({
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final res = await _dioClient.post(
        Endpoints.getCustomer,
        queryParameters: queryParameters,
        data: data,
      );
      return Customer.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  Future<Customer> updateCustomer({
    String? userId,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final res = await _dioClient.put(
        "${Endpoints.getCustomer}/$userId",
        queryParameters: queryParameters,
        data: data,
      );
      return Customer.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  // ------------------------------------------------ Reviews ----------------------------------------------------------
  /// Get list review
  Future<List<ProductReview>?> getReviews({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(Endpoints.getReviews, queryParameters: queryParameters);

      List<ProductReview>? reviews = <ProductReview>[];
      reviews = data.map((review) => ProductReview.fromJson(review)).toList().cast<ProductReview>();
      return reviews;
    } on DioException {
      rethrow;
    }
  }

  /// Add review
  Future<ProductReview> writeReviews({Map<String, dynamic>? queryParameters, dynamic data}) async {
    try {
      final res = await _dioClient.post(Endpoints.writeReview, data: data, queryParameters: queryParameters);
      return ProductReview.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  /// Rating count
  Future<RatingCount> getRatingCount({Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.get(Endpoints.ratingCount, queryParameters: queryParameters);
      return RatingCount.fromJson(res);
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of vendor in response
  Future<List<Vendor>?> getVendors({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getVendor,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Vendor>? vendors = <Vendor>[];
      vendors = data.map((comment) => Vendor.fromJson(comment)).toList().cast<Vendor>();
      return vendors;
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of id category vendor in response
  Future<List<int>?> getCategoryVendor({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCategoryVendor,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<int> result = <int>[];
      for (int i = 0; i < data.length; i++) {
        result.add(ConvertData.stringToInt(data[i]));
      }

      return result;
    } on DioException {
      rethrow;
    }
  }

  /// Returns data of page in response
  Future<PageData> getPageDetail({int? idPage, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get('${Endpoints.getPage}/$idPage', cancelToken: cancelToken);
      return PageData.fromJson(data);
    } on DioException {
      rethrow;
    }
  }

  /// Returns list of downloads in response
  Future<List<Download>?> getDownloads(
      {required int userId, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getCustomer}/$userId/downloads',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Download>? downloads = <Download>[];
      downloads = data.map((comment) => Download.fromJson(comment)).toList().cast<Download>();
      return downloads;
    } on DioException {
      rethrow;
    }
  }

  // ---------------------------------------------- Wishlist ---------------------------------------------------------------
  Future<dynamic> getWishlistByUser({required int userId}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getWishlistByUser}/$userId',
        queryParameters: {
          'app-builder-decode': true,
        },
      );
      return data;
    } on DioException {
      rethrow;
    }
  }

  Future<dynamic> getWishlistProductShareKey({
    required String shareKey,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      List<dynamic> data = await _dioClient.get(
        '${Endpoints.wishlistProduct}/$shareKey/get_products',
        queryParameters: queryParameters,
      );
      return data;
    } on DioException {
      rethrow;
    }
  }

  Future<void> addWishlistProductShareKey({required String shareKey, required int productId}) async {
    try {
      await _dioClient.post('${Endpoints.wishlistProduct}/$shareKey/add_product', queryParameters: {
        'app-builder-decode': true,
      }, data: {
        'product_id': productId
      });
    } on DioException {
      rethrow;
    }
  }

  Future<void> removeWishlistProduct({required int productId}) async {
    try {
      await _dioClient.get(
        '${Endpoints.removeWishlistProduct}/$productId',
        queryParameters: {
          'app-builder-decode': true,
        },
      );
    } on DioException {
      rethrow;
    }
  }
  // ---------------------------------------------- Press( Buddypress + Bbpress + Better Messages )  ------------------------------------------------------------

  /// Get list member Buddypress
  Future<List<BPMember>?> getMembers({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getBuddypressMember,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<BPMember>? members = <BPMember>[];
      members = data.map((e) => BPMember.fromJson(e)).toList().cast<BPMember>();
      return members;
    } on DioException {
      rethrow;
    }
  }

  /// Get a member Buddypress
  Future<BPMember?> getMember({
    required int id,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        "${Endpoints.getBuddypressMember}/$id",
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return BPMember.fromJson(data);
    } on DioException {
      rethrow;
    }
  }

  /// get friends Buddypress
  Future<List<int>?> getFriends({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.get(
        Endpoints.getBuddypressFriend,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<int>? data;
      if (res is List) {
        data = res.map((v) => ConvertData.stringToInt(mixins.get(v, ["initiator_id"]))).toList().cast();
      }
      return data;
    } on DioException {
      rethrow;
    }
  }

  /// Add friend Buddypress
  Future<dynamic> addFriend({
    Map<String, dynamic>? queryParameters,
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.post(
        Endpoints.getBuddypressFriend,
        queryParameters: queryParameters,
        data: data,
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// accept friend Buddypress
  Future<dynamic> acceptFriend({
    required int id,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.put(
        "${Endpoints.getBuddypressFriend}/$id",
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// remove friend Buddypress
  Future<dynamic> removeFriend({
    required int id,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.delete(
        "${Endpoints.getBuddypressFriend}/$id",
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Get banner member Buddypress
  Future<String?> getBannerMember({
    required int id,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.get(
        "${Endpoints.getBuddypressMember}/$id/cover",
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return res is List && res.isNotEmpty && res[0] is Map ? res[0]["image"] : null;
    } on DioException {
      rethrow;
    }
  }

  /// Get list conversation Buddypress - private message
  Future<List<BPConversation>?> getConversations({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getBuddypressMessage,
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
      );
      List<BPConversation>? conversations = <BPConversation>[];
      conversations = data.map((m) => BPConversation.fromJson(m)).toList().cast<BPConversation>();
      return conversations;
    } on DioException {
      rethrow;
    }
  }

  /// Get list group Buddypress
  Future<List<BPGroup>?> getGroups({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getBuddypressGroup,
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        cancelToken: cancelToken,
      );
      List<BPGroup>? groups = <BPGroup>[];
      groups = data.map((m) => BPGroup.fromJson(m)).toList().cast<BPGroup>();
      return groups;
    } on DioException {
      rethrow;
    }
  }

  /// Get a group Buddypress
  Future<BPGroup?> getGroup({
    required int id,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        "${Endpoints.getBuddypressGroup}/$id",
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        cancelToken: cancelToken,
      );
      return data is List && data.isNotEmpty ? BPGroup.fromJson(data[0]): null;
    } on DioException {
      rethrow;
    }
  }

  /// Get list member group Buddypress
  Future<List<BPMemberGroup>?> getMemberGroups({
    int? id,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        "${Endpoints.getBuddypressGroup}/$id/members",
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        cancelToken: cancelToken,
      );
      List<BPMemberGroup>? members = <BPMemberGroup>[];
      members = data.map((m) => BPMemberGroup.fromJson(m)).toList().cast<BPMemberGroup>();
      return members;
    } on DioException {
      rethrow;
    }
  }

  /// Get list activity Buddypress
  Future<List<BPActivity>?> getActivities({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getBuddypressActivity,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<BPActivity>? activities = <BPActivity>[];
      activities = data.map((e) => BPActivity.fromJson(e)).toList().cast<BPActivity>();
      return activities;
    } on DioException {
      rethrow;
    }
  }

  /// Get an activity Buddypress
  Future<BPActivity?> getActivity({
    required int id,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _dioClient.get(
        "${Endpoints.getBuddypressActivity}/$id",
        queryParameters: queryParameters,
      );
      return res is List && res.isNotEmpty ? BPActivity.fromJson(res[0]) : res is Map ? BPActivity.fromJson(res.cast()) : null;
    } on DioException {
      rethrow;
    }
  }

  /// Create activity Buddypress
  Future<List<BPActivity>?> createActivity({
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final res = await _dioClient.post(
        Endpoints.getBuddypressActivity,
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        data: data,
      );

      List<BPActivity>? activities = <BPActivity>[];
      if (res is List && res.isNotEmpty) {
        activities = res.map((m) => BPActivity.fromJson(m)).toList().cast<BPActivity>();
      }
      return activities;
    } on DioException {
      rethrow;
    }
  }

  /// Update favorite activity Buddypress
  Future<dynamic> updateFavoriteActivity({
    required int id,
  }) async {
    try {
      final res = await _dioClient.post(
        "${Endpoints.getBuddypressActivity}/$id/favorite",
        queryParameters: {"context": "edit", "app-builder-decode": true},
      );

      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Get list message Buddypress - private message
  Future<List<BPMessage>?> getMessages({
    required int id,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _dioClient.get(
        '${Endpoints.getBuddypressMessage}/$id',
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
      );

      List<BPMessage>? messages = <BPMessage>[];
      if (res is List && res.isNotEmpty && res[0] is Map && res[0]["messages"] is List) {
        messages = res[0]["messages"].map((m) => BPMessage.fromJson(m)).toList().cast<BPMessage>();
      }
      return messages;
    } on DioException {
      rethrow;
    }
  }

  /// Create message Buddypress - private message
  Future<List<BPMessage>?> createMessage({
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final res = await _dioClient.post(
        Endpoints.getBuddypressMessage,
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        data: data,
      );

      List<BPMessage>? messages = <BPMessage>[];
      if (res is List && res.isNotEmpty && res[0] is Map && res[0]["messages"] is List) {
        messages = res[0]["messages"].map((m) => BPMessage.fromJson(m)).toList().cast<BPMessage>();
      }
      return messages;
    } on DioException {
      rethrow;
    }
  }

  /// Read message Buddypress - private message
  Future<BPConversation?> readMessage({
    required int id,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final res = await _dioClient.put(
        '${Endpoints.getBuddypressMessage}/$id',
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        data: data,
      );
      Map<String, dynamic> dataJson = res is List && res.isNotEmpty && res[0] is Map ? res[0] : {};
      return BPConversation.fromJson(dataJson);
    } on DioException {
      rethrow;
    }
  }

  /// Get list forum bbPress
  Future<List<BBPForum>?> getForums({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.get(
        Endpoints.getBbpressForum,
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        cancelToken: cancelToken,
      );
      List<BBPForum> forums = <BBPForum>[];
      forums = res.map((m) => BBPForum.fromJson(m)).toList().cast<BBPForum>();
      return forums;
    } on DioException {
      rethrow;
    }
  }

  /// Get a forum bbPress
  Future<Map?> getForum({
    required int id,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.get(
        "${Endpoints.getBbpressForum}/$id",
        queryParameters: {...?queryParameters, "app-builder-decode": true},
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Get list topic bbPress
  Future<Map?> getTopics({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.get(
        Endpoints.getBbpressTopic,
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Get a topic bbPress
  Future<Map?> getTopic({
    required int id,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.get(
        "${Endpoints.getBbpressTopic}/$id",
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Create topic bbPress
  Future<dynamic> createTopic({
    required int idForum,
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.post(
        "${Endpoints.getBbpressForum}/$idForum",
        queryParameters: {"app-builder-decode": true},
        data: data,
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Create reply topic bbPress
  Future<dynamic> createReplyTopic({
    required int idTopic,
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.post(
        "${Endpoints.getBbpressTopic}/$idTopic",
        queryParameters: {"app-builder-decode": true},
        data: data,
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }
  /// Create reply in reply bbPress
  Future<dynamic> createReply({
    required int idReply,
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.post(
        "${Endpoints.getBbpressReply}/$idReply",
        queryParameters: {"app-builder-decode": true},
        data: data,
        cancelToken: cancelToken,
      );
      return res;
    } on DioException {
      rethrow;
    }
  }

  /// Get list conversation - Better messages
  Future<List<BMConversation>?> getConversationsBM({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _dioClient.get(
        Endpoints.getBMThreads,
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        cancelToken: cancelToken,
      );

      List<BMConversation> conversations = <BMConversation>[];

      if (res is Map) {
        List threads = res["threads"] is List ? res["threads"] : [];
        List users = res["users"] is List ? res["users"] : [];
        List messages = res["messages"] is List ? res["messages"] : [];

        conversations = threads.map((m) => BMConversation.fromJson({
          ...m,
          "participants": users.where((u) => m["participants"] is List && m["participants"].contains(u["user_id"])).toList(),
          "lastMessage": messages.firstWhere((element) => element["thread_id"] == m["thread_id"], orElse: () => null),
        })).toList().cast<BMConversation>();
      }

      return conversations;
    } on DioException {
      rethrow;
    }
  }

  /// Create a conversation - Better messages
  Future<bool?> createConversationBM({
    Map<String, dynamic>? queryParameters,
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
     await _dioClient.post(
        "${Endpoints.getBMThread}/new",
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        data: data,
        cancelToken: cancelToken,
     );
     return true;
    } on DioException {
      rethrow;
    }
  }

  /// Get data chat - Better messages
  Future<BMChat?> getChatBM({
    required int id,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      dynamic res = await _dioClient.post(
        "${Endpoints.getBMThread}/$id",
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        cancelToken: cancelToken,
      );

      if (res is Map && res["threads"] is List  && res["threads"].isNotEmpty) {
        dynamic thread = res["threads"][0];
        return  BMChat.fromJson({
          ...thread,
          "participants": res["users"] is List ? res["users"] : [],
          "messages": res["messages"] is List ? res["messages"] : [],
        });
      }

      return null;
    } on DioException {
      rethrow;
    }
  }

  /// Send message chat - Better messages
  Future<BMMessage?> sendMessageChatBM({
    required int id,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      dynamic res = await _dioClient.post(
        "${Endpoints.getBMThread}/$id/send",
        queryParameters: {...queryParameters ?? {}, "app-builder-decode": true},
        data: data,
        cancelToken: cancelToken,
      );

      dynamic messages = mixins.get(res, ["update", "messages",]);

      if (messages is List && messages.isNotEmpty && messages[0] is Map) {
        return BMMessage.fromJson(messages[0].cast<String, dynamic>());
      }

      return null;
    } on DioException {
      rethrow;
    }
  }
}
