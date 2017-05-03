const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.onFollow = functions.database.ref('/follows/{followedUser}').onWrite(event => {
	let original = event.data.previous.val();
	let current = event.data.current.val();

	original = original ? Object.keys(original) : [];
	current = current ? Object.keys(current) : [];

	const newFollows = current.filter(follow => original.indexOf(follow) < 0);
	const removedFollow = original.filter(follow => current.indexOf(follow) < 0);

	console.log('New Follow: ', newFollows);
	console.log('Removed Follow: ', removedFollow);

	if (newFollows.length != 1) { 
		console.log(`needed 1 new follow to add timeline, found ${newFollows.length}`);
		return Promise.resolve(); 
	}

	let timelineRef = admin.database().ref().child('timeline').child(event.params.followedUser);
	let timelinePosts = {};

	return timelineRef.once('value')
	  .then(timelineSnapshot => {
	  	timelinePosts = timelineSnapshot.val() || {};
		return admin.database().ref().child('userPosts').child(newFollows[0]).once('value')
	  })
	  .then(userSnapchat => {
	  	let userPosts = userSnapchat.val() || {};
	  	timelinePosts = Object.assign(timelinePosts, userPosts);

	  	return timelineRef.update(timelinePosts);
	 });
});