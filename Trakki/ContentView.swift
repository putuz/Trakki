//
//  ContentView.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 10/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingSheet = false
    @ObservedObject var vm: SignInViewModel
    
    var body: some View {
        ZStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                TransactionsView(viewModel: TransactionsListViewModel())
                    .tabItem {
                        Image(systemName: "newspaper")
                        Text("Transactions")
                    }
                
                
                RecurringView()
                    .tabItem {
                        Image(systemName: "dollarsign.arrow.circlepath")
                        Text("Recurring")
                    }
                
                AccountView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Account")
                    }
            }
            .tint(Color.black)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isShowingSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding()
                            .background(Color.black)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 34)
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isShowingSheet, destination: {
            AddSheet()
        })
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    vm.logout()
                }) {
                    Text("Logout")
                        .foregroundStyle(.primary)
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    // Action for the notification bell
                }) {
                    Image(systemName: "bell")
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView(vm: SignInViewModel())
    }
}
