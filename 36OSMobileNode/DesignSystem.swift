import SwiftUI

enum DS {
    static let background = Color(hex: 0x0B1220)
    static let surface = Color(hex: 0x111C2D)
    static let elevated = Color(hex: 0x19283C)
    static let border = Color(hex: 0x26364A)
    static let primary = Color(hex: 0x38BDF8)
    static let intelligence = Color(hex: 0xA78BFA)
    static let compute = Color(hex: 0x34D399)
    static let warning = Color(hex: 0xFBBF24)
    static let danger = Color(hex: 0xF87171)
    static let text = Color(hex: 0xF1F5F9)
    static let secondary = Color(hex: 0x94A3B8)
}
extension Color {
    init(hex: UInt32) {
        self.init(red: Double((hex >> 16) & 0xFF) / 255, green: Double((hex >> 8) & 0xFF) / 255, blue: Double(hex & 0xFF) / 255)
    }
}
struct DSCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        content.padding(16).frame(maxWidth: .infinity, alignment: .leading)
            .background(DS.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(DS.border, lineWidth: 1))
    }
}
struct StatusPill: View {
    let title: String
    let color: Color
    var body: some View {
        Text(title).font(.caption.weight(.semibold)).foregroundStyle(color)
            .padding(.horizontal, 10).padding(.vertical, 6).background(color.opacity(0.13), in: Capsule())
    }
}
struct SectionHeading: View {
    let title: String
    var action: String? = nil
    var body: some View {
        HStack { Text(title).font(.headline).foregroundStyle(DS.text); Spacer()
            if let action { Text(action).font(.caption.weight(.medium)).foregroundStyle(DS.primary) }
        }
    }
}
struct MetricTile: View {
    let title: String
    let value: String
    let symbol: String
    let tint: Color
    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: symbol).font(.title3).foregroundStyle(tint)
                Text(value).font(.system(size: 27, weight: .semibold, design: .rounded)).foregroundStyle(DS.text)
                Text(title).font(.caption).foregroundStyle(DS.secondary).lineLimit(2)
            }
        }
    }
}
struct PageScaffold<Content: View>: View {
    let title: String
    let subtitle: String?
    @ViewBuilder let content: Content
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title).font(.largeTitle.bold()).foregroundStyle(DS.text)
                    if let subtitle { Text(subtitle).font(.subheadline).foregroundStyle(DS.secondary) }
                }
                content
            }.padding(20).padding(.bottom, 24)
        }
        .background(DS.background.ignoresSafeArea())
        .toolbarBackground(DS.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}