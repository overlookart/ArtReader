//
//  UnPack.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/13.
//
import SSZipArchive
import Foundation

/// Epub 文件解包
/// - Parameters:
///   - epubFileURL: 原文件路径
///   - unPackageURL: 解包文件路径
func unPackage(epubFileURL: URL, unPackageURL: URL) {
    guard FileManager.default.fileExists(atPath: epubFileURL.path) else {
        debugPrint("未找到 epub 文件", epubFileURL.path)
        return
    }
    if FileManager.default.fileExists(atPath: unPackageURL.path) {
        debugPrint("解包路径已存在:",unPackageURL.path)
        return
    }
    
    SSZipArchive.unzipFile(atPath: epubFileURL.path, toDestination: unPackageURL.path, delegate: <#T##SSZipArchiveDelegate?#>)
}
