# 🛡️ Řešení problému s ověřením aplikace

## ⚠️ **Chyba: "Společnosti Apple se nepodařilo ověřit..."**

Toto je běžný problém s nepodepsanými aplikacemi na macOS. Máme několik řešení:

## 🔓 **Okamžité řešení - Otevření aplikace:**

### **Krok 1:** Pravé tlačítko na `MP3Joiner.app`
### **Krok 2:** Vyberte **"Otevřít"**
### **Krok 3:** Klikněte **"Otevřít"** v dialogu

## 🛠️ **Trvalé řešení - Podepsání aplikace:**

### **Problém:**
- Aplikace je podepsaná pouze "Development" certifikátem
- Pro distribuci potřebujeme "Distribution" certifikát
- Apple Gatekeeper blokuje neověřené aplikace

### **Řešení:**

#### **1. 🔑 Apple Developer Account**
- Potřebujete placený Apple Developer Account ($99/rok)
- Generujte "Distribution" certifikát
- Nastavte správné provisioning profile

#### **2. 📦 Notarizace**
- Nahrajte aplikaci k Apple na notarizaci
- Apple ověří, že aplikace neobsahuje malware
- Po notarizaci bude aplikace důvěryhodná

#### **3. 🏪 Mac App Store**
- Nejbezpečnější způsob distribuce
- Apple automaticky notarizuje aplikace
- Uživatelé mohou stáhnout bez problémů

## 🚀 **Alternativní řešení:**

### **1. 🔓 Otevření přes Terminal:**
```bash
# Odstranění quarantine atributu
xattr -d com.apple.quarantine /path/to/MP3Joiner.app

# Spuštění aplikace
open /path/to/MP3Joiner.app
```

### **2. ⚙️ Systémové nastavení:**
1. **System Preferences** → **Security & Privacy**
2. **General** tab
3. Klikněte **"Open Anyway"** vedle MP3Joiner

### **3. 🔧 Gatekeeper nastavení:**
```bash
# Dočasně vypnout Gatekeeper (NEDOPORUČUJE SE)
sudo spctl --master-disable

# Znovu zapnout Gatekeeper
sudo spctl --master-enable
```

## 📋 **Pro vývojáře:**

### **Správné podepsání:**
```bash
# Podepsání s Distribution certifikátem
codesign --force --sign "Developer ID Application: Your Name" MP3Joiner.app

# Ověření podpisu
codesign -dv MP3Joiner.app
codesign -vv MP3Joiner.app
```

### **Notarizace:**
```bash
# Vytvoření ZIP pro notarizaci
ditto -c -k --keepParent MP3Joiner.app MP3Joiner.zip

# Odeslání k notarizaci
xcrun altool --notarize-app --primary-bundle-id "com.mp3joiner.app" --username "your@email.com" --password "@keychain:AC_PASSWORD" --file MP3Joiner.zip

# Kontrola stavu
xcrun altool --notarization-info "request-uuid" --username "your@email.com" --password "@keychain:AC_PASSWORD"
```

## 🎯 **Doporučení:**

### **Pro uživatele:**
1. ✅ **Pravé tlačítko → Otevřít** (nejjednodušší)
2. ✅ **System Preferences → Security & Privacy → Open Anyway**
3. ⚠️ **Terminal příkazy** (pro pokročilé)

### **Pro vývojáře:**
1. ✅ **Apple Developer Account** ($99/rok)
2. ✅ **Distribution certifikát**
3. ✅ **Notarizace aplikace**
4. ✅ **Mac App Store** (nejlepší)

## 📊 **Statistiky:**
- **Development certifikát**: ✅ Funguje pro testování
- **Distribution certifikát**: ✅ Potřebný pro distribuci
- **Notarizace**: ✅ Odstraní varování
- **Mac App Store**: ✅ Nejbezpečnější

## 🔄 **Budoucí řešení:**
- Implementovat plnou notarizaci
- Přidat do Mac App Store
- Vytvořit automatický signing pipeline

---
**Poznámka:** Toto je běžný problém s macOS aplikacemi. Apple chrání uživatele před malware, ale někdy blokuje i legitimní aplikace.
