//
//  NetworkManager.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 08.04.2022.
//

import Foundation

enum Link: String {
    case proPlayers = "https://api.opendota.com/api/proPlayers"
    case playerInfo = "https://api.opendota.com/api/players/"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchPlayers(completion: @escaping (_ proPlayers: [Player]) -> ()) {
        guard let url = URL(string: Link.proPlayers.rawValue) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let proPlayers = try JSONDecoder().decode([Player].self, from: data)
                completion(proPlayers)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func fetchAvatarImages(with proPlayer: Player, completion: @escaping (_ data: Data) -> ()) {
        guard let url = URL(string: proPlayer.avatarfull) else { return }
        URLSession.shared.downloadTask(with: url) { localUrl, _, error in
            guard let localUrl = localUrl else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let data = try Data(contentsOf: localUrl)
                completion(data)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func fetchPlayerDetails(with accountId: Int, completion: @escaping (_ playerInfo: PlayerInfo) -> ()) {
        let urlString = "\(Link.playerInfo.rawValue)\(accountId)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let playerInfo = try JSONDecoder().decode(PlayerInfo.self, from: data)
                completion(playerInfo)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchPlayerWinAndLoses(with accountId: Int, completion: @escaping (_ playerWinAndLoses: PlayerWinsAndLoses) -> ()) {
        let urlString = "\(Link.playerInfo.rawValue)\(accountId)/wl"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let playerWinAndLoses = try JSONDecoder().decode(PlayerWinsAndLoses.self, from: data)
                completion(playerWinAndLoses)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
