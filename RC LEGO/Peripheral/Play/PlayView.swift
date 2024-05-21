//
//  PlayView.swift
//  RC LEGO
//
//  Created by Alex on 21.05.2024.
//

import SwiftUI

struct PlayView: View {
    @ObservedObject var viewModel: PlayViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            controlsForm
            throttleInput
        }
        .padding(.all)
    }
    
    private var directionInput: some View {
        Spacer()
    }
    
    private var controlsForm: some View {
        Form {
            Section("Lights") {
                Toggle("Headlights", isOn: $viewModel.areHeadLightsOn)
                Toggle("Hazard Lights", isOn: $viewModel.areHazardLightsOn)
            }
            .onChange(of: viewModel.areHeadLightsOn) { _ in
                viewModel.headLightsInputChange()
            }
            .onChange(of: viewModel.areHazardLightsOn) { _ in
                viewModel.hazardLightsInputChange()
            }
            
            Section("Controls") {
                Toggle("Parking Sensor", isOn: $viewModel.isParkingSensorOn)
                Toggle("Light Sensor", isOn: $viewModel.isLightSensorOn)
            }
            .onChange(of: viewModel.isParkingSensorOn) { _ in
                viewModel.parkingSensorInputChange()
            }
            .onChange(of: viewModel.isLightSensorOn) { _ in
                viewModel.lightSensorInputChange()
            }
        }
    }
    
    private var throttleInput: some View {
        GeometryReader { proxy in
            VStack {
                ThrottleSliderView(sliderPercentage: $viewModel.throttlePercentage)
                    .frame(width: 100, height: proxy.size.height / 1.5)
                Text("Throttle")
                    .fontWeight(.bold)
            }
            .frame(maxHeight: .infinity)
            .onReceive(viewModel.$throttlePercentage.throttle(for: 0.25, scheduler: DispatchQueue.main, latest: true)) { _ in
                viewModel.throttleInputChange()
            }
        }
        .frame(
            maxWidth: 100,
            alignment: .trailing
        )
    }
}
