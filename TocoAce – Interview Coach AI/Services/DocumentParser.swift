//
//  DocumentParser.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import Foundation
import PDFKit
import AppKit

class DocumentParser {
    static func parseDocument(url: URL) -> String? {
        let fileExtension = url.pathExtension.lowercased()
        
        switch fileExtension {
        case "pdf":
            return parsePDF(url: url)
        case "doc", "docx":
            return parseDOCX(url: url)
        case "txt":
            return try? String(contentsOf: url, encoding: .utf8)
        default:
            return nil
        }
    }
    
    private static func parsePDF(url: URL) -> String? {
        guard let document = PDFDocument(url: url) else {
            return nil
        }
        
        var text = ""
        for pageIndex in 0..<document.pageCount {
            if let page = document.page(at: pageIndex),
               let pageText = page.string {
                text += pageText + "\n"
            }
        }
        
        return text.isEmpty ? nil : text
    }
    
    private static func parseDOCX(url: URL) -> String? {
        // For DOCX, we'll use a simple approach - try to read as plain text
        // In production, you might want to use a dedicated library
        
        // Try to read with NSAttributedString
        if let attributedString = try? NSAttributedString(url: url, options: [:], documentAttributes: nil) {
            return attributedString.string
        }
        
        // Fallback to plain text
        return try? String(contentsOf: url, encoding: .utf8)
    }
}


