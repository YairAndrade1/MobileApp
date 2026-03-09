// AppleFaceIDScanningView.swift
// Pantalla 2: Escaneando Face ID

import SwiftUI

struct AppleFaceIDScanningView: View {
    @State private var goToLoading: Bool = false

    var body: some View {
        ZStack {
            AuthPalette.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                // Green square badge
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(AuthPalette.primaryGreen)
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(AuthPalette.backgroundPrimary)
                }
                .frame(width: 48, height: 48)

                // FaceID square frame
                ZStack {
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .stroke(AuthPalette.primaryGreen, lineWidth: 3)
                        .frame(width: 80, height: 80)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AuthPalette.primaryGreen)
                        .frame(width: 6, height: 6)
                        .offset(x: -28, y: -28)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AuthPalette.primaryGreen)
                        .frame(width: 6, height: 6)
                        .offset(x: 28, y: -28)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AuthPalette.primaryGreen)
                        .frame(width: 6, height: 6)
                        .offset(x: 28, y: 28)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AuthPalette.primaryGreen)
                        .frame(width: 6, height: 6)
                        .offset(x: -28, y: 28)
                }
                .frame(height: 100)

                VStack(spacing: 6) {
                    Text("Escaneando…")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                    Text("Mantén el dispositivo frente a tu cara")
                        .font(.system(size: 13))
                        .foregroundStyle(AuthPalette.textSecondary)
                }

                Spacer()
            }
        }
        .onAppear {
            // Simula avance hacia loading después de un instante
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                goToLoading = true
            }
        }
        .navigationDestination(isPresented: $goToLoading) {
            AppleLoadingView()
        }
    }
}

#Preview("Apple FaceID Scanning") {
    AppleFaceIDScanningView()
}
