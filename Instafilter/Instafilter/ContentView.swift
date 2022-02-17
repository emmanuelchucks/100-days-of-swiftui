//
//  ContentView.swift
//  Instafilter
//
//  Created by Emmanuel Chucks on 11/12/2021.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var showingFilterSheet = false
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                VStack {
                    HStack {
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                    }
                    .onChange(of: filterIntensity) { _ in applyProcessing() }
                    
                    HStack {
                        Text("Radius")
                        Slider(value: $filterRadius)
                    }
                    .onChange(of: filterRadius) { _ in applyProcessing() }
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: saveImage)
                        .disabled(inputImage == nil)
                }
                
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                VStack {
                    Group {
                        Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                        Button("Edges") { setFilter(CIFilter.edges()) }
                        Button("Guassian Blur") { setFilter(CIFilter.gaussianBlur()) }
                        Button("Pixelate") { setFilter(CIFilter.pixellate()) }
                        Button("Serpia Tone") { setFilter(CIFilter.sepiaTone()) }
                        Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                        Button("Vignette") { setFilter(CIFilter.vignette()) }
                        Button("Bokeh Blur") { setFilter(CIFilter.bokehBlur()) }
                        Button("Monochrome") { setFilter(CIFilter.colorMonochrome()) }
                        Button("Comic Effect") { setFilter(CIFilter.comicEffect()) }
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func saveImage() {
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        imageSaver.successHandler = {
            print("Saved successfully")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            processedImage = uiImage
            image = Image(uiImage: uiImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
