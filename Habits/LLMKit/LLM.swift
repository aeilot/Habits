//
//  LLM.swift
//  Habits
//
//  Created by Chenluo Deng on 9/13/25.
//

import Foundation
import OpenAI

protocol LLM{
    var modelName: String { get set }
    var url: String { get set }
    var apiKey: String? { get set }
    
    func getConfiguration() -> OpenAI.Configuration
}
