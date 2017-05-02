var functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});


exports.onFollow = functions.database.ref('/follows/{followedUser}')
	.onWrite(event => {

	const original = Object.keys(event.data.previous.val());
	const current = Object.keys(event.data.val());

	const followed = (original.count < current.count);

	const difference = original.filter(function(i) { return current.indexOf(i) < 0; });

	if (difference.length != 1) { console.log("There should only be one..."); return Promise.resolve(); }
	const newFollower = difference[0];

	let timelineRef = functions.database.ref().child('timeline').child(newFollower);

	return timelineRef.once('value')
	  .then(function(timelineSnapshot) {
		  	let userRef = functions.database.ref().child('userPosts').child(event.params.followedUser).once('value')
				  .then(function(userSnapchat) {

				   const timelinePosts = timelineSnapshot.val()
				   const userPosts = userSnapchat.val()

				   if (timelinePosts.constructor !== Array) { console.log("timelinePosts was not array"); return; }
				   if (userPosts.constructor !== Array) { console.log("userPosts was not array"); return; }

				   if (followed) {
				   		timelinePosts.push(...userPosts);
				   } else {
				   		timelinePosts = timelinePosts.filter(function(i) { return userPosts.indexOf(i) < 0; });
				   }
				   
				   timelineRef.update(timelinePosts);
			 });
		});
});