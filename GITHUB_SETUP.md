# 🚀 GitHub Releases Setup - MP3Joiner

## ✅ Co máme připraveno:

1. **Git repository** s kompletním kódem
2. **Release build** - `MP3Joiner-1.0.0.zip` (1.2 MB)
3. **Git tag** - `v1.0.0`
4. **appcast.xml** - pro automatické aktualizace
5. **GitHub Actions workflow** - pro automatické buildu
6. **README.md** - kompletní dokumentace

## 📋 Kroky pro vytvoření GitHub repository:

### 1. Vytvořte repository na GitHub.com
1. Jděte na [github.com](https://github.com)
2. Klikněte na **"New repository"**
3. Název: `MP3Joiner`
4. Popis: `MP3Joiner - Jednoduchá macOS aplikace pro spojování MP3 souborů`
5. Veřejné nebo soukromé (podle vašeho výběru)
6. **NEVYTVÁŘEJTE** README, .gitignore nebo licence (už máme)
7. Klikněte **"Create repository"**

### 2. Připojte lokální repository k GitHub
```bash
cd /Users/samekt/Documents/programovani/MP3JoinerSwiftProject
git remote add origin https://github.com/YOUR_USERNAME/MP3Joiner.git
git branch -M main
git push -u origin main
git push origin v1.0.0
```

### 3. Vytvořte Release na GitHub
1. Jděte na **"Releases"** v GitHub repository
2. Klikněte **"Create a new release"**
3. Tag: `v1.0.0`
4. Název: `MP3Joiner v1.0.0`
5. Popis:
```
## 🎵 MP3Joiner v1.0.0

První stabilní verze MP3Joiner aplikace!

### ✨ Funkce:
- ✅ Spojování MP3 souborů pomocí FFmpeg
- ✅ Drag & Drop podpora pro přidávání souborů
- ✅ Seřazování souborů šipkami nahoru/dolů
- ✅ Vlastní ikona aplikace
- ✅ Moderní SwiftUI rozhraní
- ✅ Podpora pro macOS 14.0+

### 📋 Požadavky:
- macOS 14.0 nebo novější
- FFmpeg (nainstalujte pomocí: `brew install ffmpeg`)

### 🚀 Instalace:
1. Stáhněte `MP3Joiner-1.0.0.zip`
2. Rozbalte ZIP soubor
3. Přetáhněte `MP3Joiner.app` do složky Applications
4. Spusťte aplikaci
```
6. Přetáhněte `MP3Joiner-1.0.0.zip` do sekce **"Attach binaries"**
7. Klikněte **"Publish release"**

## 🔄 Automatické aktualizace (budoucí):

### Pro další verze:
1. Změňte verzi v `MP3Joiner.xcodeproj`
2. Vytvořte nový tag: `git tag -a v1.1.0 -m "Release v1.1.0"`
3. Push tag: `git push origin v1.1.0`
4. GitHub Actions automaticky vytvoří release

### Sparkle integrace:
- `appcast.xml` je připraven
- Budete potřebovat DSA/EdDSA klíče pro podpisování
- Nastavte URL v aplikaci na: `https://github.com/YOUR_USERNAME/MP3Joiner/releases/latest/download/appcast.xml`

## 📊 Statistiky projektu:
- **Velikost aplikace**: ~1.2 MB
- **Počet souborů**: 41
- **Řádky kódu**: ~2000
- **Podporované systémy**: macOS 14.0+
- **Architektura**: Apple Silicon (ARM64)

## 🎯 Výsledek:
✅ Kompletní macOS aplikace připravená k distribuci  
✅ Automatické buildu pomocí GitHub Actions  
✅ Profesionální dokumentace  
✅ Připraveno pro automatické aktualizace  
✅ Release build podepsaný Apple certifikátem  

**Aplikace je připravena k publikování! 🎉**
