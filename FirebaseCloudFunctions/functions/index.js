const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNotification = functions.firestore
.document("ChatRoom/{docId}/chats/{Id}")
.onCreate(async (snapshot, context)=> {

  if (snapshot.empty) {
    console.log('No devices');
    return;
  }

  const notificationDocument = snapshot.data();

  const myUserId = notificationDocument.sendBy;
  const contactUserId = notificationDocument.sendTo;

  const notificationMessage = notificationDocument.message;

  const myUserDoc = await admin.firestore().collection("users").doc(myUserId).get();
  const contactUserDoc = await admin.firestore().collection("users").doc(contactUserId).get();

  const notificationTitle = myUserDoc.data().name;
  const sendersToken = contactUserDoc.data().token;

  const chatRoomId1 = myUserId + "_" + contactUserId;
  const chatRoomId2 = contactUserId + "_" + myUserId;

  var ref;
  try {
    ref = await admin.firestore().collection("ChatRoom").doc(chatRoomId1);
  } catch (e) {
    ref = await admin.firestore().collection("ChatRoom").doc(chatRoomId2);
  }

  var payLoad = {
    notification: {
      title: notificationTitle,
      body: notificationMessage,
      sound: 'default'
    },
    data: {
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
      message: "newMessage"
    },
  };

  try {
    const response = await admin.messaging().sendToDevice(sendersToken, payLoad);

    /*ref.get().then((doc) => {
        if(doc.exists()){
           ref.update({isDelivered: true}
           ).catch(e =>{throw e});
          }
        }
    ).catch(e => console.log("error in updation" + e));
*/

    console.log('Notification sent successfully');
  } catch (error) {
    console.log('error sending notification ' + error);
  }

});
