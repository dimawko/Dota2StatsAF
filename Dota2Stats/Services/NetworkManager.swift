//
//  NetworkManager.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 08.04.2022.
//

import Alamofire
import Foundation

enum Link: String {
    case proPlayers = "https://api.opendota.com/api/proPlayers"
    case playerInfo = "https://api.opendota.com/api/players/"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(dataType: T.Type, from url: String, completion: @escaping(Result<T?, Error>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    if dataType == [Player].self {
                        let players = Player.getPlayers(from: value)
                        completion(.success(players as? T))
                    } else if dataType == PlayerInfo.self {
                        let playerInfo = PlayerInfo.getPlayerInfoData(from: value)
                        completion(.success(playerInfo as? T))
                    } else if dataType == PlayerWinsAndLoses.self {
                        let playerWinsAndLoses = PlayerWinsAndLoses.getPlayerWinsAndLosesData(from: value)
                        completion(.success(playerWinsAndLoses as? T))
                    } else {
                        print("There is no such type \(dataType) to conform fetch method")
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchAvatarImages(
        from url: String,
        completion: @escaping(Result<Data, Error>) -> Void) {
            AF.request(url)
                .validate()
                .responseData { dataResponse in
                    switch dataResponse.result {
                    case .success(let imageData):
                        completion(.success(imageData))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
}
