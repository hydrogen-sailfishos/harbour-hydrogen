
function refreshSession() {
    var session0 = JSON.parse(localStorage.getItem("hydrogen_sessions_v1"))[0].id;
    var result = indexedDB.open("hydrogen_session_" + session0);
    result.onerror = function(error) { console.error("open", error); }


    result.onsuccess = function(event) {
        var db = event.target.result;

        var transaction = db.transaction(["roomSummary"]);
        var objectStore = transaction.objectStore("roomSummary");

        var request = objectStore.getAll();
        request.onerror = function(event) {
          console.error(event);
        };
        request.onsuccess = function(event) {
          console.log(`Result is`,request.result);
          var notificationCount = request.result.reduce((sum, item) => sum + item.notificationCount, 0);
          // Most recent 5 discussions with unread:
          let top5 = request.result.filter(item => !!item.notificationCount)
                .sort((x,y) => x.lastMessageTimestamp - y.lastMessageTimestamp)
                .slice(-5).map(item => item.name || item.heroes[0])
                .reverse();

          var customEvent = new CustomEvent("framescript:notificationCount",
                           { detail: { count: notificationCount, top5 }});
          document.dispatchEvent(customEvent);
        };
    }
}

setInterval(refreshSession, 3000);

