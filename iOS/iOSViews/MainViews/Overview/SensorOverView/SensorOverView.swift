//
//  SensorOverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct SensorOverView: View {
    @AppStorage("favorites") private var favorites = [Int]()
    @StateObject var sensorVM = SingleSensorViewModel()
    @State var isFav = false
    
    
    var sensorID: Int
    var sensorName: String
    var transparentBG = false
    
    var body: some View {
        VStack {
            ScrollView {
                switch sensorVM.loadingState {
                case .loaded, .loading:
                    
                    VStack {
                        
                        if(sensorVM.sensor?.latestTemp != nil) {
                            SensorOverviewLastMeasurementView(sensorVM: sensorVM)
                                .boxStyle()
                            
                            
                            SensorOverViewGraph(sensorID: sensorID)
                                .boxStyle()
                                .dynamicTypeSize(.xSmall ... .large)
                        } else {
                            SensorOverViewNewSensorView()
                                .boxStyle()
                        }
                        SensorOverviewMap(sensorVM: sensorVM)
                            .boxStyle()
                        
                        SensorOverviewSponsorView(sensorID: sensorID)
                            .boxStyle()
                    }
                    .padding(.vertical)
                    .task {
                        await sensorVM.load(sensorId: sensorID)
                    }
                    .onChange(of: sensorID) { newValue in
                        Task {
                            await sensorVM.load(sensorId: sensorID)
                        }
                    }
                case .failed:
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("Loading Location failed. Reason:").foregroundColor(.gray)
                            Text(sensorVM.errorMsg).foregroundColor(.gray)
                            Button("Try again") {}
                            .buttonStyle(.bordered)
                            .task { await sensorVM.load(sensorId: sensorID) }
                            Spacer()
                        }
                        Spacer()
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                    .boxStyle()
                    .padding(.vertical)
                }// switch end
            }
        }
        .navigationBarTitle(sensorName, displayMode: .inline)
        .background((transparentBG ? Color.clear : Color.systemGroupedBackground).ignoresSafeArea())
        .navigationBarItems(trailing:
                                Button {
            isFav ? removeFav() : makeFav()
        } label: {
            Image(systemName: isFav ? "star.fill" : "star")
                .foregroundColor(isFav ? .yellow : .none)
                .imageScale(.large)
        })
        .onAppear {
            if favorites.firstIndex(of: sensorID) != nil {
                isFav = true
            }
        }
    }
    
    /// adds sensorID to userDefaults
    func makeFav() {
        favorites.append(sensorID)
        isFav = true
    }
    /// removes sensorID from userDefaults
    func removeFav() {
        let index = favorites.firstIndex(of: sensorID)
        if index != nil {
            favorites.remove(at: index!)
        }
        isFav = false
    }
}

struct SensorOverView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverView(sensorID: 1, sensorName: "Test")
            .environment(\.sizeCategory, .extraExtraExtraLarge)
            .makePreViewModifier()
    }
}
