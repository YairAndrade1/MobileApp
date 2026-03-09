import SwiftUI

// MARK: - AlarmView
struct AlarmView: View {
    // MARK: State
    @State private var sets: Int = 3
    @State private var workSeconds: Int = 45 // 0:45
    @State private var restSeconds: Int = 20 // 0:20

    @State private var showSaveSheet: Bool = false
    @State private var alarmName: String = ""
    @State private var isSaving: Bool = false
    @State private var showSuccess: Bool = false

    var totalSeconds: Int {
        let perSet = workSeconds + restSeconds
        return max(0, sets) * perSet
    }

    var body: some View {
        ZStack {
            AuthPalette.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                // Content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Alarma")
                                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                                    .foregroundStyle(AuthPalette.white)
                                Text("Configura tu entrenamiento")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundStyle(AuthPalette.textSecondary)
                            }
                            Spacer()
                            // Bookmark button
                            Button(action: { withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) { showSaveSheet = true } }) {
                                Image(systemName: "bookmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(AuthPalette.white)
                                    .frame(width: 36, height: 36)
                                    .background(AuthPalette.backgroundSecondary)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(AuthPalette.fieldBorder, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Guardar Alarma")
                        }
                        .padding(.top, 8)

                        // Adjustable cards
                        VStack(spacing: 16) {
                            AdjustableMetricCard(
                                title: "NÚMERO DE SETS",
                                valueText: "\(sets)",
                                onDecrement: { if sets > 1 { sets -= 1 } },
                                onIncrement: { sets += 1 }
                            )

                            AdjustableMetricCard(
                                title: "TIEMPO DE TRABAJO",
                                valueText: formatTime(workSeconds),
                                onDecrement: { workSeconds = max(0, workSeconds - 5) },
                                onIncrement: { workSeconds += 5 }
                            )

                            AdjustableMetricCard(
                                title: "TIEMPO DE DESCANSO",
                                valueText: formatTime(restSeconds),
                                onDecrement: { restSeconds = max(0, restSeconds - 5) },
                                onIncrement: { restSeconds += 5 }
                            )
                        }

                        // Summary
                        SummaryCard(
                            sets: sets,
                            work: formatTime(workSeconds),
                            rest: formatTime(restSeconds),
                            total: formatTime(totalSeconds)
                        )

                        // Primary CTA
                        Button(action: {}) {
                            HStack(spacing: 10) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Iniciar")
                                    .font(.system(.headline, design: .rounded, weight: .semibold))
                            }
                            .foregroundStyle(Color.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AuthPalette.primaryGreen)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }

                // Bottom Nav Bar
                BottomNavBar(active: .alarm)
            }

            // Save sheet overlay
            if showSaveSheet {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            showSaveSheet = false
                        }
                    }

                SaveAlarmSheet(
                    name: $alarmName,
                    isSaving: isSaving,
                    onClose: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            showSaveSheet = false
                        }
                    },
                    onSave: {
                        guard !isSaving else { return }
                        isSaving = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            isSaving = false
                            showSuccess = true
                        }
                    }
                )
                .transition(.move(edge: .bottom))
                .zIndex(2)
            }

            // Success modal
            if showSuccess {
                SaveSuccessModal(
                    title: "¡Alarma Guardada!",
                    message: "\(alarmName.isEmpty ? "Press Banca" : alarmName) ha sido guardada en tu lista",
                    onConfirm: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            showSuccess = false
                            showSaveSheet = false
                            alarmName = ""
                        }
                    }
                )
                .zIndex(3)
            }
        }
    }

    // MARK: - Helpers
    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

#Preview("AlarmView") {
    AlarmView()
}
