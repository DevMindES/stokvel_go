import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

exports.checkExistingUser = functions.https.onCall(async (data) => {
  try {
    let existingUser = false;
    let method = "phone number";
    let identifier = data.phoneNumber;

    if (data.email !== null) { // user chose to create account with email
      method = "email";
      identifier = data.email;
    }

    ///// Check if user exists in Firebase Auth
    if (method === "phone number") {
      await admin.auth().getUserByPhoneNumber(identifier)
        .then(userRecord => {
          if (userRecord !== null) existingUser = true;
        })
        .catch(error => {
          // User not found in Firebase Auth, do nothing
        });
    } else {
      await admin.auth().getUserByEmail(identifier)
        .then(userRecord => {
          if (userRecord !== null) existingUser = true;
        })
        .catch(error => {
          // User not found in Firebase Auth, do nothing
        });
    }

    // If user doesn't exist in Firebase Auth, check in temp_users
    if (!existingUser) {
      const tempUserDoc = admin.firestore().collection("temp_users").doc(identifier);
      await tempUserDoc.get()
        .then(docSnapshot => {
          if (docSnapshot.exists) existingUser = true;
        });
    }

    if (existingUser) {
      return {
        status: "warning",
        message: "This " + method + " is already associated with a user."
      };
    }
    
    return {
        status: "success",
        message: "This " + method + " can be used to create an account."
      };

  } catch (error) {
    throw new functions.https.HttpsError(
      "unknown",
      "unknown",
      error
    );
  }
});


exports.addToTempUsers = functions.https.onCall(async (data) => {
  try {
    if (data.email === null) { // create new user with phone number
      // add user data to Firestore
      await admin.firestore().collection("temp_users").doc(data.phoneNumber).set({
        displayName: data.displayName,
        idNumber: data.idNumber,
        phoneNumber: data.phoneNumber,
        phoneNumberVerified: false,
      });
    } else { // create user with email
      await admin.firestore().collection("temp_users").doc(data.email).set({
        displayName: data.displayName,
        idNumber: data.idNumber,
        email: data.email,
        emailVerified: false,
      });
    }

    return {
      status: "success",
      message: "User details successfully captured."
    };
  } catch (error) {
    throw new functions.auth.HttpsError(
      "unknown",
      "unknown",
      error
    );
  }
});


exports.createUser = functions.https.onCall(async (identifier) => {
  try {
    const db = admin.firestore();

    // Get user data from temp_users
    const tempUserDoc = db.collection('temp_users').doc(identifier);
    const docSnapshot = await tempUserDoc.get();

    if (!docSnapshot.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "User data not found in temp_users"
      );
    }

    const userData = docSnapshot.data() as admin.firestore.DocumentData;

    // Create user in Firebase Auth
    let userRecord;
    if (userData.phoneNumber) {
      userRecord = await admin.auth().createUser({
        phoneNumber: userData.phoneNumber,
        password: userData.phoneNumber,
        displayName: userData.displayName,
        disabled: false,
      });
    } else {
      userRecord = await admin.auth().createUser({
        email: userData.email,
        emailVerified: false,
        password: userData.email,
        displayName: userData.displayName,
        disabled: false,
      });
    }

    // Add user data to Firestore
    await db.collection("users").doc(userRecord.uid).set(userData);

    // Delete user data from temp_users
    await tempUserDoc.delete();

    return {
      status: "success",
      message: "User created successfully."
    };
  } catch (error) {
    throw new functions.https.HttpsError(
      "unknown",
      "Unknown error",
      error
    );
  }
});

