function isFirefox() {
    return navigator.userAgent.indexOf("Firefox") > -1;
}

let current_browser = isFirefox() ? "firefox" : "chrome";

let port = browser.runtime.connectNative("bookmarks_fetcher");

function parseBookmarkString(bookmarkString) {
    let bookmarks = [];
    let bookmarkList = bookmarkString.split('|');
    for (let i = 0; i < bookmarkList.length; i++) {
        let bookmark = bookmarkList[i].split('^');
        if (bookmark.length === 2) {
            bookmarks.push({
                title: bookmark[0].replace("{", ""),
                url: bookmark[1].replace("}", ""),
            });
        }
    }
    return bookmarks;
}
function bookmarkAlreadyExists(bookmark, rootBookmarks) {
    // console.log("Looking for", bookmark.url);
    for (const currBookmark of rootBookmarks) {
        //console.log(currBookmark.url, "vs", bookmark.url)
        if (currBookmark.url == bookmark.url) {
            //console.log("found");
            return true;
        }
    }
    return false;
}
async function bookmarksCallback(directivesBookmarksString) {
    console.log("Looking for bookmarks");
    let toolbarID = current_browser === "firefox" ? "toolbar_____" : "1";
    // console.log("Looking for", toolbarID);
    let rootBookmarks = await browser.bookmarks.getChildren(toolbarID);
    // console.log(rootBookmarks);
    let directivesBookmarks = parseBookmarkString(directivesBookmarksString);
    // console.log("Directives bookmarks:", directivesBookmarks);
    directivesBookmarks.forEach(bookmark => {
        // console.log("Comparing", bookmark);
        if (!bookmarkAlreadyExists(bookmark, rootBookmarks)) {
            console.log("Adding", bookmark.title);
            browser.bookmarks.create({
                "parentId": toolbarID,
                "title": bookmark.title,
                "url": bookmark.url,
            });
        }
    });
}
// bookmarksCallback("{Codeforces^https://cpciitsur.contest.codeforces.com/}|{Omegaup^https://omegaup.com/}|");
/*
Listen for messages from the app.
*/
port.onMessage.addListener((response) => {
    // console.log("Received: " + response);
    bookmarksCallback(response);
});