
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
          var customEvent = new CustomEvent("framescript:notificationCount",
                           { detail: { count: notificationCount }});
          document.dispatchEvent(customEvent);
        };
    }
}

setInterval(refreshSession, 3000);

