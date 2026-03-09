// AlarmSummaryView.swift
// Final summary screen after finishing the training alarm/timer

import SwiftUI

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

    // Save alarm sheet/modal state
    @State private var showSaveSheet = false
    @State private var showSaveSuccess = false
    @State private var alarmName: String = ""
    @State private var isSaving: Bool = false

    // Layout metrics
    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let bottomButtonsSpacing: CGFloat = 12
        static let emojiSize: CGFloat = 160
    }

    var body: some View {
        ZStack {
            AppPalette.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                Text("😎")
                    .font(.system(size: Layout.emojiSize))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 48)
                    .padding(.bottom, 32)

                SummaryHeader(title: "¡Bien Hecho!", subtitle: subtitleText, imageName: "tabSaved") {
                    showSaveSheet = true
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, 16)

                VStack(spacing: 10) {
                    SummaryStatRow(title: "Tiempo Total", value: totalTime, highlightValue: true)
                    SummaryStatRow(title: "Tiempo de Trabajo", value: workTime)
                    SummaryStatRow(title: "Tiempo de Descanso", value: restTime)
                    SummaryStatRow(title: "Número de Sets", value: "\(setCount)")
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.top, 4)

                Spacer()

                VStack(spacing: Layout.bottomButtonsSpacing) {
                    Button(action: { goToAlarmView = true }) {
                        Text("Continuar")
                            .font(.system(.headline, design: .default, weight: .semibold))
                            .foregroundStyle(Color.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppPalette.primaryGreen)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)

                    Button(action: { goToExecution = true }) {
                        Text("Repetir Entrenamiento")
                            .font(.system(.headline, design: .default))
                            .foregroundStyle(AppPalette.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .fill(AppPalette.backgroundSecondary)
                                    .overlay(
                                        Capsule().stroke(AppPalette.fieldBorder, lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, 24)
            }
        }
        .navigationDestination(isPresented: $goToAlarmView) {
            AlarmView()
        }
        .navigationDestination(isPresented: $goToExecution) {
            AlarmExecutionView()
        }
        .sheet(isPresented: $showSaveSheet) {
            SaveAlarmSheet(
                name: $alarmName,
                isSaving: isSaving,
                onClose: { showSaveSheet = false },
                onSave: performSave
            )
            .presentationDetents([.fraction(0.38)])
            .presentationDragIndicator(.visible)
            .background(AppPalette.backgroundSecondary)
        }
        .overlay(alignment: .center) {
            if showSaveSuccess {
                SaveSuccessModal(
                    title: "¡Alarma Guardada!",
                    message: "\(alarmName.isEmpty ? "Alarma" : alarmName) ha sido guardada en tu lista",
                    onConfirm: {
                        showSaveSuccess = false
                        showSaveSheet = false
                        alarmName = ""
                    }
                )
                .zIndex(3)
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
    var imageName: String? = nil
    var onBookmark: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(AppPalette.white)
                Text(subtitle)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(AppPalette.textSecondary)
            }
            Spacer()
            Button(action: onBookmark) {
                Group {
                    if let imageName, UIImage(named: imageName) != nil {
                        Image(imageName)
                            .renderingMode(.template)
                    } else {
                        Image(systemName: "bookmark")
                    }
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppPalette.white.opacity(0.75))
                .frame(width: 40, height: 40)
                .background(AppPalette.backgroundSecondary)
                .clipShape(Circle())
                .overlay(Circle().stroke(AppPalette.fieldBorder, lineWidth: 1))
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
                .foregroundStyle(AppPalette.textSecondary)
            Spacer()
            Text(value)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(highlightValue ? AppPalette.primaryGreen : AppPalette.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppPalette.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppPalette.fieldBorder, lineWidth: 1)
                )
        )
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
    }
}
