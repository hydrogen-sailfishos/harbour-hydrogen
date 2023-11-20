import QtQuick 2.2      // not 2.0, because Instantiator
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0

Item { id: root
    // ListModel to serve as an input to the factory
    property alias messages: factory.model

    /*
     * Creates and publishes a new notification.
     * Convenience function to quickly publish a notification.
     */
    function quickNotification( message ) { addNotification( undefined, message, undefined, message, undefined, undefined ) }

    /*
     * Creates and publishes a new notification.
     * Convenience function to quickly publish a notification.
     */
    function quickNumberedNotification( message, count ) { addNotification( undefined, message, undefined, message, count, undefined ) }


    /*
     * Creates and publishes a new notification.
     *
     * At least the shortMessage parameter should be supplied.
     * If uid is specified, it can be used in removeNotification later.
     *
     * Both "title" parameters default to "Notification" if not specified.
     *
     * The count parameter will be passed as itemCount property to the Notification
     */
    function addNotification( shortTitle, shortMessage,
                              title, message,
                              count,
                              uid
                            ) {
        // we can't write to uid, so copy it to a local variable
        const msgid = (uid) ? uid : Qt.md5([ Date.now(), title, message, shortTitle, shortMessage, count].join())
        // wait for the instantiator to create the object, set properties and publish
        factory.objectAdded.connect(function(idx, obj) {
            console.assert(shortMessage, "Warning: we should have at least a message body")

            obj.summary        = (title)      ? title      : qsTr("Notification")
            obj.previewSummary = (shortTitle) ? shortTitle : qsTr("Notification")

            if (message)        obj.body           = message
            if (shortMessage)   obj.previewBody    = shortMessage
            if (count)          obj.itemCount      = count
            obj.publish()
        })
        messages.append({"mid": msgid})
        return msgid
    }

    /* Removes a Notification.
     *
     * looks for the id in the messages model, removes it if found
     * This should destroy the object in the factory, which will delete the message
     */
    function removeNotification(uid) {
        for (var i = 0; i<messages.count; i++) {
            var o = messages.get(i);
            if (o.mid === uid) messages.remove(i+1,1)
        }
    }

    Instantiator { id: factory
        asynchronous: true
        delegate: template
        model: ListModel{}

        // remove notifications from eventview on destruction
        onObjectRemoved: function(idx, obj) {
            obj.close()
        }
    }

    Component { id: template; Notification {
         category: "im.received"
         appName: qsTr("Hydrogen")
         appIcon: "image://theme/harbour-hydrogen"
         //summary: "Notification summary"
         //body: "Notification body"
         //previewSummary: "Notification preview summary"
         //previewBody: "Notification preview body"
         //itemCount: 5
         //timestamp: "2013-02-20 18:21:00"
         remoteActions: [ {
             "name": "default",
             "displayName": qsTr("Open Conversation"),
             "icon": "icon-lock-chat",
             "service":  "org.github.hydrogen-sailfishos.harbour-hydrogen.hydrogen",
             "path":     "/hydrogen/ui",
             "iface":    "org.github.HydrogenSailfishOS.Hydrogen.ui",
             "method":    "fromNotification",
             "arguments": [ "id", replacesId ]
         } ]
         onClicked: console.log("Clicked")
         onClosed: console.log("Closed, reason: " + reason)
     }}
}
