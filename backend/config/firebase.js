const admin = require('firebase-admin');
const serviceAccount = require('../serviceAccountKey.json'); 

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://<bus-live-tracker-1fd6b>.firebaseio.com"
});

const db = admin.firestore();

module.exports = { admin, db };
