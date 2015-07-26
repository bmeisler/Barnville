package com.evili.worldBuilder.model
{
	public class Messages
	{
		private var _inGameMessageArray:Array;
		private var _inGameContentArray:Array;
		private var _spamContentArray:Array;
		private var _fakeFriendsArray:Array;
		private var _illustratedJokeMessageArray:Array;
		private var _illustratedJokeMcsArray:Array;
		public function Messages()
		{
			init();
		}
		private function init():void{
			makeInGameMessageArray();
			makeInGameContentArray();	
			makeSpamContentArray();
			makeFakeFriendsArray();
			makeIllustratedJokeMessageArray();
			makeIllustratedMcsArray();
		}
		public function makeInGameMessageArray():void{
			
			_inGameMessageArray = new Array("You just stepped in a cow pie!  You have won the limited-edition “Brown Ribbon!”  Congratulations.  Now, go change your shoes.",
				"Congratulations! You just achieved the “Victorious Veal Award”! Your baby calf pens are extra confining. Those little guys can barely wag their tails. Great job!",
				"Congratulations! You just found a Rattlesnake! Unfortunately, you were bitten. For only 125 FarmWorld Bucks you can buy some antidote.",
				"Congratulations! You turned on the sprinklers! You received the “Golden Shower Award”! Way to go! You’re in great shape!",
				"Congratulations! You win the “Never Slow Down Award” for taking a dump out in the field so you could keep working! You can now buy toilet paper at the market. Better late than never!",
				"Congratulations! And by “congratulations!” we mean, “sorry”! Your animals are sick with something that seems to have to spread to humans. You have 6 months to live!",
				"Congratulations! You found a hatch on your farm! You win the “Dharma Initiative Patch.” You are now confused and Lost!",
				"YEEHAW!  You just won a Billy Goat and earned 150 XP.  Your prize can be found hanging out with Angelina Jolie.  Oh, wait…that’s not a Billy Goat.  Dude!  You just won Brad Pitt! ",
				"Congratulations!  You are now at level 2.  You are now known as “Big Loser.”  Now you can buy Mung Beans, Smallpox Blankets, Rotten Eggs.",
				"Congratulations!  You are now at level 3.  You really don’t get out much, do you?  Now you can buy of eye of newt, and toe of frog, wool of bat, and tongue of dog.", 
				"Congratulations!  You are now at level 4.  I pity you.  Maybe you can buy a clue and get a life.",
				"Congratulations! You found a drunk Charlie Sheen in your field! Ask your friends to help you get him into your neighbor’s barn before he barfs.",
				"Congratulations! You just found out Woody Harrelson and Mathew McConaughey are growing Marijuana secretly on your farm. You just made more money selling that than all your crops combined!",
				"You lost a limb in a freak tractor accident.  No problem!  Play “Armville,” the new game for accidental amputees. ",
				"Congratulations!  You have discovered a rare Hairy Nosed Wombat on your farm.  Plow over its habitat to grow more soybeans!",
				"Bad news!  Those crop circles on your property weren’t a college prank.  Your cattle have just been mutilated and you’re about to get probed where the sun don’t shine.",
				"Uh Uh!  You used that unconscious hobo as cattle feed.  Now your herd has “Bum Steer” disease.",
				"Congratulations! You just avoided the unionization of your workers when one of the leaders “mysteriously” disappeared.",
				"Congratulations! You have successfully bred a pig and a chicken. Work on getting toast in there and you will have breakfast simplified to a single animal!",
				"Uh oh!  Your use of growth hormones has produced a cow the size of the Chrysler Building.  Buy a Nuclear Bomb with 370,000 FarmBucks and pray it works.",
				"Oh No! Tea Baggers are picketing your farm. Distract them with facts and big words.",
				"Congratulations! You’ve achieved the “Master Militia” award. You have enough horse manure to make a large bomb.",
				"Congratulations! You win the “Organic Farmer” Award. Organic is Latin for 'food that rots twice as fast.'",
				"You just clear-cut an Old Growth forest that contained the most ancient trees in the world, earning yourself a Historical Achievement award!  (That’s a lot of history you just destroyed.  Quite an achievement!)",
				"Oops!  That headless chicken is running around spraying blood all over.  Next time, skip the chopping block and humanely choke the chicken.",
				"Congratulations! Your cows fart more methane gas than all the cars in Detroit. This earns you the “Silent But Deadly” achievement award.",
				"Congratulations! You’ve been playing this game for 7 days straight! You get the “That Knocking At The Door Is The Police Making Sure You Are Still Alive” Award.  We’d say share it with all your friends but we know you don’t have any.",
				"Uh Oh!  Looks like the bank is foreclosing on your property because of unpaid taxes!  Quickly board yourself in your home and prepare for a standoff.  The only way they take your farm is over your cold dead body.",
				"Oh No! You were working in the field when Kanye West came over and interrupted you. Now, he’s going to let you finish, but he has to finish telling you how Old McDonald was the greatest farmer of all time…of all time!",
				"Tiger Woods would like to borrow a couple of hoes from you. He'll be disappointed when he discovers that all you have are tools to dig dirt with."
			);
		}
		public function makeIllustratedJokeMessageArray():void{
			
			_illustratedJokeMessageArray = new Array(
				"Congratulations!  You have discovered a rare Hairy Nosed Wombat on your farm.  Plow over its habitat to grow more soybeans!",
				"Uh Uh!  You used that unconscious hobo as cattle feed.  Now your herd has “Bum Steer” disease.",
				"Congratulations! You have successfully bred a pig and a chicken. Work on getting toast in there and you will have breakfast simplified to a single animal!",
				"Child Labor laws prohibit you from using kindergarteners as farm hands. This means any child is fair game until they enter kindergarten.    ",
				"Looks like your septic tank is cracked and your crops are soaking in feces. We don’t know how to fix it; we just wanted to see the look on your face when you found out.  Plus, we like to say 'feces.'"
			);
		}
		public function makeIllustratedMcsArray():void{
			_illustratedJokeMcsArray= new Array("Wombat", "BumSteer", "Picken","BabyWorker", "CrappyCrops");
		}
		public function makeInGameContentArray():void{
			
			_inGameContentArray = new Array("Use farm bucks to pay off a congressman so your farm can get subsidized and you don’t have to grow squat!",
				"Your chickens have Bird Flu, your pigs have Swine Flu, and you don’t feel so hot yourself.  Buy medicine for 300 FarmBucks.  Oh, you don’t have 300 FarmBucks?  Been nice knowing you!",
				"YEEHAW!  Your Octomom is about to drop a litter!  You’ll need four friends to help you deliver all the Octo-whelps.  Make sure you buy Rubber Gloves and Bleach at the Market.",
				"You seem to have a lot of Crows. A Bombshell McGee Scarecrow would take care of that. Nothing’s scarier than a Bombshell McGee Scarecrow!",
				"Use Magic Beans to make regular beans feel inferior.",
				"Trade your cow for Magic Beans.  It may seem like it's not worth it, but you'll be surprised in the morning.",
				"Plant garlic to keep emo vampires from hanging out on your farm.  Emo vampires depress the animals and attract gullible teenage girls.",
				"Sarah Palin is shooting all your cows from her helicopter! Slip her 4000 FarmBucks under the table and make her go away.",
				"Vegetarian vampires have turned all your cows into bloodsuckers.  Slaughter them before they slaughter you.",
				"You don't have enough FarmBucks to buy fake dog food for your fake dog. Add Coins & Cash with a simple credit card transaction. Then you won't have enough money to buy your real dog real dog food.  SUCKER.", 
				"Growth hormones are very difficult to detect in most vegetables, so feel free to use them.",
				"Remember, all you need to make something organic is a sticker with the word “Organic” on it. As a bonus, the adhesive on the sticker is made from hormones.",
				"While plowing your field, you found the remains of an ancient Native American burial ground. Get some friends to help you dig up the bones and throw them in a dumpster.",
				"Looks like your septic tank is cracked and your crops are soaking in feces. We don’t know how to fix it; we just wanted to see the look on your face when you found out.  Plus, we like to say 'feces.'",
				"Would you like to buy some FarmWorld bucks? If you don’t, we can’t make money, and then we’ll starve. You don’t want us to starve do you?  You do?  I always knew you were a jerk!",
				"Bribe inspectors to allow you to use prohibited pesticides.  Sure, your customers will catch cancer, but that banned bug-spray works so good!",
				"Child Labor laws prohibit you from using kindergarteners as farm hands. This means any child is fair game until they enter kindergarten.    ",
				"Child Labor laws prohibit you from using kindergarteners as farm hands. To get around this, instead of calling them “farm hands” call them “interns”.",
				"Sorry! Your state just passed a sweeping anti-immigration bill that prohibits the use of illegal aliens as farm hands.  Fortunately, there is nothing that prohibits you from using illegal aliens as cattle feed.  We’re eating Mexican tonight!",
				"Sweet! The exotic chemicals you use on your farm have given you super powers. Now you can quit your life of agrarian drudgery and save the world from evil. Oh, wait. You don’t have super powers. It’s just regular cancer. Sorry.",
				"That sheep you find so attractive will not accept your friend request.  You should really stop playing this game and go out and meet some real girls.  Real human girls.",
				"Cow farts are the number one cause of methane gas in the world. This doesn’t help you with your farm.  We just thought it was funny."
			);
		}
		public function makeSpamContentArray():void{
			
			_spamContentArray = new Array("(insert name) has a gift for you! (insert name) has given you a smallpox blanket.  You should probably burn it!",
				"(insert name) needs help with hobos! Hiya (insert name)!  Look at all these dismembered hobos!  Will you help me bury them in quicklime?",
				"(insert name) has some toxic waste to share! (insert name) just unearthed some toxic waste!  It mutated his corn into carnivores, so now it’s all yours!",
				"(insert name)'s grandmother needs CPR! But…his WATERMELONS ARE DONE and he needs to harvest them now.  (insert name) will give you a watermelon if you do five compressions on his grandma!",
				"(insert name) has a pitch for you! (insert name) has sent you a pitch fork! Would you like to fork them back?",
				"(insert name) is such a thoughtful farmer and just fertilized your sheep. Hey, isn’t that a crime against nature?  Oh well, they did a wonderful (if somewhat creepy) deed, and hope that their neighbors don’t press charges. ",
				"(insert name) says, “How dry I am!” My crops need fertilizing! Please poop on my peanuts.",
				"(insert name) has a tip for you: (insert name) would like you to stop tipping their cows. They know it’s you and if you keep doing it there will be trouble!",
				"(insert name) wants to know, “Who let the dogs out?” (insert name) found a lost puppy on their farm. Do you want it? If you don’t take it they are going to have to stuff it in a sack and throw it in the pond. Why do you hate puppies so much? Puppy killer!",
				"(insert name) is corn-fused! I have no place to plant my corn. Could you please help me dig my corn hole?", 
				"(insert name) found a lonely hooker on their farm. (insert name) was working on their farm when they came across a lonely hooker. Do you have 50 FarmWorld bucks they could borrow so they could have a “party.”",
				"(insert name) fell in a well. (insert name) has fallen in a well, but doesn’t have a dog to send for help. Instead (insert name) is sending this notification via the Internet. If you can help (insert name), please leave a comment below.",
				"(insert name) sent a request using FarmWorld! Here is a Wooden Board for your farm in FarmWorld.  Use it along with Water from your well to extract confessions from Farmhands of Interest.",
				"(insert name) has sent you a Dung Beetle! (insert name) knows that you are full of poop, so here’s a little critter who will love you!",
				"Tiger Woods would like to borrow a hoe! We keep telling him that he’s got the wrong definition, but he won’t go away.  Maybe he’ll be satisfied if you put some lipstick on a pig…wait, that’s Jesse James.",
				"(insert name) is going GaGa! (insert name) has found Lady GaGa on their farm and they don’t known what to do. If they feed her she’ll never go away. If they ignore her she might attack them.  Please help!",
				"(insert name) has sent you some Spam! (insert name) is concerned that you aren’t receiving details of EVERY SINGLE ACTION he takes on his farm.  Set your privacy filters to “Infect My Computer” so you’ll be informed the next time (insert name) takes a dump.  On second thought, don’t bother to reset your privacy filters.  We just did it for you!!",
				"(insert name) just shared your Facebook info! (insert name) apparently didn’t have their privacy settings on Facebook right and now your farm is the property of Eastern European mobsters. Feel free to kick them off if you don’t like living.",
				"(insert name) is a horrible friend! (insert name) told you they couldn’t go out with you because they were going to the hospital to see their sick Grandmother. That was a lie. Instead they stayed home and played FarmWorld. You should write them and tell them what a horrible friend they are.",
				"(insert name) just had an involuntary autonomic function! In the spirit of reporting every trivial occurrence associated with (insert name)'s FarmWorld experience, we want you to know that (insert name) has just taken a breath.  Oh, and (insert name) just took another breath.  Oh, and there (insert name) goes again!  (insert name) is a breathing machine!",
				"(insert name) would like to invite you to FarmWorld! (insert name) would like you to join them in FarmWorld, and just by reading this blurb you are authorizing us to sign you up. Also by reading this you are authorizing us to charge a $50 monthly fee that will be conveniently added on to your phone bill."
			);
		}
		public function makeFakeFriendsArray():void{
			_fakeFriendsArray = new Array("Cletus", "Zeke", "Homer", "Maybell", "Billy Bob", "Billy Ray", "Bucephelus", "Buck", "Chester", "Cleon", "Clyde", "Cooter", "Elrod", "Floyd", "Garth", "Jed", "Jerry Lee", "Joe Bob", "Jim Bob", "Otis", "Rufus", "Wilbur", 
				"Betty Joe", "Betty Lou", "Betty Bob", "Bobbie Sue", "Buffy", "Earlene", "Darlene", "Jozelle", "Martha Mae", "Mary Lou", "Raylene", "Tammie Joe", "Trixie Belle", "Wilma");
		}
		//GETTERS
		public function get inGameContentArray():Array{
			return _inGameContentArray;
		}
		public function get inGameMessageArray():Array{
			return _inGameMessageArray;
		}
		public function get spamContentArray():Array{
			return _spamContentArray;
		}
		public function get fakeFriendsArray():Array{
			return _fakeFriendsArray;
		}
		public function get illustratedJokeMessageArray():Array{
			return _illustratedJokeMessageArray;
		}
		public function get illustratedJokeMcsArray():Array{
			return _illustratedJokeMcsArray;
		}
		
	}
}