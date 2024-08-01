//
//  String_Extension.swift
//  ArtReader
//
//  Created by CaiGou on 2024/8/1.
//

import Foundation
extension String {
    /// SwifterSwift: Check if string contains one or more instance of substring.
    ///
    ///        "Hello World!".contain("O") -> false
    ///        "Hello World!".contain("o", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    /// SwifterSwift: Returns a new string in which all occurrences of a regex pattern in a specified range of the
    /// receiver are replaced by the template.
    /// - Parameters:
    ///   - pattern: Regex pattern to replace.
    ///   - template: The regex template to replace the pattern.
    ///   - options: Options to use when matching the regex. Only .regularExpression, .anchored .and caseInsensitive are
    /// supported.
    ///   - searchRange: The range in the receiver in which to search.
    /// - Returns: A new string in which all occurrences of regex pattern in searchRange of the receiver are replaced by
    /// template.
    func replacingOccurrences<Target, Replacement>(
        ofPattern pattern: Target,
        withTemplate template: Replacement,
        options: String.CompareOptions = [.regularExpression],
        range searchRange: Range<Self.Index>? = nil) -> String where Target: StringProtocol,
        Replacement: StringProtocol {
        assert(
            options.isStrictSubset(of: [.regularExpression, .anchored, .caseInsensitive]),
            "Invalid options for regular expression replacement")
        return replacingOccurrences(
            of: pattern,
            with: template,
            options: options.union(.regularExpression),
            range: searchRange)
    }
}
