//
//  LLM.swift
//  Habits
//
//  Created by Chenluo Deng on 9/13/25.
//

import Foundation
import OpenAI

class LLMProvider{
    public var apiKey: String?
    public var scheme: String = "https"
    public var host: String = "api.openai.com"
    public var basePath: String = "/v1"
    public var port: Int = 443
    
    init(apiKey: String? = nil, scheme: String = "https", host: String = "api.openai.com", basePath: String="/v1", port: Int=443) {
        self.apiKey = apiKey
        self.scheme = scheme
        self.host = host
        self.basePath = basePath
        self.port = port
    }
    
    func getConfiguration() -> OpenAI.Configuration{
        var configuration = OpenAI.Configuration(token: apiKey, host: host, port: port, scheme: scheme, basePath: basePath)
        return configuration
    }

    class Providers{
        static let OpenAI = LLMProvider()
        static let SiliconFlow = LLMProvider(apiKey: nil, scheme: "https", host: "api.siliconflow.cn", basePath: "/v1")
        static let OpenRouter = LLMProvider(apiKey: nil, scheme: "https", host: "openrouter.ai/api", basePath: "/v1")
        static let Gemini = LLMProvider(apiKey: nil, scheme: "https", host: "generativelanguage.googleapis.com", basePath: "/v1")
        static let GitHubCopilot = LLMProvider(apiKey: nil, scheme: "https", host: "api.githubcopilot.com", basePath: "/")
    }
}
