//
//  ProductDetailView.swift
//  Product Saver
//
//  Created by Justin Aboud on 10/2/2024.
//

import SwiftUI
import SwiftData

struct ProductDetailView: View {
    var storedData: StoredData
    @Environment(\.modelContext) var context
    @State private var isFullScreen = false
    @State private var lastOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var editStoredData: StoredData?
    @State private var confirmProductDeletion = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                List {
                    Section(header: Label("Product Information", systemImage: "note.text")) {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Item Name", systemImage: "tag")
                                .foregroundColor(.gray)
                            Text(storedData.itemName.isEmpty ? "Mandatory item name is blank" : storedData.itemName)
                                .foregroundColor(storedData.itemName.isEmpty ? .red : .primary)
                            Divider()
                            Label("Brand Name", systemImage: "building")
                                .foregroundColor(.gray)
                            Text(storedData.brandName.isEmpty ? "Mandatory brand name is blank" : storedData.brandName)
                            Divider()
                                .foregroundColor(storedData.brandName.isEmpty ? .red : .primary)
                            Label("Category", systemImage: "folder")
                                .foregroundColor(.gray)
                            Text(storedData.category?.categoryName ?? "None")
                            Divider()
                            Label("Description", systemImage: "doc.plaintext")
                                .foregroundColor(.gray)
                            Text(storedData.desc?.isEmpty == true ? "N/A" : storedData.desc ?? "N/A")
                                .lineLimit(nil)
                            Divider()
                            Label("Notes", systemImage: "square.and.pencil")
                                .foregroundColor(.gray)
                            Text(storedData.notes?.isEmpty == true ? "N/A" : storedData.notes ?? "N/A")
                                .lineLimit(nil)
                        }
                    }
                    Section(header: Label("Photo", systemImage: "photo")) {
                        if let selectedPhotoData = storedData.image,
                           let uiImage = UIImage(data: selectedPhotoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .onTapGesture {
                                    isFullScreen.toggle()
                                }
                                .fullScreenCover(isPresented: $isFullScreen) {
                                    ZStack {
                                        Color.black
                                            .ignoresSafeArea()
                                        
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .edgesIgnoringSafeArea(.all)
                                            .gesture(DragGesture()
                                                .onEnded { value in
                                                    let threshold: CGFloat = 100
                                                    if value.translation.height > threshold {
                                                        isFullScreen = false
                                                    }
                                                }
                                            )
                                            .onTapGesture {
                                                isFullScreen.toggle()
                                            }
                                    }
                                }
                        }
                    }

                    Section(header: Label("Modify Product", systemImage: "pencil")) {
                        Button("Edit Product") {
                            withAnimation {
                                editStoredData = storedData
                            }
                        }
                        Button("Delete Product") {
                            confirmProductDeletion = true
                        }
                        .foregroundStyle(.red)
                        .alert(isPresented: $confirmProductDeletion) {
                            Alert(title: Text("Delete Product"),
                                  message: Text("Are you sure you want to delete this product?"),
                                  primaryButton: .destructive(Text("Delete")) {
                                      withAnimation {
                                          context.delete(storedData)
                                          presentationMode.wrappedValue.dismiss()
                                      }
                                  },
                                  secondaryButton: .cancel())
                        }                    }

                }
                .sheet(item: $editStoredData,
                       onDismiss: {
                    editStoredData = nil
                },
                       content: { editData in
                    NavigationStack {
                        UpdateProductDetailsView(storedData: editData)
                            .interactiveDismissDisabled()
                    }
                })
                .navigationTitle("Product Details")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(StoredData.self)
    return ProductDetailView(storedData: StoredData.sampleProducts[4])
        .modelContainer(preview.container)
}
