# 🛡️ MP3Joiner - Backup Distribuce

## 📋 Více způsobů distribuce:

### 1. 🌐 GitHub Pages (primární)
- **URL**: https://shaman12345677.github.io/MP3Joiner/
- **Výhody**: Zdarma, automatické aktualizace
- **Nevýhody**: Může přestat fungovat

### 2. 📦 GitHub Releases (backup)
- **URL**: https://github.com/shaman12345677/MP3Joiner/releases
- **Výhody**: Vždy funguje, přímé stažení
- **Nevýhody**: Méně uživatelsky přívětivé

### 3. 🔧 Install Script (automatické)
- **Soubor**: `install.sh`
- **Použití**: `curl -sSL https://raw.githubusercontent.com/shaman12345677/MP3Joiner/main/install.sh | bash`
- **Výhody**: Automatické stažení nejnovější verze

### 4. 🏠 Vlastní server (budoucí)
- **Možnosti**: VPS, Cloudflare Pages, Netlify
- **Výhody**: Plná kontrola, vlastní doména
- **Nevýhody**: Náklady na hosting

## 🚀 Nastavení GitHub Pages:

### Krok 1: Povolte GitHub Pages
1. Jděte na: https://github.com/shaman12345677/MP3Joiner/settings/pages
2. Source: Deploy from a branch
3. Branch: `main` / `docs`
4. Save

### Krok 2: Stránky budou dostupné na:
https://shaman12345677.github.io/MP3Joiner/

## 🔄 Automatické aktualizace:

### Pro nové verze:
1. Vytvořte nový release
2. Aktualizujte `docs/index.html` s novou verzí
3. Commit a push změny
4. GitHub Pages se automaticky aktualizuje

### Backup URL pro stažení:
```bash
# Přímé stažení nejnovější verze
curl -L -o MP3Joiner.zip "https://github.com/shaman12345677/MP3Joiner/releases/latest/download/MP3Joiner-1.0.0.zip"

# Nebo použijte install script
curl -sSL https://raw.githubusercontent.com/shaman12345677/MP3Joiner/main/install.sh | bash
```

## 📊 Statistiky:
- **Primární distribuce**: GitHub Pages
- **Backup distribuce**: GitHub Releases
- **Automatické stažení**: Install Script
- **Budoucí možnost**: Vlastní server

## 🛡️ Zabezpečení:
- ✅ Více způsobů distribuce
- ✅ Automatické zálohování
- ✅ Přímé stažení z GitHub
- ✅ Install script pro automatizaci
