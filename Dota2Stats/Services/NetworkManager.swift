//
//  NetworkManager.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 08.04.2022.
//

import Foundation
import UIKit

enum Link: String {
    case proPlayers = "https://api.opendota.com/api/proPlayers"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchProPlayers(completion: @escaping (_ proPlayers: [ProPlayer]) -> ()) {
        guard let url = URL(string: Link.proPlayers.rawValue) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let proPlayers = try JSONDecoder().decode([ProPlayer].self, from: data)
                completion(proPlayers)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func downloadImage(with proPlayer: ProPlayer, completion: @escaping (_ data: Data) -> ()) {
        guard let url = URL(string: proPlayer.avatarfull) else { return }
        URLSession.shared.downloadTask(with: url) { localUrl, _, error in
            guard let localUrl = localUrl else {
                print(error?.localizedDescription ?? "No url error description")
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
    
    func downloadPlayerDetails(with accountId: Int, completion: @escaping (_ proPlayerInfo: ProPlayerInfo) -> ()) {
        let urlString = "https://api.opendota.com/api/players/\(accountId)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let proPlayerInfo = try JSONDecoder().decode(ProPlayerInfo.self, from: data)
                completion(proPlayerInfo)
                print(proPlayerInfo)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func downloadPlayerWinAndLoses(with accountId: Int, completion: @escaping (_ playerWinAndLoses: PlayerWinsAndLoses) -> ()) {
        let urlString = "https://api.opendota.com/api/players/\(accountId)/wl"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let playerWinAndLoses = try JSONDecoder().decode(PlayerWinsAndLoses.self, from: data)
                completion(playerWinAndLoses)
                print(playerWinAndLoses)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    private init() {}
}
