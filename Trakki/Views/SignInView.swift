//
//  SignInView.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 18/07/24.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var vm = SignInViewModel()
    
    var body: some View {
        if vm.isLoggedIn {
            ContentView(vm: vm)
        } else {
            VStack {
                TextField("Email", text: $vm.email)
                    .padding()
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Password", text: $vm.password)
                    .padding()
                
                if vm.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button(action: {
                        vm.login()
                    }, label: {
                        Text("Login")
                            .padding()
                    })
                }
                
                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }.navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    SignInView()
}
