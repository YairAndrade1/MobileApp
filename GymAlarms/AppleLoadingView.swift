// AppleLoadingView.swift
// Pantalla 3: Iniciando sesión con Apple

import SwiftUI

struct AppleLoadingView: View {
    var body: some View {
        ZStack {
            AuthPalette.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    RoundedRectangle(cornerRadius: 36, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 36, style: .continuous)
                                .stroke(Color.white.opacity(0.10), lineWidth: 1.1)
                        )
                    Image(systemName: "applelogo")
                        .font(.system(size: 40, weight: .regular))
                        .foregroundStyle(.white)
                }
                .frame(width: 72, height: 72)

                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "lock")
                            .foregroundStyle(.white)
                        Text("Iniciando sesión…")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    Text("Verificando con Apple ID")
                        .font(.system(size: 14))
                        .foregroundStyle(AuthPalette.textSecondary)
                }

                // Loading ring mimic
                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.9 - Double(i) * 0.2))
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("Apple Loading") {
    AppleLoadingView()
}
