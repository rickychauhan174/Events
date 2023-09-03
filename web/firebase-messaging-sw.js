importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");
const firebaseConfig = {
  apiKey: "AIzaSyBc7W6CqVfbp_Jhrl8zlbtbyWExTtDzsHQ",
  authDomain: "sample-event-cfd8c.firebaseapp.com",
  projectId: "sample-event-cfd8c",
  storageBucket: "sample-event-cfd8c.appspot.com",
  messagingSenderId: "371323016199",
  appId: "1:371323016199:web:0d51fc52403bbaddc886a2"
};

  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });