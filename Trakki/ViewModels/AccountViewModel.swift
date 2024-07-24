//
//  AccountViewModel.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 23/07/24.
//

import Foundation
import Combine

class AccountViewModel: ObservableObject {
    @Published var account: AccountData?
    @Published var transactions: [Transaction] = []
    
    private var cancellable: AnyCancellable?
    
    init() {
        fetchAccountData()
    }
    
    func fetchAccountData() {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("No access token found.")
            return
        }
        
        guard let url = URL(string: "http://localhost:8000/api/users/dashboard") else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: AccountResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                self?.account = response.data
                self?.transactions = response.transactions
            })
    }
}
