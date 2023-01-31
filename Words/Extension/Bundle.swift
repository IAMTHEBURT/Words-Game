//
//  Bundle.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import Foundation

extension Bundle{
    func decode<T: Codable>(_ file: String) -> T {
        // 1. Locate the JSON file
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }
        
        // 2. Create a property for the data
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        // 3. Create a decoder
        let decoder = JSONDecoder()
        
        
        do {
          let decodedData = try decoder.decode(T.self, from: data)
            // 5. Return the readey-to-use data
            return decodedData
        } catch let jsonError as NSError {
          print("JSON decode failed: \(jsonError.localizedDescription)")
        }
        
        return [] as! T
    }
}

