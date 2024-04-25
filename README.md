# ollama-chats v1.9.2.
Ollama chat client in Vue, everything you need to do your private text rpg in browser, with any amount of different characters.

## What this is..
This "project" is a single web page desktop interface for chatting with your local Ollama server. It doesn't use any libraries apart from Vue and can be opened in browser as a regular web page.


It looks like this:

![image](https://github.com/drazdra/ollama-chats/blob/main/screenshots/1.png)

![image](https://github.com/drazdra/ollama-chats/blob/main/screenshots/2.png)

![image](https://github.com/drazdra/ollama-chats/blob/main/screenshots/3.png)

![image](https://github.com/drazdra/ollama-chats/blob/main/screenshots/4.png)

![image](https://github.com/drazdra/ollama-chats/blob/main/screenshots/5.png)

![image](https://github.com/drazdra/ollama-chats/blob/main/screenshots/6.png)

You can run it just from disk in your browser, if you set an evironment variable or you can run it in a local web-server, like NGINX, Apache, etc.
The reason for that is that Ollama's API is done via a local network server, and 
locally opened web pages (from disk) by default are not allowed to access network resources (for safety reasons), even if it's your local Ollama server. Thus, to make it work you need either to configure Ollama to allow that or to use a local web-server software :).

## Why:
when i installed Ollama, i tried its built-in console chat interface but quickly realized it's nowhere enough to have fun, just enough to test the thing..

..then i looked up several existing interfaces and realized (again) that:
1. these things are either too big
2. or i'm too lazy to check all the code to ensure they do not send my local chats somewhere
3. i want to have it my way - that is for desktop and keyboard, not for mobile phones.
4. i want it to have a convenient keyboard driven interface and no unnecessary whistles.
5. i want it to use as little 3rd party libraries as possible for security reasons. 
 
## What:
Initially (version 0) i had spent several days to code this thing. My goals were:
1. fully local, so nothing is uploaded anywhere.
2. convenient chat interface for fun. (i.e. something unlike character.ai).
3. no unneeded dependancies that can inject fun code without me knowing that.
4. minimalistic.
5. browser based.
6. keyboard friendly.
 
And here we are. Whole thing is less than 30KB right now (actually 133KB already, lol), that's including the
excerpts from Ollama documentation, html code and help page. The only imported thing is Vue
which is a great web framework, probably used by millions of people, so it's pretty safe.

#### In other words, this UI is made with paranoia in mind, to prevent any chances of leaking our chats.

You can check the whole code in 30 minutes if you wish, to ensure you are totally safe with it. It's a single file, so no need to wonder by hundreds of separate sources for that. 

If you already have a web-server running this thing is a matter of seconds.
If you don't, you can install Nginx in some minutes.
Hopefully in future we might run it directly with Ollama, but not yet.

## Installation:
There is not much to install, it's a single index.html.
The file needs to connect to your local Ollama server and you have 2 choices for that:
* You can install a local web-server as a reverse proxy.
* If Ollama runs on your own computer, a bad way is to configure Ollama to allow any Origin header. As it still runs only on your local 127.0.0.1 address, others still won't be able to connect to it directly. However, sites you visit may use malicious code to connect to your local network as you run your browser on your local computer. So any site you open theoretically will be able to exploit your Ollaama with this.

#### 1. Here is a longer but safe way with a web-server:
If you already have a web-server, there is not much to say, just put "index.html" from this project into any of your web folders, rename it as you wish if needed and access in browser.
 
if you don't have a web-server, the easiest and the best one is NGINX. I do not have a goal of writing FAQ on NGINX here, there are tons online. So please consult with these. The short installation instruction, tho, is here: 
1. install nginx (on ubuntu it's as easy as: sudo apt install nginx).
2. create a configuration file "ollama-chats.conf" in its configuration folder, (/etc/nginx/conf.d for linux)
 The file example is already presented in this project, you can just copy it if you run ollama locally, nothing needs to be changed.
4. Take care to set all paths to what you have, including the "root" folder to where you want it to be and copy the index.html file from this project there. If you are using ubuntu, nothing needs to be changed in the sample config.
5. Make sure to set file permissions and file ownership of the index.html and of the root folder according to nginx rules, you can google it for your OS. On ubuntu:
    * copy the index.html from this project to /var/www/html/index.html (root folder in config)
    * in console change the file permissions: sudo chmod 640 /var/www/html/index.html
    * in console change the file permissions: sudo chown "$USER":www-data /var/www/html/index.html
6. Start nginx (on ubuntu: sudo service nginx restart)
7. Access http://127.0.0.1/index.html in your browser
8. If you see some error, like file not found, etc, it means you've misconfigured nginx or file ownership/permissions.
9. If you configured your web server correctly, that's it. It's probably just 3 minutes.

Also, please note, now the sample configuration file has an example on how to configure Nginx as reverse proxy for Ollama. That is needed if you run Ollama on another computer. In that case you will need to change the IP addresses in the sample config as it's explained there. Check the "nginx-ollama.conf" file. This is the best way to access Ollama remotely, because you can configure access in Nginx. Alternative method of changing "origin" environment headers for Ollama would open it up for anybody on internet, which is probably not what you want.

#### Alternative web-server written with GO, if you are a GO fan, check this out :). The mod by Farwish is here: https://github.com/farwish/ollama-chats/tree/main/go
it's a way to run the page in GO written web-server, if you like GO and know what you are doing (i.e. can read and trust the GO code), instead of nginx you can take a look at this project. Thanks to Farwish for this :).

#### 2. If you do not wish to install a webserver, here is an INSECURE way to install, NOT RECOMMENDED.
##### On Ubuntu
You will need to edit ollama.service. i use Nano editor, replace it with what you use: 
* open terminal
* cd /etc/systemd/system
* sudo nano ollama.service
* In the [Service] section add a line (it's okay if there is already one like that, just add one more): Environment="OLLAMA_ORIGINS=*"
* Save it: F2, y, enter.
* systemctl daemon-reload
* service ollama restart
* open the index.html from my project in your browser and enjoy.

  
##### On Windows:
* open settings
* in the search enter "environment", click on changing the environment variables
* click "create"
* Enter the name OLLAMA_ORIGINS
* Enter the value *
* Click OK.
* Open the index.html from my project in your browser and enjoy.


 
## Features:
Now, let me list the features this thing has:

1. You can "prompt" the AI and see the replies in a chat form, as we all love. "Enter" button sends the reply, shift+enter allows making a line-break.
2. You can ask AI for another reply to your last prompt, by clicking on the arrow next to the message	or simply by clicking "right" arrow on the keyboard. Left arrow works as well). If you have some text typed in your prompt and you are editing it, arrows will not slide replies, obviously, for your convenience, as you may move cursor through the typed text. Same if you are editing something else, like settings.
3. You can do a similar thing with your own replies. Say, you are in a middle of conversation	and you see that AI doesn't like your reply, so you just click "right" arrow next to your	own message and it creates a new message. Then you just type in your new prompt, send it and that's it. You get a new "branch" of the conversation.
4. Under the "left" and "right" arrows for every "turn" of your chat there are numbers. These show how many alternative replies you do have there.
5. You can travel "up" and "down" the conversation with your arrows easily. It's super convenient when you "chat a story".
6. You can stop AI reply if it takes too long or if it's obviously wrong. Just hit "Escape" button on your keyboard.
7. You can see the number of every alternative reply, making it easy to remember which one you liked and return to it if no new ones are good.
8. You can edit any of the old messages. To do that, just click on the text of a message you wish to edit and that's it, simply edit it in place. But pay attention, there is no way back once you click away from editing. Until then, you can use ctrl+z of your browser to revert things. Once you've edited, there is no more old version anywhere, AI will see only the edited version, you too. You can edit both your own and AI replies. So, if there is a minor mistake made by AI in an otherwise perfect answer, it's very easy to fix it and continue having fun. You even can edit the nicks for each message.
9. You can specify nicknames - yours and of AI. These nicknames are used in prompts for AI.
10.	You can rate the messages by clicking -- or ++. This rating can actually be used to instruct the model within chat to try to copy their style. If you have more than ~7 messages it actually makes real big difference, which is very cool. And of course if you are into finetuning, you can save your chat with ratings. Later, on your own, you may extract the dataset from the saved file (with your ratings) and  use it in your finetuning project.
11.	When you open the page, it pulls the list of locally available models and adds these to the list.	The list is under the prompt text area. You can easily choose the model you wish to get reply from. Yes, you can do it anytime within the chat. So, if your current model provides bad replies at some point, why not to change it to some other model and to go on?
12.	If you do not have any installed models, it will suggest you to pull a model from ollama's library. Note: the page itself does not load anything, it just uses Ollama's functionality, and kindly asks Ollama to download a new model from its safe library. Ollama has that feature.
13. It can work in two modes, sending messages as a single prompt and as an array of user messages. Models treat these differently, so you can try what fits you the best.
14. Side messages can use your rating to instruct the model to produce something better. For that just use ctrl+right or right click on an arrow :).
15. It has white and dark themes. Though white one is scary :).
16. You can create characters with totally different "memory" (context). For example, 2 of your characters can do something together and the 3rd character won't know anything about that, poor thing :). This allows a much more interesting roleplays.
17. You can have separate settings per AI character, which means you can use different temperature etc and even different models for different characters!
18. You can switch manually controlled character to be AI controlled and vice versa :). So you can make AI to play for the char you used to be, and you instead would continue to play for AI's char. Of course you can do it with any of the charactes in the story.
19. You can automatically try ranges of various model parameters with configurable steps and see how model reacts to these. Find the best parameters to have fun with your model :).
20. And many more features :).
21.	Let's talk about lower menu:
    
#### 12.1. Settings: 
Allows you to configure the script itself and Ollama. If the parameter value is left empty, Ollama uses values from its modelfile, or default ones if modelfile doesn't have these. Parameters are applied upon each request, and according to Ollama's docs, they should change the rules on the fly.

#### 12.2. Pull: 
You can pull new models easily, just enter model's name from ollama.com/library and that's it. For example: "stablelm2:1.6b-zephyr", or just "stablelm2". Once the download is over, you will return to the main interface. Don't forget to choose the newly pulled model in the models list, it's not done automatically.
 
#### 12.3. Reload models:
You might install models manually in the console, in that case you can update the list by clicking this button.
 
#### 12.4. System prompt:
Well, this is an obvious one. It's a system prompt for your model, where you can inform it that its life purpose is being a rose pony. Each AI character has its own separate system prompt.
 
#### 12.5. Instr:
That's a trick you may use to help AI figure out what you want. It does a very simple thing - it injects one more message on behalf of AI with the text you enter here. So, you should write it from the point of view of the AI's character. For example: "(IMPORTANT!! in my next message, i should remember that i'm in a forest right now!)". That might save some nerve cells during the chat. That message is not added to the chat log and does not disappear on the next turn but injected every time. It's convenient to use it to summarize things for AI as a reminder, so it doesn't loose track.. that much. Of course you can update it during the chat, to reflect what's going on in your RPG. This is as well different for each character.
 
#### 12.6. Prune: 
Sometimes chats grow big.. and there are hundreds of garbage replies you don't care of. If you wish to keep only the current version of your chat, that is, ONLY the replies you can see on your screen when scrolling, then you can click "prune" and everything else will be deleted. Your chat will seem as if all replies were like this from the very first attempt. It's better to save, before doing this.
 
#### 12.7. Save: 
Yes, you can save the chat, if you wish. the page saves everything and sends it to you as a file to download. It's not stored anywhere else. If you know what you are doing, you can always extract the replies and do local finetuning based on your good chats. The page does not provide interface for finetuning, that's something out of the scope of this thing.
 
#### 12.8. Load:
Yes, again, you can load your old chat with all of the settings from a saved file and continue any time. Of course, if you have saved it earlier :).

#### 12.9. Optimize:
Allows you to automatically try any possible combination of configuration and ollama settings for any models and see the results.
 			 
### Enjoy!

## Changes (v.1.1 2024.03.30):
New version v1.1. (let's say previous one was v0). A lot of minor things was changed and a huge major change is introduced.
New features:
### Most important:
Now it allows you to have so called "rooms", which means you can define as many characters as you wish to to chat with these, by choosing who speaks next. You can have conversations with any amount of people now!
	
#### Please note (valid for this version only)
when you've >2 characters defined (including you), it switches to a different mode and the consistency of replies changes. i, personally, find that this multi-user mode provides much better results than regular chat mode, so i recomment to add a 3rd user even if you don't use it in the conversation. But you can try and decide what you like more :).

#### New features:
* You can add and remove any user controlled characters you speak for. For example, one is your	main hero, another one is "World" or "Narrator" to drop in changes in the world when something happens, like "Narrator: Suddenly a comet fell upon the head of a ..". And of course you can add any amount of just personages you speak for.

* You can add and remove any amount of AI controlled characters. Every character has its own system prompt you define and its own instruction for the next turn that you define as well. You can have conversations between characters and with multiple characters over any situations you imagine in your rpg.

* If you add more than 2 characters, chat changes the way it works internally, helping AI to differentiate who said what. You don't need to start every time with "Name:" and to force AI to do the same, it will work out of the box. I love it :).

* Added configuration of the script features, a few parameters there:
	-  hideEmptyOwn 0/1 which hides your empty messages, when you just click "enter" and wish to see how characters talk to each other or wish them to continue. So your empty messages won't litter the chat log. If you set this to 0, you will see these and it makes it possible to branch chat at any point if you wish.
	- showEmptyOwnSide 0/1 that will force-show the empty own messages IF these are not the only ones at a turn. Single empty replies are still hidden. Showing these is useful if you have multiple own different replies at some turn and you wish to see these to compare the results of different attempts. If an empty one would be hidden, you wouldn't be able to scroll left/right at the turn like that. So, enabling it allows it.

* Added "keep-alive" parameter for Ollama, controlling the time in seconds to offload the model from memory. they load so slowly that default 5 minutes is too little. you can set it to -1 to make it keep the model "forever" in memory.

* When editing the reply in the chat log, "enter" now leaves the field, which is convenient. Shift+enter adds a line-break.

* Chat log messages now show the line-breaks as they should.

* Clicking "enter" upon radio buttons choosing who replies next sends the message. So there is no need to click back on the prompt with the mouse. You can just use "tab" button to move from prompt to the AI character selector, click space on the one you wish to answer and then hit enter. easy. Obviously "Shift-tab" moves you back and this way you can select your own character to reply for.

* Clicking on "system prompt" or "instr" now scrolls to the opened text area for convenience.

* An upgrade script for old version chats was written, so if you had a funny chat in the previous version, it should be fine to load it and get all the new features to continue it. It was irritating to write it :).

* Enter button in the chat will not add a line-break anymore at the time of sending.

* All sent messages are trimmed now, so useless line-breaks and spaces on the end are removed.

* If you send an empty message, internally it's replaced with "Continue" prompt for AI, it's done to for to things: 
	- avoid AI treating it like "oh, you are silent" which is irritating. 
	- sometimes models reply with the same message to an empty one
	- sometimes models just reply with an empty message to your empty message.

* Multiple "design" improvements - colors, transitions, etc.
		

## Changes (v.1.5 2024.03.08):
New version v1.5. (versions 1.2-1.4 were not published), several major changes and a lot of smaller ones.

###New features:

#### Most to least important:
* Biggest change: rating for messages now is used to instruct the model on the fly! If you have it enabled in settings, script will mark the messages according to your rating and will instruct model to use these in response generation. I did test and after 5-10 examples it actually does change replies into desired direction a lot. It varies from model to model, some are more stubborn, but nevertheless it's a very big change and makes chatting much more fun. If you do not wish that, you can disable it in settings.

* Second unique feature i longed for: i call it "redo". When you wish to generate a side-reply (alternative one), you can press CTRL and click on the "right" arrows, or just click "ctrl+right" (meta+right for mac) or right-click on arrows and the prompt then is modified automatically. Let's say you already have 5 bad side-replies in the last turn and 4 good side-replies that are still not ideal. So, you have 9 side-replies in the last turn. You've rated them all. If you click "right" this rating is not used. However if you click "ctrl+right", these message will be concatenated and model will be asked to produce something unlike bad ones but alike to good ones. Of course it eats context window, so only a part of messages is used as examples. The amount of good and bad messages used as examples is configured in the setting, so you can control it depending on your context memory limits. You can separately disable adding negative or positive ones by setting respective values to zero in settings. Upon every attempt examples are chosen randomly from the available rated side-replies. The effect is actually different and you need to see which one you prefer.

* Third huge improvement: new way to use the chat with keyboard! Now you can use "up" and "down" buttons to go up/down the selected chat branch without need to use the mouse! If you wish to go up and try an alternative story, just click up and then "right" where you wish! If you stop on AI's message, you will get new side-reply of AI. If you stop on your message, you will be presented with a placeholder for your own new side-reply, just type it in and hit enter! If you already had a reply to that message earlier it doesn't matter, it will automatically be added as an alternative so you will still have your old and new replies! Since now you can go up and then "right" and "left" there can be long chains of previously created existing replies going down from where you are. To prevent screen from jerking, these messages are automatically hidden by default, but you can see them just by pressing down or clicking the respective link. If you click "shift+down" all of the old messages in the branch are shown at ones so you can see it to the end. And of course the amount of messages below is shown :).

* Fourth big improvement: now you can choose if you wish to send all history as a single message/story or as an array of messages. Models reply very differently to these.

* For people running Ollama on another computer (or in a virtual machine) Nginx sample configuration was updated to show how to configure reverse proxy to access ollama. By default Ollama doesn't allow connections from other ips and changing it is not that inuitive as it requires changing the starting script. Nginx can easily solve this. In sample configuration it will serve ollama on a second url called "/ollama_proxy" and when you connect to it, your IP address is replaced with that of Nginx that is on the same computer where ollama is, so it's local to Ollama and everything works. To prevent other people from accessing it, you can just list your ip in nginx configuration as the only allowed one. The script upon connect first tries to connect locally, if it won't find Ollama, it will ask you for address. You can just enter your Ollama IP then and script will first try to connect to it directly, if it can't it will automatically try to use the /ollama_proxy url on the same address you specified. So if you configured things from the sample, you won't see the CORS issue blocking your connection. Settings also allow you to change that proxy path if you prefer a non-standard location.

* "Day theme" which in fact is just inversion of the colors. If you hate dark backgrounds, you may try this. Although, it looks scary. But.. all bright sides look scary, so it's normal.

* Upon loading of the list of available models now additional information is requested for each model. Most importantly, it pulls the num_ctx parameter from the modelfile (context memory specified for the model) and sets it as "default" value in settings. It means that in settings you will see how much of the context memory window the model is supposed to be used with and can configure it properly. Very convenient. Of course it works only if the modelfile has that value. If it does, the default text for num_ctx will mention the model specifically.

* If you send chat not as a single message, and you have more than one AI character, you can now choose if you wish messages of other AIs to be marked as "user" or as "AI". So, if next turn to answer if char A and there are chars B and C talking above, these will be marked all as "user" messages for AI. This can change the reply but in general it's unpredictable how model is going to react to this. However, you have this control now :).

#### Features required by the changes above and just minor improvements:

* Settings now allow changing messages font size and separately the font size in text areas.

* New settings to disable the usage of rating system (unrelated to side-rating).

* You can edit the nicks of the old messages now.

* When you use rated side-replies, it's a lot of additional tasks for the model. Your own instruction may intervene with the examples you liked or disliked. To prevent this, you can disable your instruction with setting "Still use instr for side-replies when side-rating is on". For regular side-replies and new replies instruction will still be used.

* A feature to clean the AI replies from junk. Rating and multi-user chat pollute messages with names and rating marks. AI imitates these adding them randomly to the messages, so we can see things like "Alex: Alex: Alex: .." in replies. To prevent this, script will auto-remove these. If you dislike that, uncheck the "Auto-clean reply from junk".

* Variables in settings were renamed to human redable form. Also, a new settings format was introduced, where you can read the descriptions along the variables. You can switch between the settings format with the respective setting :).

* Your instrucitons to the model (what you wrote in the "instr" section, as well as rating related instructions are told to the module from the name of an additional character. That character by default is named "Narrator" but now you can change its name in the settings. Maybe to "Your brain" or "Voices in the head" or whatever.

* When AI prints and junk is removed, the message text "jumps" and it irritates. To prevent that, a buffer was added that accumulates some symbols before showing them to you. You can configure the amount of these in settings, or just disable.

* When editing replies, "Enter" now makes you leave the field as if you've finished editing, so you can move across the page with page down/page up again.

* Showing of tokens used was added, but unfortunately that functionality is broken in Ollama, so it's disabled by default.

* Nicks can be now edited per each message, just click on any nick and edit it.

* Settings/stop words had a bug, it required an array which i've not noticed, fixed.

* Multiple design improvements.

* The code was cleaned a lot because original code was written when i was not feeling well in a zombie mode. Huge amount of internal changes, +100% of code, so there are probably some bugs in there.

* Several minor outdated bugs were updated to a new improved ones.

## Changes (v.1.6 2024.03.09):
New version v1.6, it's a minor release.

* Main new feature: Quick settings. now you can configure which parameters you wish to have at hand next to models list and then you can change them without searching in the long list. By default the most important ones are there. You always can disable quick settings if you don't like them :).

* Minor improvement in cleaning garbage in replies.

* Bottom menu removes functional button numbers when you switch off these in the settings.

## Changes (v.1.9 2024.04.19)
New version v1.9 a huge major release. The changes are vast, so if you catch a bug (or a dozen), let me know :).

* Major *unique* feature: each character can have its own context memory. And each message has its own "access" list where you can set who can actually "know" what happens in that turn.

* New major feature: you can make different settings per character! Now each char can have its own settings, including the model.

* New major feature: now you can switch manually controlled character to become AI controlled and vice versa :). So you can take control of any characted in the roleplay, letting AI play for what used to be your one.

* New feature: now chars can be organized into "presets" which are groups for fast access with configured access settings. So, you can have 2 groups of chars and easily switch between these when you want to continue the dialog for another group.

* Models select list now a part of the settings and can be added/removed to the quick access list of settings

* A setting to auto-remove emojis, in case if you don't want these.

* fixed several bugs found in v1.6.

* NOTE: i've added vue.prod.js file to the project, if CDN dies (again), you can use it instead.

## Changes (v.1.9.2 2024.04.26)
* Big new feature: "Optimize", called with Shift+F9, it allows you to define ranges of model parameters to try and to come back seeing replies with all possible combinations of these. You can even specify these for several different models with custom ranges per model. In addition to trying out model params you can also try various configuration parameters of the script, like sending all chat by one message or an array of messages, etc. Results are normalized, so you can easily see if some parameters produce the same reply. 


## Bonus
I did some experiments to find the meaningful parameter ranges for llama3:8b and wizardlm2:7b
Llama3: temperature<=9, top_k<=17, top_p<=1.
Wizardlm2: temperature<=28, top_k<=24, top_p<=1.

Higher values do not change almost anything. A very rare chance to get a different reply.


### For people who wish to parse the saved file:
P.S. If you wish to parse the saved file for replies, here is structure:

.turns - an array that has all the messages data. each turn is next "line" of chat.

.turns[id].role - the turn belongs to a: "user" || "assistant"

.turns[id].branches - an array of branches, each branch is tied to a single message in a previous turn

.turns[id].branch - id of the active branch holding messages for the active message in previous turn. it can be==-1, which means branch is inactive, user went by another branch
        
.turns[id].branches[id].msgs - an array, holding all the replies for a given message in a previous turn.

.turns[id].branches[id].msg - id of the finally selected message in this branch

.turns[id].tree - index to match previous messages to current branches, it's used to link previous turn's branch/msg to a current turn's branch. format is: 
  
    [previous turn's branch id][msg id within previous turn's branch]=current turn's branch

.turns[id].branches[id].msgs[id].nick - name

.turns[id].branches[id].msgs[id].content - message body

.turns[id].branches[id].msgs[id].rating - 0 is bad, 1 is good, empty is no rating.
					
