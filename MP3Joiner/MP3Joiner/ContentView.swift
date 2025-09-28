import SwiftUI
import AVFoundation
import Foundation

struct ContentView: View {
    @State private var selectedFiles: [URL] = []
    @State private var outputPath: String = ""
    @State private var isProcessing = false
    @State private var progress: Double = 0.0
    @State private var progressText = "Připravuji..."
    @State private var showOpenFileButton = false
    @State private var outputFileURL: URL?
    @State private var bookmarkedFiles: [URL] = []
    @State private var isDragOver = false
    @State private var draggedItem: Int?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 10) {
                HStack {
                    Text("🎵")
                        .font(.system(size: 40))
                    Text("MP3 Joiner")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                }
                Text("Spojte MP3 soubory pomocí ffmpeg")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.46, green: 0.29, blue: 0.64)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Main Content
            VStack(spacing: 30) {
                // File Input Section
                VStack(spacing: 20) {
                    if selectedFiles.isEmpty {
                        Button(action: selectFiles) {
                            VStack(spacing: 20) {
                                Text("📁")
                                    .font(.system(size: 60))
                                VStack(spacing: 10) {
                                    Text("Přetáhněte MP3 soubory sem")
                                        .font(.system(size: 24, weight: .medium))
                                        .foregroundColor(.black)
                                    Text("nebo klikněte pro výběr souborů")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                                Button("Vybrat MP3 soubory") {
                                    selectFiles()
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(isDragOver ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(isDragOver ? Color.blue : Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 3, dash: [10]))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onDrop(of: [.fileURL], isTargeted: $isDragOver) { providers in
                            handleDrop(providers: providers)
                        }
                    } else {
                        // File List Section
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Seznam souborů")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.black)
                                Spacer()
                                Button("Vymazat seznam") {
                                    // Stop accessing all bookmarked files
                                    for url in bookmarkedFiles {
                                        url.stopAccessingSecurityScopedResource()
                                    }
                                    bookmarkedFiles.removeAll()
                                    selectedFiles.removeAll()
                                    showOpenFileButton = false
                                }
                                .buttonStyle(.bordered)
                                .foregroundColor(.red)
                            }
                            
                            ScrollView {
                                LazyVStack(spacing: 8) {
                                    ForEach(Array(selectedFiles.enumerated()), id: \.offset) { index, file in
                                        HStack {
                                            Text("\(index + 1)")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.white)
                                                .frame(width: 30, height: 30)
                                                .background(Color.blue)
                                                .clipShape(Circle())
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(file.lastPathComponent)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(.black)
                                                    .lineLimit(1)
                                                Text(file.deletingLastPathComponent().lastPathComponent)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                                    .lineLimit(1)
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: { removeFile(at: index) }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.red)
                                                    .font(.system(size: 20))
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 12)
                                        .background(draggedItem == index ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                        .onDrag {
                                            draggedItem = index
                                            return NSItemProvider(object: "\(index)" as NSString)
                                        }
                                        .onDrop(of: [.text], isTargeted: nil) { providers in
                                            handleReorderDrop(providers: providers, targetIndex: index)
                                        }
                                    }
                                }
                            }
                            .frame(maxHeight: 300)
                            .onDrop(of: [.fileURL], isTargeted: $isDragOver) { providers in
                                handleDrop(providers: providers)
                            }
                            
                            HStack {
                                Button("Přidat další") {
                                    selectFiles()
                                }
                                .buttonStyle(.bordered)
                                
                                Button("Seřadit A-Z") {
                                    sortFilesAlphabetically()
                                }
                                .buttonStyle(.bordered)
                                
                                Spacer()
                            }
                        }
                    }
                }
            
                // Output Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Výstupní soubor:")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 10) {
                        TextField("Zadejte název souboru", text: $outputPath)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 16))
                        
                        Button("Procházet") {
                            selectOutputPath()
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
                // Action Section
                HStack(spacing: 20) {
                    Button("🔗 Spojit (kopírovat)") {
                        joinFiles(useCopy: true)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(selectedFiles.isEmpty || outputPath.isEmpty || isProcessing)
                    
                    Button("🔄 Spojit a překódovat (128k)") {
                        joinFiles(useCopy: false)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(selectedFiles.isEmpty || outputPath.isEmpty || isProcessing)
                }
                
                // Progress Section
                if isProcessing || showOpenFileButton {
                    VStack(spacing: 20) {
                        VStack(spacing: 10) {
                            ProgressView(value: progress, total: 100)
                                .progressViewStyle(LinearProgressViewStyle())
                                .frame(height: 20)
                            
                            Text(progressText)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        if showOpenFileButton {
                            Button("Otevřít soubor") {
                                openOutputFile()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                    }
                }
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        }
        .frame(width: 900, height: 700)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.46, green: 0.29, blue: 0.64)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private func selectFiles() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.audio]
        
        if panel.runModal() == .OK {
            for url in panel.urls {
                // Start accessing the file to get persistent access
                _ = url.startAccessingSecurityScopedResource()
                bookmarkedFiles.append(url)
            }
            selectedFiles.append(contentsOf: panel.urls)
        }
    }
    
    private func selectOutputPath() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.audio]
        panel.nameFieldStringValue = "spojene_mp3.mp3"
        
        if panel.runModal() == .OK {
            outputPath = panel.url?.path ?? ""
        }
    }
    
    private func removeFile(at index: Int) {
        if index < bookmarkedFiles.count {
            bookmarkedFiles[index].stopAccessingSecurityScopedResource()
            bookmarkedFiles.remove(at: index)
        }
        selectedFiles.remove(at: index)
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        var addedFiles = 0
        
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier("public.file-url") {
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, error in
                    if let url = item as? URL {
                        DispatchQueue.main.async {
                            // Check if it's an audio file
                            if url.pathExtension.lowercased() == "mp3" && !selectedFiles.contains(url) {
                                // Start accessing the file to get persistent access
                                _ = url.startAccessingSecurityScopedResource()
                                bookmarkedFiles.append(url)
                                selectedFiles.append(url)
                                addedFiles += 1
                            }
                        }
                    }
                }
            }
        }
        
        // Reset drag over state
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isDragOver = false
        }
        
        return addedFiles > 0
    }
    
    private func handleReorderDrop(providers: [NSItemProvider], targetIndex: Int) -> Bool {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier("public.text") {
                provider.loadItem(forTypeIdentifier: "public.text", options: nil) { item, error in
                    if let data = item as? Data, let sourceIndexString = String(data: data, encoding: .utf8), let sourceIndex = Int(sourceIndexString) {
                        DispatchQueue.main.async {
                            reorderFiles(from: sourceIndex, to: targetIndex)
                        }
                    }
                }
            }
        }
        
        draggedItem = nil
        return true
    }
    
    private func reorderFiles(from sourceIndex: Int, to targetIndex: Int) {
        guard sourceIndex != targetIndex && sourceIndex < selectedFiles.count && targetIndex < selectedFiles.count else { return }
        
        let sourceFile = selectedFiles[sourceIndex]
        let sourceBookmark = bookmarkedFiles[sourceIndex]
        
        selectedFiles.remove(at: sourceIndex)
        bookmarkedFiles.remove(at: sourceIndex)
        
        let newTargetIndex = targetIndex > sourceIndex ? targetIndex - 1 : targetIndex
        
        selectedFiles.insert(sourceFile, at: newTargetIndex)
        bookmarkedFiles.insert(sourceBookmark, at: newTargetIndex)
    }
    
    private func joinFiles(useCopy: Bool) {
        guard !selectedFiles.isEmpty, !outputPath.isEmpty else { return }
        
        isProcessing = true
        progress = 0.0
        progressText = "Připravuji..."
        showOpenFileButton = false
        
        // Check if ffmpeg is available
        guard checkFFmpeg() else {
            isProcessing = false
            progressText = "ffmpeg není nainstalován!"
            return
        }
        
        // Create file list
        let tempDir = FileManager.default.temporaryDirectory
        let listFile = tempDir.appendingPathComponent("mp3list_\(Date().timeIntervalSince1970).txt")
        
        do {
            let fileList = selectedFiles.map { file in
                "file '\(file.path.replacingOccurrences(of: "'", with: "'\"'\"'"))'"
            }.joined(separator: "\n")
            
            try fileList.write(to: listFile, atomically: true, encoding: .utf8)
            print("Created file list at: \(listFile.path)")
            print("Selected files: \(selectedFiles.map { $0.path })")
        } catch {
            isProcessing = false
            progressText = "Chyba při vytváření seznamu souborů: \(error.localizedDescription)"
            print("Error creating file list: \(error)")
            return
        }
        
        // Build ffmpeg command
        var arguments = ["-v", "info", "-f", "concat", "-safe", "0", "-i", listFile.path]
        
        if useCopy {
            arguments.append(contentsOf: ["-c", "copy"])
        } else {
            arguments.append(contentsOf: ["-c:a", "libmp3lame", "-b:a", "128k"])
        }
        
        arguments.append(contentsOf: ["-y", outputPath])
        
        // Run ffmpeg
        let process = Process()
        
        // Find ffmpeg path
        let ffmpegPath = findFFmpegPath()
        guard let ffmpegURL = ffmpegPath else {
            isProcessing = false
            progressText = "ffmpeg nenalezen!"
            print("FFmpeg not found in any of the expected paths")
            return
        }
        
        print("Using ffmpeg at: \(ffmpegURL.path)")
        
        // Debug: print command
        print("FFmpeg command: \(ffmpegURL.path) \(arguments.joined(separator: " "))")
        print("File list content:")
        if let content = try? String(contentsOf: listFile, encoding: .utf8) {
            print(content)
        }
        
        process.executableURL = ffmpegURL
        process.arguments = arguments
        
        let pipe = Pipe()
        process.standardError = pipe
        process.standardOutput = pipe
        
        // Read output in real-time
        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if !data.isEmpty {
                let output = String(data: data, encoding: .utf8) ?? ""
                print("FFmpeg output: \(output)", terminator: "")
            }
        }
        
        process.terminationHandler = { process in
            DispatchQueue.main.async {
                // Clean up temp file
                try? FileManager.default.removeItem(at: listFile)
                
                // Stop reading from pipe
                pipe.fileHandleForReading.readabilityHandler = nil
                
                print("FFmpeg process terminated with status: \(process.terminationStatus)")
                
                if process.terminationStatus == 0 {
                    self.isProcessing = false
                    self.progress = 100.0
                    self.progressText = "Dokončeno!"
                    self.showOpenFileButton = true
                    self.outputFileURL = URL(fileURLWithPath: self.outputPath)
                } else {
                    self.isProcessing = false
                    self.progressText = "Chyba při spojování souborů (kód: \(process.terminationStatus))"
                }
            }
        }
        
        do {
            print("Starting ffmpeg process...")
            try process.run()
            print("FFmpeg process started successfully")
            
            // Add timeout
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                if process.isRunning {
                    print("\nFFmpeg timeout - terminating process")
                    process.terminate()
                    self.isProcessing = false
                    self.progressText = "Timeout - proces byl ukončen"
                }
            }
            
            // Monitor progress
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                if !process.isRunning {
                    timer.invalidate()
                    return
                }
                
                // Simple progress simulation
                if self.progress < 90 {
                    self.progress += 2.0
                    self.progressText = "Zpracovávám... \(Int(self.progress))%"
                }
            }
        } catch {
            isProcessing = false
            progressText = "Chyba při spouštění ffmpeg: \(error.localizedDescription)"
            print("Error starting ffmpeg: \(error)")
        }
    }
    
    private func checkFFmpeg() -> Bool {
        return findFFmpegPath() != nil
    }
    
    private func findFFmpegPath() -> URL? {
        let possiblePaths = [
            "/opt/homebrew/bin/ffmpeg",
            "/usr/local/bin/ffmpeg",
            "/usr/bin/ffmpeg"
        ]
        
        for path in possiblePaths {
            if FileManager.default.fileExists(atPath: path) {
                print("Found ffmpeg at: \(path)")
                return URL(fileURLWithPath: path)
            }
        }
        
        print("FFmpeg not found in standard paths, trying which command...")
        
        // Try to find in PATH
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = ["ffmpeg"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            if process.terminationStatus == 0 {
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let path = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    print("Found ffmpeg via which: \(path)")
                    return URL(fileURLWithPath: path)
                }
            }
        } catch {
            print("Error running which command: \(error)")
        }
        
        print("FFmpeg not found anywhere")
        return nil
    }
    
    private func openOutputFile() {
        if let url = outputFileURL {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }
    
    private func sortFilesAlphabetically() {
        let sortedPairs = zip(selectedFiles, bookmarkedFiles).enumerated().sorted { 
            $0.element.0.lastPathComponent < $1.element.0.lastPathComponent 
        }
        
        var newSelectedFiles: [URL] = []
        var newBookmarkedFiles: [URL] = []
        
        for (_, pair) in sortedPairs {
            newSelectedFiles.append(pair.0)
            newBookmarkedFiles.append(pair.1)
        }
        
        selectedFiles = newSelectedFiles
        bookmarkedFiles = newBookmarkedFiles
    }
}

#Preview {
    ContentView()
}

