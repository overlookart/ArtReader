//
//  FileManager_Extension.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/13.
//

import Foundation
extension FileManager {
    private func urlForDirectory(directory: SearchPathDirectory) -> URL? {
        return self.urls(for: directory, in: SearchPathDomainMask.userDomainMask).last
        
    }
    
    private func pathForDirectory(directory: SearchPathDirectory) -> String? {
        return NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first
    }
    
    /// Document目录url
    var documentsURL: URL? {
        return self.urlForDirectory(directory: .documentDirectory)
    }
    /// Document目录
    var documentsPath: String? {
        return self.pathForDirectory(directory: .documentDirectory)
    }
    /// library目录url
    var libraryURL: URL? {
        return self.urlForDirectory(directory: .libraryDirectory)
    }
    /// library
    var libraryPath: String? {
        return self.pathForDirectory(directory: .libraryDirectory)
    }
    /// caches目录url
    var cachesURL: URL? {
        return self.urlForDirectory(directory: .cachesDirectory)
    }
    /// caches目录
    var cachesPath: String? {
        return self.pathForDirectory(directory: .cachesDirectory)
    }
    
    
    /// 将 String 存储为文件
    /// - Parameters:
    ///   - String: 要保存的 String
    ///   - url: 储存的路径
    ///   - atomically: atomically
    ///   - encoding: 编码
    /// - Returns: Result
    public func save(String: String, url: URL, atomically: Bool = true, encoding: String.Encoding = .utf8) -> Bool {
        var isSuccess = false
        do {
            try String.write(to: url, atomically: true, encoding: .utf8)
            isSuccess = true
            print(url.path,"\n文件保存成功")
        } catch {
            print(url.path,"\n文件保存失败：\(error.localizedDescription)")
        }
        return isSuccess
    }
}
