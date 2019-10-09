//
//  File.swift
//  
//
//  Created by Vamsi Katragadda on 09/10/19.
//

import Foundation

// Used for data decode
extension Data {
    func decode<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}

// Used for Pasrse JSON
extension Data {
    func parseJson() -> Any? {
        do {
            let responseBody = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.allowFragments)
            return responseBody as Any?
        } catch let error as NSError {
            print("Error parsing data: \(error.localizedDescription)")
            return nil
        }
    }

    /// Base64 encoding
    ///
    /// - Returns: Returns a base64 encoded string.
    func base64Encode() -> String {
        return self.base64EncodedString()
    }

    /// Hex conversion
    ///
    /// - Returns: Returns a hex converted string.
    func hexConversion() -> String {
        return self.map { String(format: "%02x", $0) }.joined()
    }
}

extension Data {
    init?(fromHexEncodedString string: String) {
        
        // Convert 0 ... 9, a ... f, A ...F to their decimal value,
        // return nil for all other input characters
        func decodeNibble(_ nibble: UInt16) -> UInt8? {
            switch nibble {
            case 0x30 ... 0x39:
                return UInt8(nibble - 0x30)
            case 0x41 ... 0x46:
                return UInt8(nibble - 0x41 + 10)
            case 0x61 ... 0x66:
                return UInt8(nibble - 0x61 + 10)
            default:
                return nil
            }
        }
        
        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0
        for character in string.utf16 {
            guard let val = decodeNibble(character) else { return nil }
            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }
        guard even else { return nil }
    }
}
