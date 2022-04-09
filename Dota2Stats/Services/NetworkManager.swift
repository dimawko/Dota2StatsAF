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
    
    func fetchProPlayers(completion: @escaping (_ proPlayers: [ProPlayer])->()) {
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
    
    func fetchImage(with url: String, completion: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            guard let image = (UIImage(data: data)) else { return }
            completion(image)
        }.resume()
    }
    private init() {}
}
