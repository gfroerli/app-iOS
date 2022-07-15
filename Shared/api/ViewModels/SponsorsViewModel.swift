//
//  SponsorsViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 05.10.20.
//

import Foundation
import Combine
import SwiftUI

class SponsorListViewModel: ObservableObject {
    
    @Published var sponsor: Sponsor? = nil { didSet { didChange.send(())}}
    @Published var loadingState: NewLoadingState = .loading { didSet { didChange.send(())}}
    @Published var errorMsg: LocalizedStringKey = "" { didSet { didChange.send(())}}
    
    let didChange = PassthroughSubject<Void, Never>()

    /// Loads the sponsor from backend and assigns it to VM
    /// - Parameter sponsorID: Integer describing the sponsor ID
    func load(sponsorId: Int) async {
        
        loadingState = .loading
        
        let url = URL(string: "https://watertemp-api.coredump.ch//api/mobile_app/sensors/\(sponsorId)/sponsor")!
        var request = URLRequest(url: url)
        request.setValue(BearerToken.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            // Test for network connection
            if !Reachability.isConnectedToNetwork() {
                throw LoadingErrors.noConnectionError
            }
            // send request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // check response status code
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw LoadingErrors.fetchError
            }
            // try to decode
            guard let decodedSponsor = try? JSONDecoder().decode(Sponsor.self, from: data) else {
                throw LoadingErrors.decodeError
            }
            // update view model
            DispatchQueue.main.async {
                self.sponsor = decodedSponsor
                self.loadingState = .loaded
            }
            
        } catch {
            switch error {
            case LoadingErrors.decodeError:
                errorMsg = "Could not decode Sponsor."
            case LoadingErrors.fetchError:
                errorMsg = "Invalid server response."
            case LoadingErrors.noConnectionError:
                errorMsg = "No internet connection."
            default:
                errorMsg = LocalizedStringKey( error.localizedDescription )
            }
            loadingState = .failed
        }
    }
}

enum NewLoadingState {
    case loading, loaded, failed
}

enum LoadingErrors: Error {
    case fetchError, decodeError, noConnectionError
}
