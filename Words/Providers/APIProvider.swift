//
//  APIProvider.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import Foundation
import SwiftUI
import Alamofire

struct ServerGameSessionModel: Codable {
    let type: String
    let word: String
    let UID: String
    let result: Int
    let filledLines: Int
    let duration: Int
}

struct SaveCommentModel: Codable {
    let word: String
    let text: String
    let UID: String
}

struct TopElement: Codable {
    let nickname: String
    let points: Int
    let isPlayer: Bool
    let position: Int
}

struct CommentsRequestModel: Codable {
    let word: String
    let UID: String
}

struct WordstatModel: Codable {
    let word: String
    let won: Int
    let lost: Int
    let averageDuration: Double
    let averageLines: Double
    var wonPercent: Int {
        if won == 0 { return 0 }
        return (won + lost) / won * 100
    }
    var lostPercent: Int {
        if won == 0 { return 0 }
        return (won + lost) / won * 100
    }
}

enum APIError: Error {
    case failedToDecode, failedToEncode, failedToComposeURL
}

class APIProvider: ObservableObject {
    // MARK: - PROPERTIES
    static let shared = APIProvider()
    @AppStorage("UID") private var UID: String = ""

    @Published var message: String = ""
    @Published var showDownloading: Bool = false
    @Published var wordOfTheDayResponse: WordOfTheDayResponse?
    @Published var points: Int = 0

    init() {
        if UID == "" { UID = UUID().uuidString }
    }

    // MARK: - FUNCTIONS

    // MARK: - GET STATISTICS ABOT THIS WORD

    func getWordstat(word: String) async throws -> WordstatModel {
        return try await withCheckedThrowingContinuation { continuation in
            let urlString = "\(ENV.server)/api/wordstat/"
            guard let url = URL(string: urlString) else { return }
            guard let encoded = try? JSONEncoder().encode([ "word": word, "UID": UID ]) else { return }

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded

            AF.request( request )
            .validate()
            .responseDecodable(of: WordstatModel.self ) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }

    // MARK: - SEND MESSAGE TO DEVELOPERS
    func sendMessage(message: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            guard let encoded = try? JSONEncoder().encode(["message": "\(UID) \(message)"]) else { return continuation.resume(throwing: APIError.failedToComposeURL) }
            guard let url = URL(string: "https://vin.monster/minute/message/") else { return continuation.resume(throwing: APIError.failedToDecode) }

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded

            AF.request(
                request
            )
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    continuation.resume()
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }

    func addReaction(type: ReactionType, commentId: Int) async throws -> Comment? {
        return try await withCheckedThrowingContinuation { continuation in
            let reaction = Reaction(type: type, UID: UID, comment_id: commentId)
            let urlString = "\(ENV.server)/api/reactions/"

            guard let url = URL(string: urlString) else { return continuation.resume(throwing: APIError.failedToComposeURL) }
            guard let encoded = try? JSONEncoder().encode(reaction) else { return continuation.resume(throwing: APIError.failedToComposeURL)}

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded

            AF.request(
                request
            )
            .validate()
            .responseDecodable(of: Comment.self) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }

    func getComments(word: String) async throws -> [Comment] {
        return try await withCheckedThrowingContinuation { continuation in
            let urlString = "\(ENV.server)/api/getcomments/"
            guard let url = URL(string: urlString) else { return continuation.resume(throwing: APIError.failedToComposeURL)}

            guard let encoded = try? JSONEncoder().encode(CommentsRequestModel(word: word, UID: self.UID)) else {
                return continuation.resume(throwing: APIError.failedToDecode)
            }

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded

            AF.request(
                request
            )
            .validate()
            .responseDecodable(of: [Comment].self) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }

    func saveComment(word: String, text: String) async throws -> (Bool, Comment?) {
        return try await withCheckedThrowingContinuation { continuation in
            let comment = SaveCommentModel(word: word, text: text, UID: self.UID)
            let urlString = "\(ENV.server)/api/comments/"

            guard let url = URL(string: urlString) else { return continuation.resume(throwing: APIError.failedToComposeURL) }

            guard let encoded = try? JSONEncoder().encode(comment) else {
                print("Failed to encode order")
                return continuation.resume(throwing: APIError.failedToDecode)
            }

            print(String(data: encoded, encoding: .utf8)!)

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded

            AF.request(request)
            .validate()
            .responseDecodable(of: Comment.self) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: (true, data))
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }

    func updatePoints() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let urlString = "\(ENV.server)/api/getPoints/\(UID)"
            AF.request(
                urlString,
                method: .get
            )
            .validate()
            .responseDecodable(of: Int.self) { response in
                switch response.result {
                case let .success(data):
                    self.points = data
                    continuation.resume()
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }

    func getTopList() async throws -> [TopElement] {
        return try await withCheckedThrowingContinuation { continuation in
            let urlString = "\(ENV.server)/api/top/\(UID)"
            AF.request(
                urlString,
                method: .get
            )
            .validate()
            .responseDecodable(of: [TopElement].self) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }

    func saveTheGame(game: GameHistoryModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let serverGameSessionModel = ServerGameSessionModel(type: game.gameType.name, word: game.word, UID: UID, result: game.result.rawValue, filledLines: game.tries, duration: game.duration)

            let urlString = "\(ENV.server)/api/games"
            guard let url = URL(string: urlString) else { return continuation.resume(throwing: APIError.failedToComposeURL) }

            guard let encoded = try? JSONEncoder().encode(serverGameSessionModel) else {
                print("Failed to encode order")
                return continuation.resume(throwing: APIError.failedToDecode)
            }

            print(String(data: encoded, encoding: .utf8)!)

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded

            AF.request(request)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    continuation.resume()
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }

    // OK
    func getWordOfTheDay() async throws -> WordOfTheDayResponse {
        return try await withCheckedThrowingContinuation { continuation in
            let urlString = "\(ENV.server)/api/dailyword"
            AF.request(
                urlString,
                method: .get
            )
            .validate()
            .responseDecodable(of: WordOfTheDayResponse.self) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }

    // TO DO REMOVE
    func getWordOfTheDay() {
        let urlString = "\(ENV.server)/api/dailyword"
        guard let url = URL(string: urlString) else {
            // fatalError("Missing URL")
            self.message = "Отсутствует подключение"
            // self.showDownloadProgressView = false
            return
        }

        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                // self.showDownloading = false
                return
            }

            guard let response = response as? HTTPURLResponse else {
                // self.showDownloading = false
                print("GET RESPONSE ERROR")
                return
            }

            if response.statusCode == 200 {
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                    return
                }

                DispatchQueue.main.async {
                    do {
                        let decodedResult = try JSONDecoder().decode(WordOfTheDayResponse.self, from: data)
                        self.wordOfTheDayResponse = decodedResult

                        // Записываем в базу
                        let dailyWord = DailyWordDBM(context: CoreDataProvider.shared.viewContext)
                        dailyWord.word = decodedResult.word
                        dailyWord.active_at = Int64(decodedResult.active_at)
                        dailyWord.next_at = Int64(decodedResult.next_at)
                        dailyWord.save()
                        self.showDownloading = false
                    } catch let error {
                        print("Error decoding: ", error)
                        self.showDownloading = false
                    }
                }
            }

            print(url)
            print("STATUS CODE \(response.statusCode)")
        }.resume()
    }
}

extension APIProvider {
    private func handleError(error: AFError) -> Error {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code

            if code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
                let currentError = NSError(
                    domain: nserror.domain,
                    code: code,
                    userInfo: userInfo
                )
                return currentError
            }
        }
        return error
    }
}
