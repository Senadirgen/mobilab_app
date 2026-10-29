# mobilab_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## ✨ Eklenen Bonus Özellikler

- **Sayfalama ("Daha Fazla Yükle" Butonu):** Liste altındaki buton ile dinamik sayfalama ve veri yükleme.
- **Açık / Koyu Tema (Dark Mode):** AppBar üzerindeki buton ile aydınlık/karanlık mod geçişi.
- **Kategori Filtreleme Chips:** Etkinliklerin hızlıca kategorilerine göre filtrelenebilmesi.

## Uygulamanın Nasıl Çalıştırılacağı

## Kurulum Adımları

1. **Gerekli paketleri yükleyin:**
   ```bash
   flutter pub get
   Uygulamayı Chrome üzerinde çalıştırma:
   flutter run -d chrome
   Projede, kodların daha düzenli ve anlaşılır olması için Feature-First ve Clean Architecture yaklaşımları kullanılmıştır.
- Modülerlik: Her özellik kendi kodlarıyla birlikte ayrı bir yerde tutulur. Böylece projeyi geliştirmek ve düzenlemek kolaylaşır.
- Test Edilebilirlik: BLoC sayesinde uygulamanın çalışma mantığı, ekrandaki tasarımdan ayrılır. Bu da kodları test etmeyi kolaylaştırır.
- Hata İzolasyonu: API istekleri ve yerel depolama işlemleri ayrı katmanlarda tutulur. Böylece bir yerde hata olduğunda sorunun kaynağını bulmak daha kolay olur.
lib/
├── core/                       # Proje genelinde ortak kullanılan yapılar
│   └── network/                # ApiClient (Dio) ve ortak hata yönetimi
└── features/
    └── events/                 # Etkinlik modülü
        ├── data/               # Veri katmanı (Model'ler, Repositories)
        └── presentation/       # Arayüz katmanı (BLoC, Ekranlar, Widget'lar)


## AI Nasıl Kullanıldı? (Araçlar, Kurallar ve Örnek Promptlar)
Proje geliştirme sürecinde Gemini, kod yazma ve karşılaşılan hataları çözme konusunda yardımcı bir araç olarak kullanılmıştır. Kod yapısını oluşturmak, hataları anlamak ve uygulamayı geliştirmek için adım adım sorular sorulmuştur.

Kullanılan Araçlar ve Yaklaşım
- Araç: Gemini.
- Yaklaşım: Klasör yapısını oluşturmak, API'den gelen verileri düzenlemek, BLoC yapısını geliştirmek ve hataları çözmek için yapay zekâdan yardım alınmıştır.
Örnek Promptlar
1. "Flutter'da Dio, BLoC ve SharedPreferences kullanarak düzenli bir klasör yapısı oluştur."

2. "API'den gelen veriler bazen farklı formatlarda geliyor. Bu verileri hata almadan nasıl işleyebilirim?"