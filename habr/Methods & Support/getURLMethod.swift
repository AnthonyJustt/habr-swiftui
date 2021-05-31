//
//  getURLMethod.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 22.03.2021.
//

import Foundation
import SwiftSoup

func fname(furl: String) -> String {
    var contents: String = ""
    
    let encodedUrl = furl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    print("fname: \(furl)")
    
    if let url = URL(string: encodedUrl) {
        do {
            contents = try String(contentsOf: url)
            print("fname: content was successfully received")
        } catch {
            print("fname: contents could not be loaded")
        }
    } else {
        print("fname: the URL was bad!")
    }
    
    //    if let filepath = Bundle.main.path(forResource: "example_", ofType: "txt") {
    //        do {
    //            contents = try String(contentsOfFile: filepath)
    //        } catch {
    //            print("contents could not be loaded")
    //        }
    //    } else {
    //        print("example.txt not found!")
    //    }
    return contents
}

func fparse(fhtml: String) -> Array<FeedListItem> {
    
    // парсим мобильную страницу хабра со списком новостей для главного экрана приложения, экрана с новостями
    
    var arrayToReturn: [FeedListItem] = []
    
    var s: String = "nil"
    
    do {
        let html: String = fhtml;
        let els: Elements = try SwiftSoup.parse(html).select("a.tm-article-snippet__title-link") // заголовок статье
        let els1: Elements = try SwiftSoup.parse(html).select("a.tm-user-info__username") // автор статьи
        let els2: Elements = try SwiftSoup.parse(html).select("span.tm-icon-wrapper__value") // количество просмотров
        let els3: Elements = try SwiftSoup.parse(html).select("span.bookmarks-button__counter") // закладки
        let els4: Elements = try SwiftSoup.parse(html).select("time") // дата статьи
        let els5: Elements = try SwiftSoup.parse(html).select("span.tm-votes-meter__value") // рейтинг статьи
        let els6: Elements = try SwiftSoup.parse(html).select("span.tm-article-comments-counter-link__value") // комментарии к статье
        let els7: Elements = try SwiftSoup.parse(html).select("div.tm-article-body__content") // превью статьи
        
        for i in 0 ..< els.array().count {
            
            if i >= 0 && i < els6.array().count {
                s = try els6[i].text()
            }
            
            arrayToReturn.append(FeedListItem(
                title: try els[i].text(),
                author: try els1[i].text(),
                author_link: try els1[i].attr("href"),
                date: try els4[i].text(),
                rate: try els5[i].text(),
                rate_detail: try els5[i].attr("title"),
                view: try els2[i].text(),
                bookmark: try els3[i].text(),
                comments: s, //try els6[i].text(),
                link: try els[i].attr("href"),
                article_snippet: try els7[i].html(),
                offset: 0,
                isSwiped: false
            ))
        }
        // let linkOuterH: String = try link.outerHtml(); // "<a href="http://example.com"><b>example</b></a>"
        // let linkInnerH: String = try link.html(); // "<b>example</b>"
        print("fparse: content was successfully parsed")
    }
    catch Exception.Error(let type, let message) {
        print(type, message)
    }
    catch {
        print("error")
    }
    return arrayToReturn
}

func fparseNews(fhtml: String) -> Array<FeedNewsItem> {
    
    // парсим новости с первой страницы хабра для главного экрана приложения
    
    var arrayToReturn: [FeedNewsItem] = []
    do {
        let html: String = fhtml;
        let els: Elements = try SwiftSoup.parse(html).select("a.tm-news-block__title-link") // мини-новости - заголовок
        let els4: Elements = try SwiftSoup.parse(html).select("time.tm-news-block__date") // дата новости
        let els6: Elements = try SwiftSoup.parse(html).select("span.tm-news-block__comments") // количество комментариев к новости
        for i in 0 ..< els.array().count {
            arrayToReturn.append(FeedNewsItem(
                title: try els[i].text(),
                date: try els4[i].text(),
                comments: try els6[i].text(),
                link: ""//try els[i].attr("href")
            ))
        }
        print("fparseNews: content was successfully parsed")
    }
    catch Exception.Error(let type, let message) {
        print(type, message)
    }
    catch {
        print("error")
    }
    return arrayToReturn
}

func fparseTags(fhtml: String) -> (hubs: Array<feedTagsItem>, tags: Array<feedTagsItem>, labels: Array<feedTagsItem>, originals: Array<feedTagsItem>) {
    
    // получаем список хабов, тегов, лейблов ("Перевод" + ссылка на оригинал, "Из песочницы", "Туториал") в статье
    
    var hubsToReturn: [feedTagsItem] = []
    var tagsToReturn: [feedTagsItem] = []
    var labelsToReturn: [feedTagsItem] = []
    var originalsToReturn: [feedTagsItem] = []
    
    do {
        let html: String = fhtml;
        let els: Elements = try SwiftSoup.parse(html).select("a.tm-article-snippet__hubs-item-link") // хабы в статье
        
        let els1: Elements = try SwiftSoup.parse(html).select("div.tm-article-snippet__label") // лейблы статьи
        let els2: Elements = try SwiftSoup.parse(html).select("a.tm-page-article__origin-link") // ссылка на оригинал для перевода
        
        let els4: Elements = try SwiftSoup.parse(html).select("div.tm-article-body__tags-links") // общий раздел с тегами и хабами в статье
        let ssttrr = try els4[0].html()
        let els6: Elements = try SwiftSoup.parse(ssttrr).select("a.tm-article-body__tags-item-link") // берем первый блок из раздела с тегами и хабами - теги
        for i in 0 ..< els.array().count {
            // массив с хабами
            hubsToReturn.append(feedTagsItem(
                title: try els[i].text(),
                link: try els[i].attr("href")
            ))
        }
        for i in 0 ..< els6.array().count {
            // массив с тегами
            tagsToReturn.append(feedTagsItem(
                title: try els6[i].text(),
                link: try els6[i].attr("href")
            ))
        }
        for i in 0 ..< els1.array().count {
            // массив с лейблами
            labelsToReturn.append(feedTagsItem(
                title: try els1[i].text(),
                link: ""
            ))
        }
        for i in 0 ..< els2.array().count {
            // массив с оригиналами
            originalsToReturn.append(feedTagsItem(
                title: try els2[i].text(),
                link: try els2[i].attr("href")
            ))
        }
        print("fparseTags: content was successfully parsed")
    }
    catch Exception.Error(let type, let message) {
        print(type, message)
    }
    catch {
        print("error")
    }
    return (hubsToReturn, tagsToReturn, labelsToReturn, originalsToReturn)
}

func fparseComments(fhtml: String) -> (numberOfComments: String, commentsItemArray: Array<commentsItem>) {
    
    // парсим комментарии к статье
    var numberOfC: String = "0"
    var arrayToReturn: [commentsItem] = []
    do {
        let html: String = fhtml;
        
        var indentNumber: String
        
        let doc: Document = try SwiftSoup.parse(html)
        let link: Element = try doc.select("span.tm-comments__comments-count").first()!
        numberOfC = try link.text();
        
        let els4: Elements = try SwiftSoup.parse(html).select("div.tm-comment__body-content") // текст комментария
        let els5: Elements = try SwiftSoup.parse(html).select("a.tm-comment-thread-functional__comment-link") // дата комментария + ссылка на комментарий
        let els6: Elements = try SwiftSoup.parse(html).select("a.tm-user-info__username") // автор комментария + ссылка на автора
        let els7: Elements = try SwiftSoup.parse(html).select("span.tm-votes-meter__value") // рейтинг комментария
        
        let els8: Elements = try SwiftSoup.parse(html).select("div[class^=tm-comment__indent_l-]")
        
        for i in 0 ..< els4.array().count {
            indentNumber = try els8[i].attr("class")
            indentNumber = String(indentNumber[indentNumber.index(indentNumber.startIndex, offsetBy: 21)...])
            arrayToReturn.append(commentsItem(
                content: try els4[i].text(),
                indent: indentNumber,
                author: try els6[i].text(),
                author_link: try els6[i].attr("href"),
                date: try els5[i].text(),
                link: try els5[i].attr("href"),
                rate: try els7[i].text()
            ))
        }
        print("fparseComments: content was successfully parsed")
    }
    catch Exception.Error(let type, let message) {
        print(type, message)
    }
    catch {
        print("error")
    }
    return (numberOfC, arrayToReturn)
}

func fparseAbout(fhtml: String) -> (Array<String>, String) {
    
    // парсим about хабра
    
    var arrayToReturn: [String] = []
    var s: String = ""
    do {
        let html: String = fhtml;
        let els: Elements = try SwiftSoup.parse(html).select("a.tm-about__article-link")
        
        let els4: Elements = try SwiftSoup.parse(html).select("p.tm-about__text tm-about__text_type-2 tm-about__stats")
        print(els4.count)
        s = try els4[0].text()
        
        for i in 0 ..< els.array().count {
            arrayToReturn.append(try els[i].text())
        }
        print("fparseAbout: content was successfully parsed")
    }
    catch Exception.Error(let type, let message) {
        print(type, message)
    }
    catch {
        print("error")
    }
    return (arrayToReturn, s)
}

func fparseAuthor(fhtml: String) -> (Author: AuthorItem, info: [(key: String, value: String)]) {
    
    // парсим автора
    
    var arrayToReturn = AuthorItem(card_name: "", card_nickname: "", short_info: "", karma: "", rating: "")
    var retval: [(key: String, value: String)] = []
    
    do {
        let html: String = fhtml;
        
        let doc: Document = try SwiftSoup.parse(html)
        
        var s: String = ""
        
     //   let link: Element = try doc.select("span.tm-user-card__name").first()!
        let link: Element
        if try doc.select("span.tm-user-card__name").first() != nil {
            print("Contains a value!")
            link = try doc.select("span.tm-user-card__name").first()!
            s = try link.text()
        } else {
            print("Doesn’t contain a value.")
        }
        
        let link2: Element = try doc.select("a.tm-user-card__nickname").first()!
        let link3: Element = try doc.select("p.tm-user-card__short-info").first()!
        let link4: Element = try doc.select("div.tm-karma__votes").first()!
        let link5: Element = try doc.select("div.tm-rating__counter").first()!
        
        let els0: Elements = try SwiftSoup.parse(html).select("div.tm-user-basic-info")
        let basicInfo: String = try els0.html()
        let els: Elements = try SwiftSoup.parse(basicInfo).select("dt.tm-description-list__title") // инфо - заголовок
        let els4: Elements = try SwiftSoup.parse(basicInfo).select("dd.tm-description-list__body") // инфо - значение
               
        arrayToReturn.card_name = s
        arrayToReturn.card_nickname = try link2.text()
        arrayToReturn.short_info = try link3.text()
        arrayToReturn.karma = try link4.text()
        arrayToReturn.rating = try link5.text()
        
        for i in 0 ..< els.array().count {
            retval.append((try els[i].text(), try els4[i].text()))
        }

        print("fparseAuthor: content was successfully parsed")
    }
    catch Exception.Error(let type, let message) {
        print(type, message)
    }
    catch {
        print("error")
    }
    return (arrayToReturn, retval)
}
