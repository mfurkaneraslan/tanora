# TANORA — Flutter başlangıç sürümü

**Yedi parça. Sonsuz olasılık.**

Koyu lacivert tema, renkli yedi parçalı tangram çizimi ve üç mod: Classic, Minimal Moves, Memory.

## Çalıştırma

Doğrulanan ortam: Flutter 3.47.1 stable / Dart 3.13.1.

```sh
flutter pub get
flutter run -d chrome
```

Android cihaz/emülatör için `flutter run`; iOS için macOS, Xcode ve iOS araç zinciri gerekir. Android ve iOS platform iskeletleri oluşturulmuştur; bu teslimde mobil cihaz derlemesi yapılmamıştır. Web release derlemesi başarıyla doğrulanmıştır.

## Kapsam

- Ana menü → modun bölüm listesi → bölüm önizlemesi → geri dönüş.
- Her modda 30 bölüm yuvası; ilk bölüm açık, diğerleri önceki bölüm tamamlanınca açılır.
- Son seçilen mod/bölüm ve en iyi yıldızlar sürümlü yerel tercihlerde saklanır.
- Ana menüde son seçilen bölüme devam bağlantısı.
- Kayıt okuma/yazma hatasında açıklama gösterilir; uygulama açık kalır.
- Daily, hesap, backend, uzaktan kayıt ve database yok.

Classic artık oynanabilir: ilk ev silüeti 3 üçgenle tamamlanır. Sonraki bölümlerde aynı silüetin en büyük üçgeni ikiye bölünür; bölüm 2'de 4, bölüm 30'da 32 parça vardır. Parçalar alttaki tepsiden sürüklenir, tepside de hedefle aynı boyuttadır ve tutulunca boyutu değişmez ve hedefe 22 mantıksal piksel yaklaşınca oturur. Yanlış bırakılan parça tepsiye döner. Bu başlangıç serisinde döndürme yoktur.

Tüm parçalar yerleşince sonuç yerel kayda yazılır: hatasız 3 yıldız, en fazla 3 ek hamle 2 yıldız, daha fazlası 1 yıldız. Sonraki bölüm açılır. Minimal Moves ve Memory henüz önizlemedir. Gezinme düğmelerinde tangram üçgeni kullanılır.

Önceki konuşmadan görsel ek alınamadığından tasarım metindeki koyu lacivert + canlı renkler tarifinden oluşturuldu. Çizimler Flutter CustomPainter ile üretilir; harici görsel/font indirme gerekmez. Mobil uygulama çalışma sırasında ağ servisine ihtiyaç duymaz. Web önizlemesinin ilk yüklenmesi sunucu gerektirir; PWA/offline web desteği bu kapsamda değildir.

## Proje yapısı

```text
lib/
  main.dart                       Başlangıç ve kayıt yükleme
  app.dart                        Material tema ve uygulama
  models/game_mode.dart           Üç modun tanımı
  data/progress_store.dart        Yerel kayıt, yıldızlar ve kilitler
  screens/home_screen.dart        Ana menü
  screens/level_select_screen.dart Bölüm seçimi
  screens/level_preview_screen.dart Oyun alanı önizlemesi
  widgets/tangram_art.dart        Yedi parçalı çizim
 test/app_test.dart               Kayıt ve gezinme testleri
 android/                        Android proje iskeleti
 ios/                            iOS proje iskeleti
 web/                            Web başlatıcı
 pubspec.yaml                    Bağımlılıklar
 pubspec.lock                    Sabitlenmiş paket sürümleri
```

## Kontroller

```sh
flutter analyze
flutter test
flutter build web --release
```

9 test geçti; Classic geometri bütünlüğü, 30 bölümün çözülebilirliği, yanlış bırakma ve gerçek sürüklemeyle tamamlama da doğrulandı. Önceki kontroller: kayıt tekrar yükleme, mod izolasyonu, en iyi skorun korunması, kilitli bölüme erişim reddi, bozuk/yazılamayan kayıt, her üç modun ileri/geri gezinmesi ve 320 px ekranda büyütülmüş yazı. Tarayıcıda 390 × 844 boyutunda ana menü ve bölüm ekranı görsel olarak kontrol edildi.

Yerel kayıt için SharedPreferencesAsync kullanılır: https://pub.dev/documentation/shared_preferences/latest/shared_preferences/SharedPreferencesAsync-class.html . Uygulama kaldırılması veya tarayıcı verilerinin temizlenmesi ilerlemeyi silebilir; cihazlar arası senkronizasyon yoktur.

## Sonraki aşama

Yeni silüetler, isteğe bağlı döndürme ve Minimal Moves / Memory oyun mekanikleri.

## GitHub Pages

Test adresi: https://mfurkaneraslan.github.io/tanora/
Kaynak depo: https://github.com/mfurkaneraslan/tanora

Pages yayını `gh-pages` dalının kök dizininden yapılır. `main` Flutter kaynaklarını içerir. Yayını güncellemeden önce testleri çalıştırın ve `flutter build web --release --base-href /tanora/` ile derleyin; `build/web` içeriğini `.nojekyll` dosyasıyla birlikte `gh-pages` dalına yayınlayın. Yalnızca `main` dalını güncellemek canlı sürümü değiştirmez.

Görünen ürün adı TANORA olarak yenilendi. Mevcut yerel kayıtları korumak için dahili `tangram.progress.v1` kayıt anahtarı değişmedi.

Web derlemesinden sonra `python tool/version_web.py` çalıştırın. Bu adım ana uygulama ve yükleyici dosyalarına içerik bazlı ad verir; eski tarayıcı önbelleğinin farklı sürümleri karıştırmasını önler.
