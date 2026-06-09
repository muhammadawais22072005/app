class Product {
  final String id;
  final String title;
  final String description;
  final String category;
  final double basePrice;
  final double rating;
  final int reviewsCount;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.basePrice,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    double? basePrice,
    double? rating,
    int? reviewsCount,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      basePrice: basePrice ?? this.basePrice,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  static final List<Product> mockProducts = [
    Product(
      id: 'spiced_amber_latte',
      title: 'Spiced Amber Latte',
      description: 'A seasonal masterpiece infused with toasted cardamom, organic maple syrup, and our signature dark espresso blend.',
      category: 'Latte',
      basePrice: 5.50,
      rating: 4.9,
      reviewsCount: 184,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC84287SVdMdwVivHcAu27xheunvjhVyXRH_i1XmWQVRz0G-yhsstB2T-WP-_20ezz9OMTKxHcJjTMEB0Gjn3kgLhfUPGbnvZVGN_SQIprD4dNN29w_VYFfpvTxuVIHip0BZLGdTgnaItv1UtAE9xnI3Qt7DKyJNzzDahv0s-2o0KdY0N14Hty1nNAtknRo-kVG7T9nJKB_BY-PCn1YajUICyqO5xT6g2q53QjGnquMSLD7xUwpPpIfD6P5jDUcCMYmJCRXzvUCB8Hu',
    ),
    Product(
      id: 'classic_espresso',
      title: 'Classic Espresso',
      description: 'Rich, intense, pure coffee essence brewed in pressure.',
      category: 'Coffee',
      basePrice: 3.50,
      rating: 4.7,
      reviewsCount: 92,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCOXRx25ZeCkjXJ2ECwPHd5AghK_zv2wbVnRoRmQsYQMtusggtBkIDTD3uPeF6_PHUXh_fMClmJ--9k-6OulkKXVJMnrNUrKaNOqZumALF3usm_PMUSdvJCz_IKkXo060yG_OvQJk_-jBS136wlOIHyJO0RjXrrMSkoyH4YDs0HP1jj3I5zqWHP60Ad_mgvyCkciHs_YE8k1gTg3iOyULOCTIARDO9fcx6hIYRsvrRm87WkxcuUhGNrCQc4vr48xwL6QWZkAdWEgyjh',
    ),
    Product(
      id: 'caramel_macchiato',
      title: 'Caramel Macchiato',
      description: 'A luxurious milk drink with caramels and signature dark roast espresso.',
      category: 'Latte',
      basePrice: 5.25,
      rating: 4.8,
      reviewsCount: 142,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCewV5NNpHinAA040xwQERrW6pBPkdVyr7D5dVOB1413PcRLzbr9NYJ5AaE3JojF7HMB1OSW_9ClZV3392GTFiSViGeAlxiQfO7AOImh2KW_Adywb2caIITKaXbm-G4ppEIE0Y-3CAIg9u9jFmMzxChidIid2DGvbhhz5jawsX2tnARyDQc1XTWhp9Ra4awtgFYCkX7iWo2sh4o-yhUoIMsK_Po9FitSLWGZEIP1FgR6d621Lkn9nNZ79EyqE8WnVmqygbEmldcwBGK',
    ),
    Product(
      id: 'vanilla_bean_frappe',
      title: 'Vanilla Bean Frappe',
      description: 'A creamy blend of real Madagascar vanilla beans, milk, and ice, topped with whipped cream.',
      category: 'Frappe',
      basePrice: 5.50,
      rating: 4.8,
      reviewsCount: 124,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDDBMaeFV4eQLUaRohS5-x41syWGxvrHXsC06Zv379v_1YOzSX-zykCqHNaZL0oXpERXQ5HoGq38B230BlJa3V-DD57_geOTTt9vU5NilyScIeFony_vgNjot69dbbEvmCX12V7nG8dASsSjbSN3S56JdLi1wwvkIDiTzj7smgrTDQVznRFHISdEUvYKomziwOnl4PfnsCVhKrm8eonHKiilB3ljXmWNdxiTAzNurdBUyNZxU_MkSPntgRAZMp0fiWcbMR60IhBugzg',
    ),
    Product(
      id: 'americano',
      title: 'Americano',
      description: 'Bold espresso softened with hot water.',
      category: 'Coffee',
      basePrice: 3.50,
      rating: 4.5,
      reviewsCount: 76,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDjjTHgXM3JM04MQgw-Scw6MK6--ICmuh8DlBtcFaf00oN_qq3Vfjrhrtn669RakjAyweJVK5Dg_JTQPlTCj0qBD85SUWB-BlP-FP1TfTA_DXOe-VPBSKT6HIyfpHizqpX0p0Ed5MvpSLSJ_gcdWknju62UXajKmcSysycTvglaOXwJ2YHfe3RoexK4qPmbMbT7RTCYuNF2NALOdsq1jU3CIWLSVUvIxMEReWuUMyLcV7fkd9a-Hm1CD2nCHfCHBNVyJI5n8OON7QfG',
    ),
    Product(
      id: 'cappuccino',
      title: 'Cappuccino',
      description: 'Perfect balance of espresso and steamed milk.',
      category: 'Coffee',
      basePrice: 4.50,
      rating: 4.8,
      reviewsCount: 168,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCz5vdvsjhgCo11mMzCJEl4tMjtd7wQp6fEJiRp2xR5MO7GfZVzMAfQD_av1_qF7cXi6dEK5mYUSA7As0FLadaTCkWmWX063ptDidT1lDJl0r3y9scIFQ_qRsXyHlmCwHIwMVWVYuu9UqDPgNMuA0hstTaynhUfJKfvUsYCwP1PM7nzwzSagQQu018jdoX3TrLxLowCNF8f8x_GaEBfCBQSH2Rs44AtuqgCGptXUUqIixpooQsAwrXx0HZZx3cqaee6MBLazEsEHT9E',
    ),
    Product(
      id: 'flat_white',
      title: 'Flat White',
      description: 'Velvety smooth micro-foam over rich espresso.',
      category: 'Coffee',
      basePrice: 4.75,
      rating: 4.7,
      reviewsCount: 110,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAZYHYn2Xa9jN8DJz2Jneha81berelyH9Humv2LDki3Z2uG6R7kkgGlJf4eubgAYaDBJEm1yJm6ysaKNHLIM0fX7sk5oieleiHE8SdK5_zjEadgZnHuw_dspdHC_XgYnJBKCLuSMiZlOezBFwgiaGKeTDr1w4oF5YYxW8yBrabagZlYPAjgNdN-OyWigvM5f2DWXwrDbv2a9xznbEjAAezb0UYejMdOHJ2r-MCmoUGi0P0rOgRCJwVWleGZ4RUejdieyrPFseSM2xii',
    ),
    Product(
      id: 'black_coffee',
      title: 'Black Coffee',
      description: 'Classic, smooth, medium-roast blend.',
      category: 'Coffee',
      basePrice: 3.00,
      rating: 4.6,
      reviewsCount: 68,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDU_GpjyKi49p5OqJsT0wLCyKyx-yJwYXME2tDfmZpLqgL0Fr2F957PlUrKRFNPWZGpyIlz9ZmA1nSagBlxy_gxDaEjEFLh3QD8bDIBL-6jWXdwoxkAzlOW_exxDev4nhlbNRTOqQK_nlXO8tkc4cCBtgx5jiQh5j_0pAdr235r_3p5BfqQyOtFmNlrGZw_uvGNXG8_nX1KQRTUiZSvs7vJVmhjSMs0cu9BeOrbk75o_alTmXe_6TJcg5IR_5x5h2at8GWVVUHnAxCf',
    ),
  ];
}
