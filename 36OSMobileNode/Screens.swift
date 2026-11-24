import SwiftUI

struct HomeView: View {
    let language: AppLanguage
    let density: InformationDensity
    var body: some View {
        PageScaffold(title: Copy.text("command_center", language), subtitle: Copy.text("overview", language)) {
            DSCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label(Copy.text("system_health", language), systemImage: "waveform.path.ecg").font(.headline).foregroundStyle(DS.text)
                        Spacer()
                        StatusPill(title: Copy.text("awaiting", language), color: DS.warning)
                    }
                    Text(Copy.text("not_connected", language)).font(.title2.bold()).foregroundStyle(DS.text)
                    Text(Copy.text("preview_data", language)).font(.caption).foregroundStyle(DS.secondary)
                }
            }
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MetricTile(title: Copy.text("nodes", language), value: "—", symbol: "cpu", tint: DS.compute)
                MetricTile(title: Copy.text("active_workers", language), value: "—", symbol: "point.3.connected.trianglepath.dotted", tint: DS.primary)
                MetricTile(title: Copy.text("queued_tasks", language), value: "—", symbol: "list.bullet.rectangle", tint: DS.warning)
                MetricTile(title: Copy.text("models", language), value: "—", symbol: "brain.head.profile", tint: DS.intelligence)
            }
            SectionHeading(title: Copy.text("quick_actions", language))
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ActionTile(title: Copy.text("register_node", language), symbol: "iphone", tint: DS.compute)
                ActionTile(title: Copy.text("create_worker", language), symbol: "plus.square.on.square", tint: DS.primary)
                ActionTile(title: Copy.text("model_manager", language), symbol: "cpu", tint: DS.intelligence)
                ActionTile(title: Copy.text("security", language), symbol: "shield.lefthalf.filled", tint: DS.warning)
            }
            SectionHeading(title: Copy.text("recent_activity", language))
            DSCard { Label(Copy.text("no_events", language), systemImage: "clock").font(.subheadline).foregroundStyle(DS.secondary) }
        }
        .toolbar { ToolbarItem(placement: .principal) { Text("36OS").font(.headline.weight(.bold)).tracking(1.5).foregroundStyle(DS.text) } }
    }
}
struct ActionTile: View {
    let title: String
    let symbol: String
    let tint: Color
    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: symbol).font(.title2).foregroundStyle(tint)
                Text(title).font(.subheadline.weight(.semibold)).foregroundStyle(DS.text)
            }
        }
    }
}
struct FeatureRow: View {
    let title: String
    let subtitle: String
    let symbol: String
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: symbol).font(.title3).foregroundStyle(DS.primary).frame(width: 38, height: 38)
                .background(DS.elevated, in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.subheadline.weight(.semibold)).foregroundStyle(DS.text)
                Text(subtitle).font(.caption).foregroundStyle(DS.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundStyle(DS.secondary)
        }.padding(.vertical, 5)
    }
}
struct FeatureListView: View {
    let title: String
    let subtitle: String
    let symbol: String
    let language: AppLanguage
    let density: InformationDensity
    var body: some View {
        PageScaffold(title: title, subtitle: subtitle) {
            DSCard {
                VStack(alignment: .leading, spacing: 12) {
                    StatusPill(title: Copy.text("pending", language), color: DS.warning)
                    Text(Copy.text("not_implemented", language)).font(.subheadline).foregroundStyle(DS.secondary)
                }
            }
            DSCard {
                VStack(spacing: 16) {
                    FeatureRow(title: Copy.text("status", language), subtitle: Copy.text("preview_data", language), symbol: "waveform.path")
                    Divider().overlay(DS.border)
                    FeatureRow(title: Copy.text("protocol", language), subtitle: "Compute Node Protocol v1", symbol: "point.3.connected.trianglepath.dotted")
                    if density != .simple {
                        Divider().overlay(DS.border)
                        FeatureRow(title: Copy.text("trust", language), subtitle: "Pending approval · Server authoritative", symbol: "lock.shield")
                        Divider().overlay(DS.border)
                        FeatureRow(title: Copy.text("platform", language), subtitle: "iOS · Native SwiftUI", symbol: "iphone")
                    }
                }
            }
        }
    }
}
struct ModuleListView: View {
    let title: String
    let subtitle: String
    let items: [(String, String, String)]
    let language: AppLanguage
    let density: InformationDensity
    var body: some View {
        PageScaffold(title: title, subtitle: subtitle) {
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                NavigationLink {
                    FeatureListView(title: Copy.text(item.0, language), subtitle: Copy.text("not_implemented", language), symbol: item.1, language: language, density: density)
                } label: {
                    DSCard { FeatureRow(title: Copy.text(item.0, language), subtitle: Copy.text("preview_data", language), symbol: item.1) }
                }.buttonStyle(.plain)
            }
        }
    }
}
struct ComputeView: View {
    let language: AppLanguage
    let density: InformationDensity
    var body: some View {
        ModuleListView(title: Copy.text("compute", language), subtitle: "Compute Node Management", items: [
            ("this_device","iphone",""),("node_registry","point.3.connected.trianglepath.dotted",""),
            ("hardware","cpu",""),("resources","slider.horizontal.3",""),("profiles","gauge",""),
            ("network","network",""),("diagnostics","stethoscope","")
        ], language: language, density: density)
    }
}
struct WorkersView: View {
    let language: AppLanguage
    let density: InformationDensity
    var body: some View {
        ModuleListView(title: Copy.text("workers", language), subtitle: "Worker Operations & Task Orchestration", items: [
            ("worker_overview","rectangle.3.group",""),("worker_registry","list.bullet.rectangle",""),
            ("groups","square.grid.2x2",""),("builder","hammer",""),("task_queue","tray.full",""),
            ("history","clock.arrow.circlepath",""),("templates","doc.on.doc",""),("permissions","lock.shield","")
        ], language: language, density: density)
    }
}
struct IntelligenceView: View {
    let language: AppLanguage
    let density: InformationDensity
    var body: some View {
        ModuleListView(title: Copy.text("intelligence", language), subtitle: "Models · Algorithms · Controlled Evolution", items: [
            ("local_models","brain.head.profile",""),("model_manager","shippingbox",""),
            ("inference","waveform",""),("algorithm_lab","function",""),
            ("simulation","testtube.2",""),("benchmark","chart.bar.xaxis",""),("proposals","arrow.triangle.2.circlepath","")
        ], language: language, density: density)
    }
}
struct SystemView: View {
    let language: AppLanguage
    let density: InformationDensity
    @Binding var languageRaw: String
    @Binding var densityRaw: String
    var body: some View {
        PageScaffold(title: Copy.text("system", language), subtitle: "Identity · Security · Governance · Infrastructure") {
            DSCard {
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeading(title: Copy.text("language", language))
                    Picker(Copy.text("language", language), selection: $languageRaw) {
                        ForEach(AppLanguage.allCases) { item in Text(item.displayName).tag(item.rawValue) }
                    }.pickerStyle(.segmented)
                    SectionHeading(title: Copy.text("density", language))
                    Picker(Copy.text("density", language), selection: $densityRaw) {
                        ForEach(InformationDensity.allCases) { item in Text(Copy.text(item.rawValue, language)).tag(item.rawValue) }
                    }.pickerStyle(.segmented)
                    Text(Copy.text("manual", language)).font(.caption).foregroundStyle(DS.secondary)
                }
            }
            ModuleListView(title: Copy.text("system", language), subtitle: "System configuration and governance", items: [
                ("cie_connection","point.3.connected.trianglepath.dotted",""),("os_connection","externaldrive.connected.to.line.below",""),
                ("creator","crown",""),("identity","person.badge.key",""),("security","shield.lefthalf.filled",""),
                ("audit","doc.text.magnifyingglass",""),("backup","externaldrive",""),("versions","arrow.down.circle",""),
                ("advanced","slider.horizontal.3","")
            ], language: language, density: density)
            DSCard {
                VStack(alignment: .leading, spacing: 10) {
                    Label(Copy.text("emergency", language), systemImage: "stop.circle").font(.headline).foregroundStyle(DS.danger)
                    Text(Copy.text("permissions_note", language)).font(.caption).foregroundStyle(DS.secondary)
                    Text(Copy.text("not_implemented", language)).font(.caption).foregroundStyle(DS.secondary)
                }
            }
        }
    }
}