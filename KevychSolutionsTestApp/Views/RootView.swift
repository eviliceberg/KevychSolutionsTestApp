//
//  RootView.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 20.06.2025.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var vm = MainViewModel()
    @State private var segue: Bool = false
    @FocusState private var focus
    
    var body: some View {
        NavigationStack {
            ZStack {
                MainView(currentLocationForecast: vm.currentLocationForecast)
                    .onTapGesture {
                        focus = false
                    }
                    .overlay(alignment: .top, content: {
                        VStack {
                            TextField("Search...", text: $vm.searchText)
                                .focused($focus)
                                .font(.headline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(.ultraThinMaterial)
                                .clipShape(.rect(cornerRadius: 12))
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "magnifyingglass")
                                        .padding(.trailing, 12)
                                        .fontWeight(.semibold)
                                        .onTapGesture {
                                            vm.handleSearch {
                                                segue.toggle()
                                                vm.searchText = ""
                                            }
                                        }
                                }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    })
            }
            .alert("“App Name” need access to\nuse Location",
                   isPresented: $vm.showAlert) {
                Button("Cancel") { }
                Button("Settings", role: .cancel) {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
                
            } message: {
                Text("To get your current forecast, we need\naccess to Location in your iPhone\nSettings.")
            }
            .navigationDestination(isPresented: $segue, destination: {
                MainView(currentLocationForecast: vm.cityForecast, isMainView: false)
            })
            .environmentObject(vm)
            .toolbarVisibility(.hidden, for: .navigationBar)
        }
        .tint(.white)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RootView()
}
