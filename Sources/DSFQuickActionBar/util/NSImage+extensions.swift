//
//  NSImage+extensions.swift
//
//  Created by Darren Ford on 22/7/21
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import AppKit

extension NSImage {
	/// Create an image by drawing into it via a block
	static func CreateARGB32(width: Int, height: Int, drawBlock: () throws -> Void) rethrows -> NSImage {
		let offscreenRep = NSBitmapImageRep(
			bitmapDataPlanes: nil,
			pixelsWide: width,
			pixelsHigh: height,
			bitsPerSample: 8,
			samplesPerPixel: 4,
			hasAlpha: true,
			isPlanar: false,
			colorSpaceName: NSColorSpaceName.calibratedRGB,
			bytesPerRow: 0, bitsPerPixel: 0
		)!

		let g = NSGraphicsContext(bitmapImageRep: offscreenRep)

		do {
			NSGraphicsContext.saveGraphicsState()
			defer {
				NSGraphicsContext.restoreGraphicsState()
			}

			NSGraphicsContext.current = g
			try drawBlock()
		}

		let image = NSImage(size: NSSize(width: width, height: height))
		image.addRepresentation(offscreenRep)
		return image
	}
}
