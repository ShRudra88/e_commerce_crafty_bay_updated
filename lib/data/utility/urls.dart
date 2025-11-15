class Urls {
 // static const String _baseUrl = 'http://ecom-api.teamrabbil.com/api';
  //static const String _baseUrl = 'https://fakestoreapi.com';
  static const String _baseUrl = 'https://ecom-rs8e.onrender.com/api';


  static String sentEmailOtp(String email) => '$_baseUrl/auth/login/$email';

  static String verifyOtp(String email, String otp) =>
      '$_baseUrl/auth/verify-otp/$email/$otp';

  static String readProfile = '$_baseUrl/auth/profile';
  static String createProfile = '$_baseUrl/auth/signup';
  static String homeBanner = '$_baseUrl/ListProductSlider';
  static String categoryList = '$_baseUrl/CategoryList';
  static String popularProduct = '$_baseUrl/ListProductByRemark/Popular';
  static String specialProduct = '$_baseUrl/ListProductByRemark/Special';
  static String newProduct = '$_baseUrl/ListProductByRemark/New';

  static String productsByCategory(int categoryId) =>
      '$_baseUrl/ListProductByCategory/$categoryId';

  static String productDetails(int productId) =>
      '$_baseUrl/ProductDetailsById/$productId';
  static String addToCart = '$_baseUrl/CreateCartList';
  static String cartList = '$_baseUrl/CartList';
  static String createInvoice = '$_baseUrl/InvoiceCreate';
}