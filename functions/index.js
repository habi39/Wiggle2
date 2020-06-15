const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const database = admin.firestore();
var newData;

exports.onCreatenewData = functions.firestore
    .document('cloud/{clouditem}')
    .onCreate(async (snapshot, context) => {

        if (snapshot.empty) {
            console.log("No token for user, can not send notification.")
        }
        newData = snapshot.data();
        var tokens = [newData.token];
        let body;
        switch(newData.type){

            case 'follow':
                body = `${newData.userID} started following you`;
                break;   

            case 'message':
                body = `${newData.userID} has sent you a message`; 
                break;

            case 'request':
                body = `${newData.userID} has requested to follow you`; 
                break;
            
            case 'compatibility':
                body = `${newData.userID} wants to do a quiz with you`;
                break;

            case 'anonmessage':
                body = `${newData.userID} has sent you a message (Anonymous)`; 
                break;

            case 'susmessage':
                body = `${newData.userID} has sent you a message anonymously`; 
                break;
            
            case 'question':
                body = `${newData.userID} wants to play trivia with you`; 
                break;
            
              default:
               break;
        } 

        
        var payload = {
            notification: { title: 'Wiggle!', body: body ,sound: 'default' },
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                message: body,
            },
        };
        try {
            const response = admin.messaging().sendToDevice(tokens, payload);
            console.log('Nofication sent successfully');
        } catch (err) {
            console.log('error sending notificaiton');

        }



    });

// exports.scheduler = functions.pubsub.scheduler('* * * * *').onRun((context) => {
//     database.doc("timers/timer").update({ "time": admin.firestore.Timestamp.now() });
//     return console.log("successful update");
// });