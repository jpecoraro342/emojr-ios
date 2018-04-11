const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.onFollow = functions.database.ref('/follows/{followedUser}').onCreate((snapshot, context) => {	
	const createdData = snapshot.val();
	
	console.log('Created:\n' + createdData);
	console.log('UID: ' + EventContext.auth.uid);

	let timelineRef = admin.database().ref().child('timeline').child(EventContext.auth.uid);
	let timelinePosts = {};

	return timelineRef.once('value')
	  .then(timelineSnapshot => {
	  	timelinePosts = timelineSnapshot.val() || {};
	  	
		return admin.database().ref().child('userPosts').child(createdData).once('value')
	  })
	  .then(userSnapchat => {
		let userPosts = userSnapchat.val() || {};
		timelinePosts = Object.assign(timelinePosts, userPosts);

	  	return timelineRef.update(timelinePosts);
	 });
});

exports.onUnfollow = functions.database.ref('/follows/{followedUser}').onDelete((snapshot, context) => {	
	const deletedData = snapshot.val();
	
	console.log('Deleted:\n' + deletedData);
	console.log('UID: ' + EventContext.auth.uid);

	let timelineRef = admin.database().ref().child('timeline').child(EventContext.auth.uid);
	let timelinePosts = {};

	return timelineRef.once('value')
	  .then(timelineSnapshot => {
	  	timelinePosts = timelineSnapshot.val() || {};
	  	
	  	console.log('Posts:\n' + timelinePosts);
	  	
	  	// delete deletedData
	  	
		return timelineRef.update(timelinePosts);
	  });
});