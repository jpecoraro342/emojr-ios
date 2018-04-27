const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// When a user follows another user, add those users posts to their timeline
exports.onFollow = functions.database.ref('/follows/{followedUser}').onCreate((snapshot, context) => {	
	const createdData = snapshot.val();
	
	console.log('Created: ');
	console.log(createdData);

	const createdId = Object.keys(createdData)[0];

	console.log('CreatedId: ');
	console.log(createdId);

	const userId = context.auth.uid;
	console.log('UserId: ');
	console.log(userId);

	// Get the timeline for the user
	let timelineRef = admin.database().ref().child('timeline').child(userId);
	let timelinePosts = {};

	return timelineRef.once('value')
	  .then(timelineSnapshot => {
	  	// Get the posts
	  	timelinePosts = timelineSnapshot.val() || {};

	  	console.log('Posts: ');
	  	console.log(timelinePosts);
	  	
		return admin.database().ref().child('userPosts').child(createdId).once('value')
	  })
	  .then(userSnapchat => {
	  	// Add all of the new users posts to the timeline
		let userPosts = userSnapchat.val() || {};
		timelinePosts = Object.assign(timelinePosts, userPosts);

		console.log('Posts after Add: ');
	  	console.log(timelinePosts);

	  	return timelineRef.update(timelinePosts);
	 });
});

// When a user stops following another user, remove those users posts from their timeline
exports.onUnfollow = functions.database.ref('/follows/{followedUser}').onDelete((snapshot, context) => {	
	const deletedData = snapshot.val();
	
	console.log('Deleted: ');
	console.log(deletedData);

	const deletedId = Object.keys(deletedData)[0];

	console.log('DeletedId:');
	console.log(deletedId);

	const userId = context.auth.uid;
	console.log('UserId: ');
	console.log(userId);

	// Get the timeline for the user
	let timelineRef = admin.database().ref().child('timeline').child(userId);
	let timelinePosts = {};

	return timelineRef.once('value')
	  .then(timelineSnapshot => {
	  	timelinePosts = timelineSnapshot.val() || {};
	  	
	  	console.log('Posts: ');
	  	console.log(timelinePosts);

	  	let updatedPosts = {};

	  	console.log(Object.keys(timelinePosts));
	  	
	  	// Iterate throught the timeline posts, removing or adding posts to the new array depending on if the post should be deleted or not
	  	timelinePosts = Object.keys(timelinePosts).forEach(postId => {
	  		let post = timelinePosts[postId];
	  		if (post.userID !== deletedId) {
	  			updatedPosts['' + postId] = post;
	  		}
	  		else {
	  			updatedPosts['' + postId] = null;
	  		}
	  	});

	  	console.log('Posts after Delete: ');
	  	console.log(updatedPosts);
	  	
		return timelineRef.update(updatedPosts);
	  });
});