//
//  SignInViewModel.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 21/07/24.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkLoggedIn()
    }
    
    func login() {
        guard let url = URL(string: "http://localhost:8000/api/users/login") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let login = Login(email: email, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(login)
        } catch {
            self.errorMessage = "Error encoding login information: \(error.localizedDescription)"
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                if response.statusCode == 200 {
                    return output.data
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                self.isLoggedIn = true
                print(response)
                UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
            })
            .store(in: &cancellables)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        print("Token has been deleted")
        self.isLoggedIn = false
    }
    
    func checkLoggedIn() {
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"), !accessToken.isEmpty {
            self.isLoggedIn = true
        }
    }
}
