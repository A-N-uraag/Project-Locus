const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onNewUser = functions.auth.user().onCreate(async (user) => {
    await admin.firestore().collection('location_has_access').doc(user.email).set({"accessible_users" : []});
});

exports.onGivenAccess = functions.firestore.document('/location_given_access/{documentId}')
    .onUpdate((change,context) => {
        const newData = change.after.data()['access_given_users'];
        const oldData = change.before.data()['access_given_users'];
        const removedUsers = oldData.filter((x) => !newData.includes(x));
        const addedUsers = newData.filter((x) => !oldData.includes(x));
        removedUsers.forEach(async (element) => {
            var result = await admin.firestore().collection('location_has_access').doc(element).get();
            var existingList = result.data()['accessible_users'];
            await admin.firestore().collection('location_has_access').doc(element).set({"accessible_users" : existingList.filter((x) => x !== context.params.documentId)})
        });
        addedUsers.forEach(async (element) => {
            var result = await admin.firestore().collection('location_has_access').doc(element).get();
            var existingList = result.data()['accessible_users'];
            existingList.push(context.params.documentId);
            await admin.firestore().collection('location_has_access').doc(element).set({"accessible_users" : existingList})
        });
        return true;
    })

