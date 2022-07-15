//
//  SensorListViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 19.09.20.
//

import Foundation
import Combine
import SwiftUI

class SensorListViewModel: ObservableObject {

    @Published var sensorArray = [Sensor]() { didSet { didChange.send(())}}
    @Published var loadingState: NewLoadingState = .loading { didSet { didChange.send(())}}
    @Published var errorMsg: LocalizedStringKey = "" { didSet { didChange.send(())}}

    let didChange = PassthroughSubject<Void, Never>()

    /// Loads sensors from backend and assigns it to VM
    func load() async {
        
        loadingState = .loading
        
        let url = URL(string: "https://watertemp-api.coredump.ch//api/mobile_app/sensors")!
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
            guard let decodedSensors = try? JSONDecoder().decode([Sensor].self, from: data) else {
                throw LoadingErrors.decodeError
            }
            
            // update view model
            DispatchQueue.main.async {
                self.sensorArray = decodedSensors
                self.loadingState = .loaded
            }
            
        } catch {
            switch error {
            case LoadingErrors.decodeError:
                errorMsg = "Could not decode Sensors."
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
