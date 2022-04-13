//
//  Player.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 08.04.2022.
//

struct Player: Decodable {
    let accountId: Int?
    let personaname: String?
    let avatarfull: String?
    let loccountrycode: String?
    let teamName: String?
    
    init(playerData: [String: Any]) {
        accountId = playerData["account_id"] as? Int
        personaname = playerData["personaname"] as? String
        avatarfull = playerData["avatarfull"] as? String
        loccountrycode = playerData["loccountrycode"] as? String
        teamName = playerData["team_name"] as? String
    }
    
    static func getPlayers(from value: Any) -> [Player] {
        guard let playersData = value as? [[String: Any]] else { return [] }
        return playersData.compactMap { Player(playerData: $0) }
    }
}

struct PlayerInfo: Decodable {
    let soloCompetitiveRank: Int?
    let leaderboardRank: Int?
    
    init(playerInfoData: [String: Any]) {
        soloCompetitiveRank = playerInfoData["solo_competitive_rank"] as? Int
        leaderboardRank = playerInfoData["leaderboard_rank"] as? Int
    }
    
    static func getPlayerInfoData(from value: Any) -> PlayerInfo? {
        guard let playerInfoData = value as? [String: Any] else { return nil }
        return PlayerInfo(playerInfoData: playerInfoData)
    }
}

struct PlayerWinsAndLoses: Decodable {
    let win: Int?
    let lose: Int?
    
    init(playerWinsAndLosesData: [String: Any]) {
        win = playerWinsAndLosesData["win"] as? Int
        lose = playerWinsAndLosesData["lose"] as? Int
    }
    
    static func getPlayerWinsAndLosesData(from value: Any) -> PlayerWinsAndLoses? {
        guard let playerWinsAndLosesData = value as? [String: Any] else { return nil }
        return PlayerWinsAndLoses(playerWinsAndLosesData: playerWinsAndLosesData)
    }
}
