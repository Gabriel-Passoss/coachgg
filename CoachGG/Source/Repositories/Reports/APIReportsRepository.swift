//
//  APIReportsRepository.swift
//  CoachGG
//
//  Created by Gabriel on 07/08/25.
//

import Foundation

enum APIReportsError: Error, LocalizedError {
    case invalidUrl
    case invalidResponse
    case invalidData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL inválida, tente novamente mais tarde."
        case .invalidResponse:
            return "Resposta inválida, tente novamente mais tarde."
        case .invalidData:
            return "Dados inválidos, tente novamente mais tarde."
        case .unknown(let error):
            return "Ocorreu um erro desconhecido: \(error.localizedDescription)"
        }
    }
}




class APIReportsRepository: ReportsRepository {
    let baseUrl = "http://192.168.1.11:3000"
    
    func generateEndedMatchReport(matchId: String, puuid: String) async throws -> GenerateEndedMatchReportResponse? {
        guard let url = URL(string: "\(baseUrl)/BR1/report/endedMatch/\(matchId)/\(puuid)") else { throw APIReportsError.invalidUrl}
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let _ = response as? HTTPURLResponse else {
            throw APIReportsError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(GenerateEndedMatchReportResponse.self, from: data)
        } catch {
            print("JSON Decoding Error: \(error)")
            // For more details about the error:
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("Type '\(type)' mismatch: \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Value of type '\(type)' not found: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error: \(decodingError)")
                }
            }
            
            throw MatchRequestError.invalidData
        }
    }
}
