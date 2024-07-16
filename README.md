# ollama-chats v1.9.9
Ollama chat client in Vue, everything you need to do your private text rpg in browser, with any amount of different characters, rag, per character context and more.

## What this is..
This "project" is a single web page desktop interface for chatting with your local Ollama server. It doesn't use any libraries apart from Vue and can be opened in browser as a regular web page.


It looks like this:

![image](https://github.com/drazdra/ollama-chats/blob/main/screenshots/s1.png)

You can run it just from disk in your browser, if you set an evironment variable or you can run it in a local web-server, like NGINX, Apache, etc.
The reason for that is that Ollama's API is done via a local network server, and locally opened web pages (from disk) by default are not allowed to access network resources (for safety reasons), even if it's your local Ollama server. Thus, to make it work you need either to configure Ollama to allow that or to use a local web-server software :).

## Why:
when i installed Ollama, i tried its built-in console chat interface but quickly realized it's nowhere enough to have fun, just enough to test the thing..

..then i looked up several existing interfaces and realized (again) that:
1. these things are either too big
2. or i'm too lazy to check all the code to ensure they do not send my local chats somewhere
3. i want to have it my way - that is for desktop and keyboard, not for mobile phones.
4. i want it to have a convenient keyboard driven interface and no unnecessary whistles.
5. i want it to use as few 3rd party libraries as possible for security reasons. 
6. fully local, so nothing is uploaded anywhere.
7. browser based.
 
And here we are. Whole thing is less than 30KB right now (actually 274KB already+bg image, lol), that's including the excerpts from Ollama documentation, html code and help page. The only imported thing is Vue which is a great web framework, probably used by millions of people, so it's pretty safe. 

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
2. You can ask AI for any amount of side-replies (alternative ones), by clicking on the arrow next to the message	or simply by clicking "right" arrow on the keyboard. Left arrow works as well). If you have some text typed in your prompt and you are editing it, arrows will not slide replies, obviously, for your convenience, as you may move cursor through the typed text. Same if you are editing something else, like settings.
3. You can do a similar thing with your own replies. Say, you are in a middle of conversation	and you see that AI doesn't like your reply, so you just click "right" arrow next to your	own message and it creates a new message. Then you just type in your new prompt, send it and that's it. You get a new "branch" of the conversation. And at that your previous branch is still there and you can return to it at any time.
4. Under the "left" and "right" arrows for every "turn" of your chat there are numbers. These show how many alternative replies you do have there.
5. You can travel "up" and "down" the conversation with your arrows easily. It's super convenient when you "chat a story".
6. You can stop AI reply if it takes too long or if it's obviously wrong. Just hit "Escape" button on your keyboard.
7. You can see the number of every alternative reply, making it easy to remember which one you liked and return to it if no new ones are good.
8. You can manually edit any of the messages - both your and AI ones. To do that, just click on the text of a message you wish to edit and that's it, simply edit it in place. But pay attention, there is no way back once you click away from editing. Until then, you can use ctrl+z of your browser to revert things. Once you've edited, there is no more old version anywhere, AI will see only the edited version, you too. So, if there is a minor mistake made by AI in an otherwise perfect answer, it's very easy to fix it and continue having fun. You even can edit the nicks for each message.
9. You can specify nicknames - yours and of AI. These nicknames are used in prompts for AI, so they are important.
10.	You can rate the messages by clicking -- or ++. This rating can actually be used to instruct the model within chat to try to copy their style. If you have more than ~7 messages it actually makes real big difference, which is very cool. And of course if you are into finetuning, you can save your chat with ratings. Later, on your own, you may extract the dataset from the saved file (with your ratings) and  use it in your finetuning project.
11.	When you open the page, it pulls the list of locally available models and adds these to the list.	The list is under the prompt text area. You can easily choose the model you wish to get reply from. Yes, you can do it anytime within the chat. So, if your current model provides bad replies at some point, why not to change it to some other model and to go on?
12.	If you do not have any installed models, it will suggest you to pull a model from ollama's library. Note: the page itself does not load anything, it just uses Ollama's functionality, and kindly asks Ollama to download a new model from its safe library. Ollama has that feature.
13. It can work in two modes, sending messages as a single prompt and as an array of user messages. Models treat these differently, so you can try what fits you the best.
14. Side messages can use your rating to instruct the model to produce something better. For that just use ctrl+right or right click on an arrow :).
15. It has white and dark themes. Though the white one is scary :).
16. You can create characters with totally different "memory" (context). For example, 2 of your characters can do something together and the 3rd character won't know anything about that, poor thing :). This allows a much more interesting roleplays.
17. You can have separate settings per AI character, which means you can use different temperature etc and even different models for different characters!
18. You can switch manually controlled character to be AI controlled and vice versa :). So you can make AI to play for the char you used to be, and you instead would continue to play for AI's char. Of course you can do it with any of the charactes in the story. To do that click an up/down arrow icon in the users list at the top-left.
19. You can automatically try ranges of various model parameters with configurable steps and see how model reacts to these. Find the best parameters to have fun with your model :). To do that click F9 and reada small instruction on using it ;). 
20. You can use RAG to store any amount of memories for characters, both per character and for all of them. You can enable/disable this as you wish, as well as define the amount of relevant memories for characters to "remember" before answering to you :). It also will show you which "memories" were used in the past reply of a character. To use it, just click shift+f4 for knowledge that all characters share or shift+f5 for personal memories of a given character. Then just enter "memories" as paragraphs of text. Size doesn't matter here, you can use any amount of data.
21. It's possible to upload images for multimodal models, like llava or moondream! They will tell you what's on the image.
22. Now it has a brilliant character generator! You can generate any personage with any parameters, from evil and creepy one to a saint! And it's going to be much more fun to chat than it is with a simple short or bad written system prompt that you can find in most cards online. Also, it generated memories for the character on any topics, if you use rag (included) you can have even more complicated personalities created!
23. And many more features :).
24.	Let's talk about lower menu:
    
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

#### 12.10. CH.mem:
Character's memory. Allows you to enter any amount of data for character to rememember, so you are not limited with the context window anymore and you can define a very detailed characters with a lot of information they can remember when appropriate.

#### 12.11. P.knlg:
Public knowledge. Allows you to enter any amount of data for all character to know, so you are not limited with the context window anymore and you can define a lot of world descriptions for characters to remember, when appropriate.

#### 12.12. Gen.Char.:
Character generator. Allows you to easily generate a complicated personality of a new personage in a few steps :).
 			 
### Enjoy!

## Changes (v.1.9.9 2024.07.16)
### A major release
This release took a lot of time and efforts were spread in time, so there might be bugs, even tho i spend a lot of time to test. Take it as beta.
* Major feature: i was playing with this whole month from the previous version: "trinity". The name has nothing to do with the functionality :). This thing splits each reply of a model into 2 separate parts: thoughs and actions. It uses 2 separate prompts for that, so reply comes in 2 parts. Thoughts are visible only to you and to the author character, other characters will not see the thoughts of others, it's private to them. That makes much more sense in multiplayer chats. Second, with this mode models do not just muse as second part forces them to say something or do. I personally find most interesting part in chats is the "thinking/feeling" of the models upon various topics and this gives me guarantee to see that part without constantly telling them "Now tell what you think and feel", now it's there automatically :). You can switch from 3ty mode to usual mode anytime, in that case chat log will have only "actions" part leaving thoughts hidden and not used. As these are stored separately, edits in these 2 modes do not affect each other. If you switch from original usual mode to 3ty, everything just goes to "action" part. I suggest to try it, as this can be way more fun than the regular mode at times :). As models are prone to repeating the same thoughts when nothing much changes, i added one more variable to config, which makes "thoughts" part to happen with a certain chance, by default it's 50/50. Approximately half of answers will have thoughts, other ones will be just actions. You can change it in the settings/chat logic/Chances to see thoughts of AI. You can even edit the prompts used to produce thoughs/actions if you wish to make it more fitting to your needs. And more to that, it supports certain templating features to refer to names and last reply text.
* Major feature: now there is saving and loading of the cards! Yes, now you can just save your favorite character, together with its memories, system prompt, instruction and knowledge into a file and later add it to any conversation by loading that cart (shift+f2/shift+f3). More to that, you can save any amount of characters from a chat to a single card! And of course, you can set the first message in the card that will emerge upon card loading. But more to that, you can actually add any amount of first messages with any of saved characters! So you can make a card with a start of a dialog you have in mind. More to that, you can load card even into existing chat, and in that case characters are just added to existing chat and your dialog is added as a separate branch if you alerady have a chat log or as a first thing in chat if you don't have any messages yet. Ideal :).
* Now there is deletion for messages! As the project uses tree for the chat structure, deletion is tricky. When you delete a message, you delete whole branch. That means you delete everything below growing from that message. Like, if you have 100 turns of replies growing from that specific message and they have alternative replies there, all of that will be deleted. However, of course, everything growing from side-messages on the same turn is kept intact. 
* Now there is moving for messages! If you like a certain branch but there is boring stuff in between - you can move all the branch up to a desired position. Actually, you can move it anywhere, apart from moving it into itself :). You can move it to alternative branches higher or lower in turns, doesn't matter. You even can make it to be a start of your conversation. When you move a branch, it's grafted into the current turn, keeping all the existing messages there intact. Later, if you don't want them, you can just delete everything else.
* You can delete current last turn message with "Del" button now. Additionally, if it's the last message and it's AI's one, it will automatically create a new AI message for this turn. So if you dislike message, instead of pressing "Right" you can just hit "Del" keeping your chat clean :).
* Now when you rate a message, you will see an additional button "to the right". That's the button for getting a side-reply with your rating considered. No more "right click" for that.
* Now, if you click on the "to the right with rating" button, while being in the middle of a generated messages, it will immediately start generating a new one, no more need to scroll through all side messages to the last one.
* For mighty tweakers i've added a raw method for sending messages! Yes, no you can directly play with the template in the UI without rebuilding model. Please beware, that you in that model you have to manually enter the template for your model. Default one is chatml, the one for llama3. More to the fun, i've made templating mechanism, so you can use various variables in the raw mode, like the name of a character, name of the previous character in the log, texts of the given/last/replied to messages, image template for inserting img anywhere in the template, etc. And even more to that, raw mode supports both "chat" and "single message mode", in single mode it will take care of sending whole chat in a single portion and you even can edit how each message is going to be formatted then. For your convenient to see what's going on, you can also enable logging of raw mode processing, to see the data and templates at all steps! :)
* A lot of refactoring was done to get rid of user-assistant order of messages. Now, there can be any order of messages, for example 2 replies from a model with no your messages in-between. It's even possible that one turn may have messages from both - users and assistance (if you switch some character from ai based to user based or vice-versa). But there are still empty messages created if you just click "enter" - for your convenience, so that you still can branch at that spot by writing an alternative reply at that turn.
* Now there is a special option to keep/discard empty messages (when you just click enter). Empty messages can be auto removed from the final log sent to message or kept.
* Now you can configure the text used to replace empty messages if you decide to keep them. By default they would say "Continue" but you can set it to anything.
* With the previous change, sometimes it might happen that AI will have to "reply" to its own message. That causes models to reply for other characters, ignoring its own system prompt. To prevent that i've added a new feature - Prevent replying of ai to self. When it's enabled in that situation there is one more message injected, that instructs model to continue talking for itself. It removes the problems arising in that situation :).
* When i send messages to the model, i add character names to the start of the line, as it helps a lot in making models reply adequately whenever there are many characters talking. Now this is in config too, so if you have a perfectly ordered chat of you and 1 character only, you may disable it in config through "Add names" feature. 
* In trinity and in raw mode there are template placeholders like ReplyToIdm etc, which contain data on the last reply model is supposed to reply to. But sometimes last message may belong to the model itself (i.e. when you just click enter and remove empty messages from log) in that case setting "Prevent replyTo template to refer to own msg" may be useful. It will ignore last messages belonging to the character that replies and will go up the log searching for last message belonging to somebody else. And then will use it as a content for templating in "replyTo" placeholders. If none are found, data will be just an empty string.
* In settings description of parameters now limited in height, so now it won't take huge space.
* Design of the settings page changed internally, now you may resize textareas if you wish to edit something conveniently there.
* A lot of internal refactoring of the template, to make message showing a separate thing.
* Upon character role change (ai<->user) all unfinished side-messages are now erased, as they don't make sense in a new role.
* Message status is now shown at the bottom, to see what's going on: waiting (for ollama to reply), generating - model generates a reply, error - some error happened, embedding - converting prompt to embeddings and searchign for relevant parts in memory.
* Bottom menu was expanding the layout which resulted in visually smaller possible font after "scaling up" of UI. i've renamed most of the buttons and added titles, so upon mouseovering they do show explanations now. And now it fits original 800px width :).
* Now there is a way to clear the chat (F8). It will erase all messages, keeping the characters intact.
* Upon start and old chats loading, during the pulling of the models list there is now a waiting screen, showing the amount of models loaded.
* Rating now is applied per character. That means that if you have a rated certain messages, only the character owning these messages will see these, and others won't. It makes more sense as normally we would prefer each character to have its own talking style.

## Changes (v.1.9.8b 2024.05.22)
### A small bugfix release
* Session could overwrite the link to a list of models with a fixed list and then it wouldn't update. Fixed.
* "Chilhood" -> "Childhood" Thanks to GuruMeditation for the report.
* "F9 Sets" renamed to "F9 Settings"


## Changes (v.1.9.8 2024.05.22)
### Major release!
* Now we have a character generator! Sounds as something small but took about two weeks of hard work. I was thinking for adding public cards support but after looking at a lot of them, the structure and content, level of support and so on, i've decided to avoid that for now. Instead we have a much more interesting random character generator now :). You can define starting points such as age, gender or anything else you believe is important and it will generate the rest. What it does is making a name, a system prompt for your character and also a lot of memories to fill the RAG data if you use it. You can define how many childhood good and bad memories you wish to add to character, as well as how many recent memories and any amount of *custom* random memories on topics you predefine. Even more, you can make it automatically generate memories about any of the generated parameters! For example, if you have a parameter "Hobby" and model will generate a hobby "Photography", you can automatically generate for your character any amount of "photography" related memories! And the best part is, it actually allows you to set any amount of your own parameters, so you are not restrained with anything! Wish it to generate "facial features" description? Why not? Wish it to generate "Length of fur" or "Amount of plasma cannons", why not either? :) And the cherry top on that is my own concept of the core parameters for every character: toxicity/charm, destrutive/constructive and "lieful/honest". You can define these before every generation tailoring the new character to be precisely what you want (or leave it random!). And of course you can also prefedine any of your custom parameter values! Once i made it work and tried, the chats turned x5 as interesting :). Characters are way more alive and diverse in behavior now :). 
* Memories now can be generated live during the chat, just define the topics for new memories and click generate!
* RAG now allows enabling/disabling shuffling ot the top found results. Shuffling may add randomness but takes longer to evaluate your side-prompts as these can't be cached. 
* Now script on exit saves to the session used urls and chosen models and reloads it on the next time you open the script. So you don't have to choose the model from the list every time or configure a non-standard url, or an url for embeddings :). Data is saved for global settings, if you have per character settings it's presumed you just "save" and "load" to keep everything the same.

## Changes (v.1.9.7 2024.05.09)
### Major release
* Huge new feature: Now we have RAG! You can now define any amount of data both per character and for all of characters. When you send new prompt, relevant information is searched for in these data storages and injected into the prompt. You can control how many memories are injected or disable it at all. I highly recommend running a second instance of Ollama on another port, configuration of my UI has a separate URL for that one. In this case your RAG won't slow down much new generations. If you use the same Ollama instance for RAG, the cache of an existing conversatoin is being erased in Ollama and the whole history is then recalculated, which takes huge time to complete. If you have 2 separate instances, that doesn't happen. I run at least 3 instances, 2 for 2 characters and 1 for embeddings, luckily, embedding models are tiny, less than 400mb usually, and models like llama3:8b q4 are very small, so 2 of them are easy to run on most computers.
* Big new feature: Now it's possible to upload images! Although, the use is kind of limited, the only 2 models that support vision right now are llava and moondream. Also, i don't really see how it can be used in rpg :). By default only the last turn images are seen by a model, because vision is slow and takes a lot of time. 
* Invisible but important feature: now it single-message mode, which is a default one, when you send an empty message it is not added to the conversation and all and the AI replies to the previous chat log. That allows you to have a much better AI to AI conversations, as now there won't be something like "You: continue" in between their lines, confusing them :). Yet, in the multi-message mode, empty messages are still replaced with "continue" because in that mode AIs are totally clueless when question/answer pattern is broken.
* New feature: Now there is a second list of models "embedding" models. Theoretically any models could do embeddings, but to avoid misuse i've created a separate list for these. To use new RAG feature you will need to download at least one embedding model. Do pull "nomic-embed-text" or "snowflake-arctic-embed:335m", whichever you feel like.
* Major design change: I've added a background image to the chat, to make it more appealing to people who like everything flashy :). Don't worry, you can always open settings, go to background image and remove it, if you prefer a classic black background. Also, you can make it either fixed background that doesn't move or repeated vertically.
* Minor feature: Now you can limit the height of the chat log if you don't like a long page. This way the chat log is scrolled separately within a small sub window.
* Minor feature: You can see which memories were used from your list when the reply was generated.
* Minor feature: I've added "storiesUI" configuration option. Now you can separately hide stories UI but it will still work under the hood. If you wish to completely disable stories, you have a separate "stories" option now. If you disable it, all messages will be seen by any character.
* Minor feature: right click on AI's nick under the prompt will auto submit the prompt now, this way it's much easier to make them talk to each other :).
* Minot design change: there is a lot of settings now, so i've finally grouped them into separate tabs.
* Update: i've slightly improved speed of the chat log rendering, it's not like it would be slow on any of the modern computers with a reasonable long chat log, but it just irritates me that things can work much more efficiently, so i've fixed several most outcrying non-optimal things.
* Update: i've removed separate proxy url, there were reasons for having it but i changed my mind. Now, if you use proxy, just use its url as a main one. No more "fall back" option.
* Minor bug fix, if pulling a model returns an error, it will be shown. Also, list of models automatically reloaded now after the pull.
* Minor bug fix, sometimes character selections could not be set automatically on character list changes.

## Changes (v.1.9.4 2024.04.27)
* Minor bug fix, sometimes edited message for some strange reason of internal browser/vue interaction mechanics could double the edited text. Fixed now.

## Changes (v.1.9.3 2024.04.26)
* Minor improvements: added rounding for parameter values in search for optimial param combinations, because JS creates stuff like "3.00000000000004", 0.799999999999999, etc. And added numbers to generated replies.

## Changes (v.1.9.2 2024.04.26)
* Big new feature: "Optimize", called with Shift+F9, it allows you to define ranges of model parameters to try and to come back seeing replies with all possible combinations of these. You can even specify these for several different models with custom ranges per model. In addition to trying out model params you can also try various configuration parameters of the script, like sending all chat by one message or an array of messages, etc. Results are normalized, so you can easily see if some parameters produce the same reply. 

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


## Changes (v.1.6 2024.03.09):
New version v1.6, it's a minor release.

* Main new feature: Quick settings. now you can configure which parameters you wish to have at hand next to models list and then you can change them without searching in the long list. By default the most important ones are there. You always can disable quick settings if you don't like them :).

* Minor improvement in cleaning garbage in replies.

* Bottom menu removes functional button numbers when you switch off these in the settings.

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
		


## License
Please note, it's not an open source project. It's a copyrighted proprietary software.
The short version of the rules to use this project:
 
1. You use it as is, with no warrantees, no guarantees, at your own risk, etc.
2. It's totally free for personal non-commercial use. In fact it's being made for people to have a free tool to chat to models in a private and convenient way. That's why the sources are open. So if you just wish to chat with models, enjoy!
3. It's not allowed to repack it or its parts and to use in your product or as your product. I might agree to this after a discussion but by default it's prohibited.
4. It's totally not allowed to be used by any business or corporation. It's not allowed to be used for any commercial purpose or in commercial products without my agreement.
5. It's not allowed to remove the original link to github, usage conditions or any other similar materials from the code.

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
					
