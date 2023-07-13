//
//  UnPack.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/13.
//
import SSZipArchive
import Foundation

class Unpacker: NSObject {
    /// Epub 文件解包
    /// - Parameters:
    ///   - epubFileURL: 原文件路径
    ///   - unPackageURL: 解包文件路径
    func unPackage(epubFileURL: URL, unPackageURL: URL) -> Bool {
        guard FileManager.default.fileExists(atPath: epubFileURL.path) else {
            debugPrint("未找到 epub 文件", epubFileURL.path)
            return false
        }
        if FileManager.default.fileExists(atPath: unPackageURL.path) {
            debugPrint("解包路径已存在:",unPackageURL.path)
            return true
        }
        
        return SSZipArchive.unzipFile(atPath: epubFileURL.path, toDestination: unPackageURL.path, delegate: self)
    }
}

extension Unpacker: SSZipArchiveDelegate {
    func zipArchiveWillUnzipArchive(atPath path: String, zipInfo: unz_global_info) {
        debugPrint("将要解包:", path, zipInfo.size_comment, zipInfo.number_entry)
    }
    
    func zipArchiveShouldUnzipFile(at fileIndex: Int, totalFiles: Int, archivePath: String, fileInfo: unz_file_info) -> Bool {
        debugPrint("是否解包\(fileIndex)/\(totalFiles)文件File:", fileInfo.flag)
        return true
    }
    
    func zipArchiveWillUnzipFile(at fileIndex: Int, totalFiles: Int, archivePath: String, fileInfo: unz_file_info) {
        debugPrint("将要解包\(fileIndex)/\(totalFiles)File:", fileInfo.flag)
    }
    
    func zipArchiveDidUnzipFile(at fileIndex: Int, totalFiles: Int, archivePath: String, fileInfo: unz_file_info) {
        debugPrint("解包完成\(fileIndex)/\(totalFiles)File:",fileInfo.flag)
    }
    
    func zipArchiveProgressEvent(_ loaded: UInt64, total: UInt64) {
        debugPrint("解包进度:\(loaded)/\(total)")
    }
    
    func zipArchiveDidUnzipArchive(atPath path: String, zipInfo: unz_global_info, unzippedPath: String) {
        debugPrint("解包完成:",unzippedPath)
    }
    
    
    
    func zipArchiveDidUnzipFile(at fileIndex: Int, totalFiles: Int, archivePath: String, unzippedFilePath: String) {
        debugPrint("解包完成File2:",archivePath)
    }
}


