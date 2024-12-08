// Copyright © 2021-2023 Thilo Kogge (thigg)
// Copyright © 2023 The SailfishOS Hackathon Bucharest Team
//
// SPDX-FileCopyrightText: 2024 Mirian Margiani
//
// SPDX-License-Identifier: Apache-2.0

// adapted from: https://github.com/element-hq/hydrogen-web/blob/cd02ef60dc249d3360ae4f346e244d858b13b9ab/src/matrix/room/members/Heroes.js#L19
function _calculateRoomName(summaryData, members) {
    let sortedMembers = members.filter(item => summaryData.heroes.indexOf(item.userId) >= 0)

    const countWithoutMe = summaryData.joinCount + summaryData.inviteCount - 1;

    if (sortedMembers.length >= countWithoutMe) {
        if (sortedMembers.length > 1) {
            const lastMember = sortedMembers[sortedMembers.length - 1];
            const firstMembers = sortedMembers.slice(0, sortedMembers.length - 1);
            return firstMembers.map(m => m.displayName).join(", ") + " , and " + lastMember.displayName;
        } else {
            const otherMember = sortedMembers[0];
            if (otherMember) {
                return otherMember.displayName;
            } else {
                return null;
            }
        }
    } else if (sortedMembers.length < countWithoutMe) {
        return sortedMembers.map(m => m.displayName).join(", ") + ` , and ${countWithoutMe} others`;
    } else {
        // Empty Room
        return null;
    }
}

// source: https://gist.github.com/robmathers/1830ce09695f759bf2c4df15c29dd22d
// A more readable and annotated version of the Javascript groupBy from Ceasar Bautista (https://stackoverflow.com/a/34890276/1376063)
var _groupBy = function(data, key) { // `data` is an array of objects, `key` is the key (or property accessor) to group by
  // reduce runs this anonymous function on each element of `data` (the `item` parameter,
  // returning the `storage` parameter at the end
  return data.reduce(function(storage, item) {
    // get the first instance of the key by which we're grouping
    var group = item[key];

    // set `storage` for this instance of group to the outer scope (if not empty) or initialize it
    storage[group] = storage[group] || [];

    // add this item to its group within `storage`
    storage[group].push(item);

    // return the updated storage to the reduce function, which will then loop through the next
    return storage;
  }, {}); // {} is the initial value of the storage
};

/*
 * Access an object store.
 *
 * Arguments:
 *   db: opened indexedDB
 *   name: str
 *   onError: function(request: request, event: str)
 *   onSuccess: function(request: request, event: str)
 */
function _accessObjectStore(db, name, onError, onSuccess) {
    var transaction = db.transaction(name, "readonly", "relaxed");
    var storeNames = Array.from(transaction.objectStoreNames);

    if (storeNames.indexOf(name) === -1) {
        onError("object store '" + name + "' not found");
    }

    var objectStore = transaction.objectStore(name);

    var request = objectStore.getAll();

    request.onerror = function(event) { onError(request, event); }
    request.onsuccess = function(event) { onSuccess(request, event); }
}

function getCurrentSession() {
    var matches = window.location.hash.match(/session\/(\d+)/);
    if (matches && matches.length > 1) {
        return matches[1];
    }
}

function refreshSession() {
    var currentSession = getCurrentSession();
    if (!currentSession) {
        return;
    }

    var result = indexedDB.open("hydrogen_session_" + currentSession);
    result.onerror = function(error) { console.error("open", error); }

    result.onsuccess = function(event) {
        var db = event.target.result;

        _accessObjectStore(db, "roomSummary", function(summaryRequest, event){
            console.error(event);
        }, function(summaryRequest, event) {
            _accessObjectStore(db, "roomMembers", function(membersRequest, event){
                console.error(event);
            }, function(membersRequest, event){
                var notificationCount = summaryRequest.result.reduce((sum, item) => sum + item.notificationCount, 0);

                // Most recent bunch of discussions with unread
                let mostRecentCount = 20;
                let coverPreviewRaw = summaryRequest.result
                    .filter(item => !!item.notificationCount)
                    .sort((x,y) => x.lastMessageTimestamp - y.lastMessageTimestamp)
                    .slice(-mostRecentCount);

                let unnamedRooms = coverPreviewRaw
                    .filter(item => !item.name)
                    .map(item => item.roomId);
                let roomMembers = _groupBy(membersRequest.result.filter(item => (unnamedRooms.indexOf(item.roomId) >= 0)), 'roomId');

                let coverPreview = coverPreviewRaw
                    .map(item => ({
                        name: item.name || _calculateRoomName(item, roomMembers[item.roomId]) || item.heroes[0],
                        count: item.notificationCount,
                    }))
                    .reverse();

                var customEvent = new CustomEvent("framescript:notificationCount", {
                    detail: {
                        count: notificationCount,
                        coverPreview: coverPreview,
                    }
                });
                document.dispatchEvent(customEvent);
            });
        });
    }
}

setInterval(refreshSession, 5000);

