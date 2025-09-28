//
//  ModelUtils.swift
//  Habits
//
//  Created by Chenluo Deng on 9/13/25.
//

import Foundation

class ModelUtils {
    static func toJSON(habits: [HabitEvent]) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(habits)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Error encoding habits to JSON: \(error)")
            return nil
        }

    }
}
