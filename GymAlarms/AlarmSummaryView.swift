// AlarmSummaryView.swift
// Final summary screen after finishing the training alarm/timer

import SwiftUI

// MARK: - Local Palette (aligned with AlarmExecutionView)
private enum SummaryPalette {
    static let background = Color(hex: "071416")
    static let cardBackground = Color(hex: "0D2226")
    static let border = Color(hex: "FFFFFF", alpha: 0.12)
    static let white = Color(hex: "FFFFFF")
    static let white75 = Color(hex: "FFFFFF", alpha: 0.75)
    static let white60 = Color(hex: "FFFFFF", alpha: 0.60)
    static let white45 = Color(hex: "FFFFFF", alpha: 0.45)
    static let white28 = Color(hex: "FFFFFF", alpha: 0.28)
    static let white12 = Color(hex: "FFFFFF", alpha: 0.12)
    static let primaryGreen = Color(hex: "BDFF00")
}

// Local hex helper if not globally available
private extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hexSanitized.count {
        case 3: (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: alpha)
    }
}

// MARK: - AlarmSummaryView
struct AlarmSummaryView: View {
    // Inputs
    let totalTime: String
    let workTime: String
    let restTime: String
    let setCount: Int
    let subtitleText: String

    // Navigation
    @State private var goToAlarmView = false
    @State private var goToExecution = false

    // Save alarm sheet/modal state (reusing existing flow by interface)
    @State private var showSaveSheet = false
    @State private var showSaveSuccess = false
    @State private var alarmName: String = ""
    @State private var isSaving: Bool = false

    // Layout metrics
    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let dividerHeight: CGFloat = 1
        static let bottomButtonsSpacing: CGFloat = 12
        static let emojiSize: CGFloat = 64
    }

    var body: some View {
        ZStack {
            SummaryPalette.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Emoji top
                Text("😎")
                    .font(.system(size: Layout.emojiSize))
                    .padding(.top, 24)
                    .padding(.bottom, 16)

                // Divider subtle
                Rectangle()
                    .fill(SummaryPalette.white12)
                    .frame(height: Layout.dividerHeight)
                    .opacity(0.6)
                    .padding(.horizontal, Layout.horizontalPadding)

                // Header + bookmark
                SummaryHeader(title: "¡Bien Hecho!", subtitle: subtitleText, onBookmark: {
                    showSaveSheet = true
                })
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.top, 16)
                .padding(.bottom, 8)

                // Stats
                VStack(spacing: 10) {
                    SummaryStatRow(title: "Tiempo Total", value: totalTime, highlightValue: true)
                    SummaryStatRow(title: "Tiempo de Trabajo", value: workTime)
                    SummaryStatRow(title: "Tiempo de Descanso", value: restTime)
                    SummaryStatRow(title: "Número de Sets", value: "\(setCount)")
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.top, 4)

                Spacer()

                // Bottom buttons
                VStack(spacing: Layout.bottomButtonsSpacing) {
                    // Continuar -> AlarmView
                    NavigationLink(destination: AlarmView(), isActive: $goToAlarmView) { EmptyView() }
                        .hidden()

                    Button(action: { goToAlarmView = true }) {
                        Text("Continuar")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(Color.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(SummaryPalette.primaryGreen)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)

                    // Repetir Entrenamiento -> AlarmExecutionView
                    NavigationLink(destination: AlarmExecutionView(), isActive: $goToExecution) { EmptyView() }
                        .hidden()

                    Button(action: { goToExecution = true }) {
                        Text("Repetir Entrenamiento")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(SummaryPalette.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .fill(SummaryPalette.cardBackground)
                                    .overlay(
                                        Capsule().stroke(SummaryPalette.border, lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, 24)
            }
        }
        .sheet(isPresented: $showSaveSheet) {
            SaveAlarmSheet(name: $alarmName, isSaving: $isSaving, isPresented: $showSaveSheet, onSave: performSave)
                .presentationDetents([.fraction(0.38)])
                .presentationDragIndicator(.visible)
                .background(SummaryPalette.background)
        }
        .overlay(alignment: .center) {
            if showSaveSuccess {
                SaveSuccessModalView(title: "¡Alarma Guardada!", subtitle: "\(alarmName.isEmpty ? "Alarma" : alarmName) ha sido guardada en tu lista", buttonTitle: "Perfecto") {
                    showSaveSuccess = false
                    showSaveSheet = false
                }
            }
        }
    }

    // MARK: - Save
    private func performSave() {
        guard !isSaving else { return }
        isSaving = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isSaving = false
            showSaveSuccess = true
        }
    }
}

// MARK: - SummaryHeader
private struct SummaryHeader: View {
    let title: String
    let subtitle: String
    var onBookmark: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(SummaryPalette.white)
                Text(subtitle)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(SummaryPalette.white60)
            }
            Spacer()
            Button(action: onBookmark) {
                Image(systemName: "bookmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(SummaryPalette.white75)
                    .frame(width: 40, height: 40)
                    .background(SummaryPalette.cardBackground)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(SummaryPalette.border, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - SummaryStatRow
private struct SummaryStatRow: View {
    let title: String
    let value: String
    var highlightValue: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(SummaryPalette.white60)
            Spacer()
            Text(value)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(highlightValue ? SummaryPalette.primaryGreen : SummaryPalette.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(SummaryPalette.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(SummaryPalette.border, lineWidth: 1)
                )
        )
    }
}

// MARK: - SaveSuccessModalView (reusable facade)
private struct SaveSuccessModalView: View {
    let title: String
    let subtitle: String
    let buttonTitle: String
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            SummaryPalette.background.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(SummaryPalette.white)
                Text(subtitle)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(SummaryPalette.white60)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                Button(action: onDismiss) {
                    Text(buttonTitle)
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(SummaryPalette.primaryGreen)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(SummaryPalette.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(SummaryPalette.border, lineWidth: 1))
            )
            .padding(32)
        }
    }
}

// MARK: - Preview
#Preview("AlarmSummaryView") {
    NavigationStack {
        AlarmSummaryView(
            totalTime: "03:15",
            workTime: "02:15",
            restTime: "01:00",
            setCount: 3,
            subtitleText: "3 series completadas"
        )
        .toolbar(.hidden)
    }
}

