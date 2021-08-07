//
//  saveToLocal.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 23.04.2021.
//

import SwiftUI

func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
}

func saveToFile(fileName: String) {
    let fileNameFinal = fileName.replacingOccurrences(of: "/", with: "-")
    let str = fname(furl: "https://m.habr.com\(fileName)")
    let url = getDocumentsDirectory().appendingPathComponent(fileNameFinal)
    do {
        try str.write(to: url, atomically: true, encoding: .utf8)
    } catch {
        print(error.localizedDescription)
    }
}

func readArticleFromFile(fileName: String) -> String {
    let end = "</div></div></div></article></div></div></main></div></div></body></html>"
    let start2 = """
        <html lang="ru" data-vue-meta="lang">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,user-scalable=0,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
            <link rel="stylesheet" href="https://dr.habracdn.net/habr-web/css/chunk-vendors.027064e3.css">
            <link rel="stylesheet" href="https://dr.habracdn.net/habr-web/css/app.f0824a93.css">
            <link rel="stylesheet" href="https://dr.habracdn.net/habr-web/css/page-article.69cb8646.css">
            <link rel="stylesheet" href="https://dr.habracdn.net/habr-web/css/beta-test~megaprojects~page-article~page-article-comments~page-company~page-flow~page-flows~page-hub~c055b6ea.f054428d.css">
        </head>
        <body>
            <div id="app" data-async-called="true">
            <div class="tm-layout__wrapper tm-fira-loaded">
            <div class="tm-layout"><main class="tm-layout__container">
            <div data-async-called="true" class="tm-page">
            <div class="tm-page-width"><div class="tm-page__wrapper">
            <div class="tm-page__main tm-page__main_has-sidebar">
            <div class="pull-down"><div class="tm-page-article__body">
            <article class="tm-page-article__content tm-page-article__content_inner">
            <div lang="ru" class="tm-article-body">
            <div id="post-content-body" class="article-formatted-body article-formatted-body_version-2">
            <div xmlns="http://www.w3.org/1999/xhtml">
                            <div class="
        """
    let fileNameFinal = fileName.replacingOccurrences(of: "/", with: "-")
    let url = getDocumentsDirectory().appendingPathComponent(fileNameFinal)
    var str: String = ""
    do {
        str = try String(contentsOf: url)
        if let range = str.range(of: "tm-article-body") {
            print("in range")
            str = String(str[range.lowerBound...])
        }
        if let range2 = str.range(of: "tm-article-body__tags") {
            print("in range2")
            str = String(str[...range2.lowerBound])
        } else {
            if let range3 = str.range(of: "tm-article__icons-wrapper") {
                print("in range3")
                str = String(str[range3.lowerBound...])
            }
        }
        str = start2 + str + end
        print("read")
    } catch {
        print(error.localizedDescription)
    }
    
    return str
}

func readTagsFromFile(fileName: String) -> String {
    let fileNameFinal = fileName.replacingOccurrences(of: "/", with: "-")
    let url = getDocumentsDirectory().appendingPathComponent(fileNameFinal)
    var input: String = ""
    do {
        input = try String(contentsOf: url)
        print("read")
    } catch {
        print(error.localizedDescription)
    }
    
    return input
}

func isFileHere(fileName: String) -> Bool {
    let fileNameFinal = fileName.replacingOccurrences(of: "/", with: "-")
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url = NSURL(fileURLWithPath: path)
    if let pathComponent = url.appendingPathComponent(fileNameFinal) {
        let filePath = pathComponent.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            print("isFileHere: FILE AVAILABLE")
            return true
        } else {
            print("isFileHere: FILE NOT AVAILABLE")
            return false
        }
    } else {
        print("isFileHere: FILE PATH NOT AVAILABLE")
        return false
    }
}
