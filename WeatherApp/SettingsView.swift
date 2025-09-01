import SwiftUI

struct SettingsView: View {
    var onSave: () -> Void
    // ── Persisted values (what the rest of the app reads) ───────────
    @AppStorage("pref_gender") private var storedGender = Gender.male.rawValue
    @AppStorage("pref_cold")   private var storedCold   = ColdProfile.neutral.rawValue
    @AppStorage("pref_style")  private var storedStyle  = BroadStyle.casual.rawValue

    // ── Scratch-pad state edited by the user ────────────────────────
    @State private var gender:      Gender       = .male
    @State private var cold:        ColdProfile  = .neutral
    @State private var style:       BroadStyle   = .casual
   

    @Environment(\.dismiss) private var dismiss

    // Initialise the scratch values from storage
    init(onSave: @escaping () -> Void) {
        self.onSave = onSave
        _gender = State(initialValue: Gender(rawValue: storedGender) ?? .male)
        _cold   = State(initialValue: ColdProfile(rawValue: storedCold) ?? .neutral)
        _style  = State(initialValue: BroadStyle(rawValue: storedStyle) ?? .casual)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Identity")) {
                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases) { Text($0.label).tag($0) }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Cold Tolerance")) {
                    Picker("I usually…", selection: $cold) {
                        ForEach(ColdProfile.allCases) { Text($0.rawValue).tag($0) }
                    }
                }

                Section(header: Text("Broad Style")) {
                    Picker("Style", selection: $style) {
                        ForEach(BroadStyle.allCases) { Text($0.label).tag($0) }
                    }
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle("Your Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }             // discard edits
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveAndDismiss() }        // persist edits
                        .disabled(!hasChanges)
                }
            }
        }
    }

    // ── Helpers ─────────────────────────────────────────────────────
    private var hasChanges: Bool {
        gender.rawValue != storedGender ||
        cold.rawValue   != storedCold   ||
        style.rawValue  != storedStyle
    }

    private func saveAndDismiss() {
        storedGender = gender.rawValue
        storedCold   = cold.rawValue
        storedStyle  = style.rawValue
        onSave() // 👈 trigger parent callback

        dismiss()
    }
}
