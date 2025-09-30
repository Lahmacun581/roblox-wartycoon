# 🎮 Roblox Game Scripts Collection

Modern ve gelişmiş Roblox oyun scriptleri koleksiyonu. ESP, Teleport, Auto-Farm ve daha fazlası!

## 📜 Quick Load Scripts

```lua
-- AdorHUB v2.0 (Universal)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lahmacun581/roblox-wartycoon/main/adorhub.lua"))()

-- Türk Sohbet Oyunu
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lahmacun581/roblox-wartycoon/main/turksohbet.lua"))()

-- Military Tycoon (Coming Soon)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lahmacun581/roblox-wartycoon/main/militarytycoon.lua"))()
```

## 📁 İçerik

### 🔫 War Tycoon GUI (`warfare.lua`)
Gelişmiş War Tycoon oyun scripti - Para, ESP, Teleport ve bypass özellikleri

**Özellikler:**
- 💰 **Auto Cash/Money Scanner** - Otomatik para RemoteEvent tarayıcı
- 👁️ **ESP (Player Visibility)** - Oyuncu görünürlük sistemi
  - İsim gösterimi
  - Mesafe gösterimi (studs)
  - Gerçek zamanlı güncelleme
- 🚀 **Smooth Teleport** - Anti-cheat bypass ile teleport
  - Oyuncu listesi
  - Tek tıkla TP
  - Kademeli hareket (50 stud adımlar)
- 🛡️ **Anti-Detection** - Bypass mekanizmaları
  - Randomized timing
  - Smooth movement simulation
  - Natural delays
- 🎨 **Modern GUI** - 480x420 boyutunda, sürüklenebilir
- 📋 **RemoteEvent Explorer** - Tüm RemoteEvent'leri listele ve seç

### 👑 Royale High GUI (`royalehigh.lua`)
Royale High için gelişmiş araç seti (WIP)

**Özellikler:**
- 🔍 **Remote Spy** - RemoteEvent/Function yakalayıcı
- 💎 **Diamond/Currency Scanner** - Para event'lerini bul
- 🎯 **Quick Actions** - Hızlı artış butonları (+1, +100, +1000)
- 📝 **Flexible Args** - JSON ve basit argüman desteği
- 🎨 **FOV Circle** - Opsiyonel görüş alanı göstergesi

## 🚀 Kullanım

### Kurulum
1. Bir Roblox executor kullanın (Synapse, KRNL, vb.)
2. İstediğiniz script dosyasını açın
3. Script içeriğini kopyalayın
4. Executor'a yapıştırın ve çalıştırın

### War Tycoon Kullanımı

#### 💰 Para Ekleme
```lua
1. "Scan Cash/Money" butonuna tıklayın
2. Bulunan RemoteEvent'ler listelenir
3. İlk event otomatik seçilir
4. "Add $100000" ile para gönderin
```

#### 👁️ ESP Kullanımı
```lua
1. "ESP: Kapalı" butonuna tıklayın
2. Tüm oyuncuların üstünde isim ve mesafe görünür
3. Tekrar tıklayarak kapatın
```

#### 🚀 Teleport Kullanımı
```lua
1. Sol alttaki listeden oyuncu seçin
2. Tıklayın ve smooth TP başlar
3. "Yenile" ile listeyi güncelleyin
```

## ⚠️ Uyarılar

### Güvenlik
- Bu scriptler **eğitim amaçlıdır**
- Kullanım riski size aittir
- Hesap banlanma riski vardır
- Resmi olmayan scriptler kullanmak Roblox ToS'u ihlal eder

### Bypass Özellikleri
- ✅ Smooth teleport (kademeli hareket)
- ✅ Random delays (rastgele gecikmeler)
- ✅ Natural movement simulation
- ⚠️ Sunucu taraflı kontroller bypass edilemez
- ⚠️ Aşırı kullanım tespit edilebilir

## 🛠️ Geliştirme

### Gereksinimler
- Roblox Studio (test için)
- Lua bilgisi
- Roblox executor (çalıştırma için)

### Katkıda Bulunma
1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/YeniOzellik`)
3. Commit yapın (`git commit -m 'Yeni özellik eklendi'`)
4. Push edin (`git push origin feature/YeniOzellik`)
5. Pull Request açın

## 📝 Lisans

Bu proje eğitim amaçlıdır. Ticari kullanım yasaktır.

## 🔗 Bağlantılar

- [Roblox](https://www.roblox.com/)
- [War Tycoon](https://www.roblox.com/games/4639625707/)
- [Royale High](https://www.roblox.com/games/735030788/)

## 📧 İletişim

Sorularınız için GitHub Issues kullanın.

---

**⚠️ DİKKAT:** Bu scriptleri kullanarak Roblox Kullanım Şartlarını ihlal edebilirsiniz. Kullanım sorumluluğu size aittir.
