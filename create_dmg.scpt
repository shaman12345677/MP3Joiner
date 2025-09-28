-- MP3Joiner DMG Creation Script
-- Vytvoří profesionální DMG s pozadím a ikonami

tell application "Finder"
    -- Vytvoření dočasné složky
    set tempFolder to (path to desktop as string) & "MP3Joiner_DMG"
    do shell script "mkdir -p " & quoted form of POSIX path of tempFolder
    
    -- Kopírování aplikace
    set appPath to "/Users/samekt/Library/Developer/Xcode/DerivedData/MP3Joiner-fqxjsykaknbrsjhdmrpcxkvmgeik/Build/Products/Release/MP3Joiner.app"
    do shell script "cp -R " & quoted form of appPath & " " & quoted form of POSIX path of tempFolder
    
    -- Vytvoření symlinku na Applications
    do shell script "ln -s /Applications " & quoted form of POSIX path of tempFolder & "/Applications"
    
    -- Nastavení pozice ikon
    set iconSize to 128
    set iconSpacing to 200
    
    -- Pozice aplikace
    set appPosition to {100, 100}
    
    -- Pozice Applications složky
    set appsPosition to {300, 100}
    
    -- Otevření Finder okna
    set dmgWindow to make new Finder window
    set target of dmgWindow to folder tempFolder
    
    -- Nastavení velikosti okna
    set bounds of dmgWindow to {100, 100, 600, 400}
    
    -- Nastavení zobrazení
    set current view of dmgWindow to icon view
    set icon size of icon view options of dmgWindow to iconSize
    
    -- Nastavení pozice ikon
    set position of item "MP3Joiner.app" of dmgWindow to appPosition
    set position of item "Applications" of dmgWindow to appsPosition
    
    -- Nastavení pozadí (volitelné)
    -- set background picture of icon view options of dmgWindow to file "background.png"
    
    -- Uložení nastavení
    close dmgWindow
    
    -- Vytvoření DMG
    set dmgPath to "/Users/samekt/Documents/programovani/MP3JoinerSwiftProject/MP3Joiner-1.0.0-professional.dmg"
    do shell script "hdiutil create -volname \"MP3Joiner\" -srcfolder " & quoted form of POSIX path of tempFolder & " -ov -format UDZO " & quoted form of dmgPath
    
    -- Podepsání DMG
    do shell script "codesign --force --sign \"Developer ID Application: s TOMÁŠ SAMEK (5VL45NGMHA)\" " & quoted form of dmgPath
    
    -- Vyčištění
    do shell script "rm -rf " & quoted form of POSIX path of tempFolder
    
    display dialog "DMG soubor byl úspěšně vytvořen: " & dmgPath
end tell
