//
//  PreloaderView.swift
//  Coffee
//
//  Created by Alex Motor on 1/6/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import SwiftUI
import Combine

class LoadingTimer {

    let publisher = Timer.publish(every: 0.03, on: .main, in: .default)
    private var timerCancellable: Cancellable?

    func start() {
        self.timerCancellable = publisher.connect()
    }

    func cancel() {
        self.timerCancellable?.cancel()
    }
}

struct PreloaderView: View {
    @State private var scale: CGFloat = 0
    @State private var imageIndex = 0
    
    private let images = (0...29).map { UIImage(named: "preloader\($0).gif")! }
    private var timer = LoadingTimer()
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Coffee")
                .font(.system(size: 50.0, weight: .medium))
                .foregroundColor(.white)
            Image(uiImage: images[imageIndex])
                .onReceive(
                    timer.publisher,
                    perform: { _ in
                        self.imageIndex += 1
                        if self.imageIndex > 29 { self.imageIndex = 0 }
                    }
                )
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0)) {
                        self.scale = 1.0
                    }
                }
        
        }
        .onAppear { self.timer.start() }
        .onDisappear { self.timer.cancel() }
    }
}

struct PreloaderView_Previews: PreviewProvider {
    static var previews: some View {
        PreloaderView()
            .previewLayout(.fixed(width: 240, height: 240))
    }
}
