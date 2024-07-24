//
//  SignIn.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 21/07/24.
//

import Foundation

struct Login: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let status: String
    let message: String
    let accessToken: String
}
