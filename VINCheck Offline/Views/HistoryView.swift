import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: VINCheckViewModel
    @State private var showingClearAlert = false
    @State private var editingNote: VINData?
    @State private var noteText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.history.isEmpty {
                    EmptyHistoryView()
                } else {
                    List {
                        ForEach(viewModel.history) { vinData in
                            HistoryRowView(
                                vinData: vinData,
                                onDelete: {
                                    viewModel.removeFromHistory(vinData)
                                },
                                onEditNote: {
                                    editingNote = vinData
                                    noteText = vinData.note ?? ""
                                }
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.history.isEmpty {
                        Button("Clear") {
                            showingClearAlert = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .alert("Clear history?", isPresented: $showingClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    viewModel.clearHistory()
                }
            } message: {
                Text("This action cannot be undone")
            }
            .sheet(item: $editingNote) { vinData in
                NavigationView {
                    VStack(spacing: 20) {
                        Text("Add Note")
                            .font(.headline)
                            .padding(.top)
                        
                        Text("VIN: \(vinData.vin)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter note...", text: $noteText, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    .navigationTitle("Note")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                editingNote = nil
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                viewModel.addNote(noteText.isEmpty ? "" : noteText, for: vinData.vin)
                                editingNote = nil
                            }
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
}

struct HistoryRowView: View {
    let vinData: VINData
    let onDelete: () -> Void
    let onEditNote: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(vinData.vin)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(formatDate(vinData.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Menu {
                    Button(action: onEditNote) {
                        Label("Add Note", systemImage: "note.text")
                    }
                    
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.secondary)
                }
            }
            
            if let note = vinData.note, !note.isEmpty {
                Text(note)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("History is empty")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your recent VIN checks will appear here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
} 