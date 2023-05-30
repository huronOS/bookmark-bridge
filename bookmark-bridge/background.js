function isFirefox() {
    return navigator.userAgent.indexOf("Firefox") > -1;
}

let current_browser = isFirefox() ? "firefox" : "chrome";

let port = browser.runtime.connectNative("bookmarks_fetcher");

function removeTrailingBackslash(bookmark){
    // To avoid issues while comparing URLs, remove the trailing backslash (if exists)
    if(bookmark.url[bookmark.url.length - 1] == '/'){
        // Removes the last character
        bookmark.url = bookmark.url.slice(0,-1);
    }
}

function parseBookmarkString(bookmarkString) {
    let bookmarks = [];
    let bookmarkList = bookmarkString.split('|');
    for (let bookmarkStr of bookmarkList) {
        if(bookmarkStr.length==0) continue;
        let bookmark = bookmarkStr.split('^');
        if (bookmark.length === 2) {
            bookmarks.push({
                title: bookmark[0].replace("{", ""),
                url: bookmark[1].replace("}", ""),
            });
        }
    }
    return bookmarks;
}
function bookmarkAlreadyExists(directivesBookmark, toolbarBookmarks) {
    // On each url remove the trailing dash (URL normalization)
    // in case that either the user didn't added a backslash at the end of the url
    // or the browser decided that said URL does not require to have a backslash
    let directivesBookmarkUrl = directivesBookmark.url.replace(/\/$/, "");
    for (let toolbarBookmark of toolbarBookmarks) {
        let toolbarBookmarkUrl = toolbarBookmark.url.replace(/\/$/, "");
        if (directivesBookmarkUrl == toolbarBookmarkUrl) {
            return true;
        }
    }
    return false;
}
async function bookmarksCallback(directivesBookmarksString) {
    console.log("Looking for bookmarks");
    let toolbarID = current_browser === "firefox" ? "toolbar_____" : "1";
    let toolbarBookmarks = await browser.bookmarks.getChildren(toolbarID);
    let directivesBookmarks = parseBookmarkString(directivesBookmarksString);
    directivesBookmarks.forEach(directivesBookmark => {
        if (!bookmarkAlreadyExists(directivesBookmark, toolbarBookmarks)) {
            console.log("Adding", directivesBookmark.title);
            browser.bookmarks.create({
                "parentId": toolbarID,
                "title": directivesBookmark.title,
                "url": directivesBookmark.url,
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
