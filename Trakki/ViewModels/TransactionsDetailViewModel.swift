//
//  TransactionsDetailViewModel.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 22/07/24.
//

import Foundation
import Combine

class TransactionsDetailViewModel: ObservableObject {
    @Published var transaction: Transaction
    
    private var cancellables = Set<AnyCancellable>()
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
    func updateTransaction() {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("No access token found.")
            return
        }
        
        guard let url = URL(string: "http://localhost:8000/api/transactions/") else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "transaction_id": transaction.id,
            "remarks": transaction.remarks
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to encode request body: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .tryMap { data -> String in
                guard let responseString = String(data: data, encoding: .utf8) else {
                    throw NSError(domain: "ResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to convert data to string"])
                }
                return responseString
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to update transaction: \(error.localizedDescription)")
                }
            }, receiveValue: { responseString in
                print(responseString)
            })
            .store(in: &cancellables)
    }
}
