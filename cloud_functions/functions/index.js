const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onNewUser = functions.region("asia-south1").auth.user().onCreate(async (user) => {
    await admin.firestore().collection('location_has_access').doc(user.email).set({"accessible_users" : []});
});

exports.onUserAdd = functions.region("asia-south1").https.onCall(async (data) => {
    const name = data.name;
    const email = data.email;
    const bio = data.bio;
    const mobile = data.mobile;
    await admin.firestore().collection('user_public_details').doc(email).set({"name" : name, "email" : email, "bio" : bio});
    await admin.firestore().collection('user_private_details').doc(email).set({"mobile" : mobile, "emergency" : [], "favourites" : []});
    return true;
});

exports.onGivenAccess = functions.region("asia-south1").firestore.document('/location_given_access/{documentId}').onUpdate((change,context) => {
    const newData = change.after.data()['access_given_users'];
    const oldData = change.before.data()['access_given_users'];
    const removedUsers = oldData.filter((x) => !newData.includes(x));
    const addedUsers = newData.filter((x) => !oldData.includes(x));
    removedUsers.forEach(async (element) => {
        var hasAccess = await admin.firestore().collection('location_has_access').doc(element).get();
        if(hasAccess) {
            var existingList = hasAccess.data()['accessible_users'];
            await admin.firestore().collection('location_has_access').doc(element).set({"accessible_users" : existingList.filter((x) => x !== context.params.documentId)});
        }

        var privateDetails = await admin.firestore().collection('user_private_details').doc(element).get();
        if(privateDetails) {
            existingList = privateDetails.data()['favourites'];
            await admin.firestore().collection('user_private_details').doc(element).update({"favourites" : existingList.filter((x) => x !== context.params.documentId)});
        }
        
    });
    addedUsers.forEach(async (element) => {
        var result = await admin.firestore().collection('location_has_access').doc(element).get();
        if(result) {
            var existingList = result.data()['accessible_users'];
            existingList.push(context.params.documentId);
            await admin.firestore().collection('location_has_access').doc(element).set({"accessible_users" : existingList});
        }
    });
    return true;
})

