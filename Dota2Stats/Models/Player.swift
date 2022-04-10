//
//  Player.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 08.04.2022.
//

struct Player: Decodable {
    let account_id: Int
    let personaname: String
    let avatarfull: String
    let loccountrycode: String?
    let team_name: String?
}

struct PlayerInfo: Decodable {
    let solo_competitive_rank: Int?
    let competitive_rank: Int?
    let leaderboard_rank: Int?
    let profile: PlayerProfile?
}

struct PlayerProfile: Decodable {
    let last_login: String?
    let steamid: String?
}

struct PlayerWinsAndLoses: Decodable {
    let win: Int?
    let lose: Int?
}