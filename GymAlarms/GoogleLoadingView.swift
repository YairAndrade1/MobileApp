// GoogleLoadingView.swift
// Pantalla 3: Cargando inicio de sesión con Google

import SwiftUI

struct GoogleLoadingView: View {
    let email: String
    @State private var goToAlarm: Bool = false

    var body: some View {
        ZStack {
            AppPalette.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 24) {
                // Google badge
                ZStack {
                    RoundedRectangle(cornerRadius: 36, style: .continuous)
                        .fill(Color(hex: "#4285F4").opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 36, style: .continuous)
                                .stroke(Color(hex: "#4285F4").opacity(0.15), lineWidth: 1.1)
                        )
                    Image("googlelogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .frame(width: 72, height: 72)

                VStack(spacing: 6) {
                    Text("Iniciando sesión…")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(AppPalette.white)
                    Text(email)
                        .font(.system(size: 14))
                        .foregroundStyle(AppPalette.textSecondary)
                }

                // Loading dots (static mock)
                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(hex: "#4285F4").opacity(0.95 - Double(i) * 0.1))
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                goToAlarm = true
            }
        }
        .navigationDestination(isPresented: $goToAlarm) {
            AlarmView()
        }
    }
}

#Preview("Google Loading") {
    GoogleLoadingView(email: "carlos.ruiz@gmail.com")
}
