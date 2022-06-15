importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyATRa9YqrlyA-dR41v94RZ9svzZf5NOaiU",
  authDomain: "newbook-search.firebaseapp.com",
  projectId: "newbook-search",
  storageBucket: "newbook-search.appspot.com",
  messagingSenderId: "85991545625",
  appId: "1:85991545625:web:de87fa18ddc6d437edc388",
  measurementId: "G-FPWN8ZN4CP"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});