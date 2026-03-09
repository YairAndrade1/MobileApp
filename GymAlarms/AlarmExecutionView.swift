// AlarmExecutionView.swift
// Premium, dark, minimal execution screen for a training timer

import SwiftUI

// MARK: - Color Helpers
private extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hexSanitized.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: alpha)
    }
}

// MARK: - Design Palette
private enum AlarmPalette {
    static let white = Color(hex: "FFFFFF")
    static let white30 = Color(hex: "FFFFFF", alpha: 0.30)
    static let white45 = Color(hex: "FFFFFF", alpha: 0.45)
    static let white75 = Color(hex: "FFFFFF", alpha: 0.75)
    static let white28 = Color(hex: "FFFFFF", alpha: 0.28)
    static let white12 = Color(hex: "FFFFFF", alpha: 0.12)
    static let white10 = Color(hex: "FFFFFF", alpha: 0.10)
    static let white9  = Color(hex: "FFFFFF", alpha: 0.09)
    static let white7  = Color(hex: "FFFFFF", alpha: 0.07)
    static let white6  = Color(hex: "FFFFFF", alpha: 0.06)

    static let background = Color(hex: "071416")
    static let primaryGreen = Color(hex: "BDFF00")
    static let restBlue = Color(hex: "0A84FF")

    static let workTrack = Color(hex: "4A6303")
    static let restTrack = Color(hex: "174471")
}

// MARK: - Domain
private enum Phase {
    case work
    case rest
}

// MARK: - AlarmExecutionView
struct AlarmExecutionView: View {
    // State
    @Environment(\.dismiss) private var dismiss

    @State private var totalSets: Int = 3
    @State private var currentSet: Int = 1
    @State private var phase: Phase = .work

    @State private var workDuration: TimeInterval = 45
    @State private var restDuration: TimeInterval = 20

    @State private var remaining: TimeInterval = 45
    @State private var totalPhaseDuration: TimeInterval = 45

    @State private var isPaused: Bool = false

    // Timer simulation
    @State private var timer: Timer?

    // Layout metrics
    @ScaledMetric(relativeTo: .largeTitle) private var ringSize: CGFloat = 280
    @ScaledMetric private var ringLineWidth: CGFloat = 18
    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let headerTopPadding: CGFloat = 12
        static let headerBottomSpacing: CGFloat = 12
        static let controlsBottomPadding: CGFloat = 24
    }

    var body: some View {
        ZStack {
            AlarmPalette.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                ExecutionHeaderView(currentSet: currentSet, totalSets: totalSets) {
                    dismiss()
                }
                .padding(.top, Layout.headerTopPadding)
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.headerBottomSpacing)

                // Sets indicator
                SetProgressIndicator(total: totalSets, current: currentSet)
                    .padding(.horizontal, Layout.horizontalPadding)
                    .padding(.bottom, 8)

                Spacer(minLength: 12)

                // Title by phase
                Text(phase == .work ? "Tiempo de Trabajo" : "Tiempo de Descanso")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(phase == .work ? AlarmPalette.primaryGreen : AlarmPalette.restBlue)
                    .padding(.bottom, 12)

                // Progress Ring
                ProgressRingView(
                    size: ringSize,
                    lineWidth: ringLineWidth,
                    progress: progress,
                    trackColor: phase == .work ? AlarmPalette.workTrack : AlarmPalette.restTrack,
                    progressColor: phase == .work ? AlarmPalette.primaryGreen : AlarmPalette.restBlue,
                    timeText: timeFormatted(remaining),
                    labelText: phase == .work ? "TRABAJO" : "DESCANSO"
                )
                .padding(.vertical, 8)

                Spacer()

                // Divider subtle
                Rectangle()
                    .fill(AlarmPalette.white12)
                    .frame(height: 1)
                    .opacity(0.6)
                    .padding(.horizontal, Layout.horizontalPadding)

                // Controls
                ExecutionControlsView(
                    isPaused: isPaused,
                    primaryColor: phase == .work ? AlarmPalette.primaryGreen : AlarmPalette.restBlue,
                    onBack15: { adjustTime(by: -15) },
                    onTogglePlayPause: togglePause,
                    onForward15OrNext: { adjustTime(by: 15) }
                )
                .padding(.top, 12)
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.controlsBottomPadding)
            }
        }
        .onAppear { startPhase(.work, set: 1) }
        .onDisappear { invalidateTimer() }
        .animation(.easeInOut(duration: 0.25), value: phase)
        .animation(.easeInOut(duration: 0.25), value: currentSet)
    }

    private var progress: Double {
        guard totalPhaseDuration > 0 else { return 0 }
        let done = totalPhaseDuration - remaining
        return max(0, min(1, done / totalPhaseDuration))
    }

    // MARK: - Phase Control
    private func startPhase(_ newPhase: Phase, set: Int) {
        phase = newPhase
        currentSet = set
        totalPhaseDuration = (newPhase == .work) ? workDuration : restDuration
        remaining = totalPhaseDuration
        isPaused = false
        startTimer()
    }

    private func startTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard !isPaused else { return }
            tick()
        }
    }

    private func tick() {
        if remaining > 0 {
            remaining -= 1
        } else {
            // Transition
            advancePhase()
        }
    }

    private func advancePhase() {
        switch phase {
        case .work:
            startPhase(.rest, set: currentSet)
        case .rest:
            if currentSet < totalSets {
                startPhase(.work, set: currentSet + 1)
            } else {
                // End reached: simple stop
                isPaused = true
                invalidateTimer()
            }
        }
    }

    private func togglePause() {
        isPaused.toggle()
        if !isPaused, timer == nil { startTimer() }
    }

    private func adjustTime(by delta: TimeInterval) {
        if delta < 0 {
            remaining = max(0, remaining + delta)
        } else {
            // If adding beyond phase, jump to next phase for a simple UX
            if remaining - delta <= 0 {
                remaining = 0
                advancePhase()
            } else {
                remaining -= delta
            }
        }
    }

    private func timeFormatted(_ seconds: TimeInterval) -> String {
        let s = Int(max(0, seconds))
        let mPart = s / 60
        let sPart = s % 60
        return String(format: "%02d:%02d", mPart, sPart)
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - ExecutionHeaderView
private struct ExecutionHeaderView: View {
    let currentSet: Int
    let totalSets: Int
    var onBack: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AlarmPalette.white75)
                    .frame(width: 36, height: 36)
                    .background(AlarmPalette.white7)
                    .clipShape(Circle())
            }
            Text("Alarma")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(AlarmPalette.white75)
                .padding(.leading, 6)

            Spacer()

            HStack(spacing: 8) {
                Text("Serie \(currentSet) / \(totalSets)")
                    .font(.system(.footnote, design: .rounded, weight: .semibold))
                    .foregroundStyle(AlarmPalette.white75)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(AlarmPalette.white9)
                            .overlay(
                                Capsule()
                                    .stroke(AlarmPalette.white12, lineWidth: 1)
                            )
                    )
            }
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - SetProgressIndicator
private struct SetProgressIndicator: View {
    let total: Int
    let current: Int

    private enum Metrics {
        static let heightInactive: CGFloat = 6
        static let heightActive: CGFloat = 8
        static let widthInactive: CGFloat = 20
        static let widthActive: CGFloat = 38
        static let spacing: CGFloat = 8
    }

    var body: some View {
        HStack(spacing: Metrics.spacing) {
            ForEach(1...total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? AlarmPalette.white28 : AlarmPalette.white10)
                    .frame(width: index == current ? Metrics.widthActive : Metrics.widthInactive,
                           height: index == current ? Metrics.heightActive : Metrics.heightInactive)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - ProgressRingView
private struct ProgressRingView: View {
    let size: CGFloat
    let lineWidth: CGFloat
    let progress: Double // 0...1
    let trackColor: Color
    let progressColor: Color
    let timeText: String
    let labelText: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(trackColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .opacity(0.6)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)
                .animation(.easeInOut(duration: 0.25), value: progress)

            VStack(spacing: 6) {
                Text(timeText)
                    .font(.system(size: size * 0.18, weight: .bold, design: .rounded))
                    .foregroundStyle(AlarmPalette.white)
                    .monospacedDigit()
                Text(labelText)
                    .font(.system(.footnote, design: .rounded, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(AlarmPalette.white45)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Progreso")
        .accessibilityValue("\(Int(progress * 100)) por ciento")
    }
}

// MARK: - ExecutionControlsView
private struct ExecutionControlsView: View {
    let isPaused: Bool
    let primaryColor: Color
    let onBack15: () -> Void
    let onTogglePlayPause: () -> Void
    let onForward15OrNext: () -> Void

    private enum Metrics {
        static let buttonSize: CGFloat = 68
        static let iconSize: CGFloat = 22
        static let spacing: CGFloat = 22
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: Metrics.spacing) {
                CircleButton(style: .secondary, size: Metrics.buttonSize, iconSize: Metrics.iconSize, iconName: "gobackward.15", color: primaryColor, action: onBack15)

                CircleButton(style: .primary, size: Metrics.buttonSize + 10, iconSize: Metrics.iconSize + 2, iconName: isPaused ? "play.fill" : "pause.fill", color: primaryColor, action: onTogglePlayPause)

                CircleButton(style: .secondary, size: Metrics.buttonSize, iconSize: Metrics.iconSize, iconName: "goforward.15", color: primaryColor, action: onForward15OrNext)
            }
            Text("Saltar fase")
                .font(.system(.footnote, design: .rounded))
                .foregroundStyle(AlarmPalette.white45)
                .padding(.top, 2)
        }
    }
}

private enum CircleButtonStyleKind { case primary, secondary }

private struct CircleButton: View {
    let style: CircleButtonStyleKind
    let size: CGFloat
    let iconSize: CGFloat
    let iconName: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundStyle(style == .primary ? Color.black : AlarmPalette.white75)
                .frame(width: size, height: size)
                .background(
                    Group {
                        if style == .primary {
                            Circle().fill(color)
                        } else {
                            Circle()
                                .fill(AlarmPalette.white6)
                                .overlay(Circle().stroke(AlarmPalette.white12, lineWidth: 1))
                        }
                    }
                )
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
    }
}

// MARK: - Preview
#Preview("AlarmExecutionView") {
    NavigationStack {
        AlarmExecutionView()
            .toolbar(.hidden)
    }
}

