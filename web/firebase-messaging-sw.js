// firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.8.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyCaEmQSIxoBxyDzi1gpxbyBNor3AsP36vY",
  authDomain: "omnyqr-a19ef.firebaseapp.com",
  projectId: "omnyqr-a19ef",
  storageBucket: "omnyqr-a19ef.firebasestorage.app",
  messagingSenderId: "628443235801",
  appId: "1:628443235801:web:c7aecf58668455135ac5c8"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png' // Puoi cambiarlo se vuoi un'altra icona
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
