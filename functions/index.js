const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.onFollowChanged = functions.database.ref('/follows/{followedUser}').onWrite((change, context) => {
	let original = change.before.val();
	let current = change.after.val();

	original = original ? Object.keys(original) : [];
	current = current ? Object.keys(current) : [];

	const newFollows = current.filter(follow => original.indexOf(follow) < 0);
	const removedFollow = original.filter(follow => current.indexOf(follow) < 0);

	console.log('New Follow: ', newFollows);
	console.log('Removed Follow: ', removedFollow);

	let timelineRef = admin.database().ref().child('timeline').child(context.params.followedUser);
	let timelinePosts = {};

	if (removedFollow.length == 1) {
		console.log('follower removed, remove posts from timeline');
		const deletedId = removedFollow[0];

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
	}


	if (newFollows.length == 1) { 
		console.log('one follower added, add posts to timeline')
		const createdId = newFollows[0];

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
	}
});