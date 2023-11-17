---
title: "Interview with contributor Remilia Scarlet"
author: beta-ziliani,Remilia
summary: "Music playback projects in Crystal, games engines, and a bit of Lisp"
category: community
---

Remilia Scarlet has been working with Crystal for her audio projects for a while now. We ask her about this experience, and here is what she has to say:

**A little about you. Who's Remilia?**

I'm an open-source developer who has worked with quite a few languages over the years. I mainly do command line tools, but recently I've been interested in audio programming as well.

**You are a Lisper and a Crystalist. That's a strange pairing of languages! What got you into Lisp, and what got you into Crystal?**

My interest in Common Lisp started in the mid 2000s just out of curiosity. I kept reading about how great the language could be, and felt that the programs I was working on at the time could benefit from it. So, I sat down, decided "I'm not stopping until I can write a non-trivial program in Lisp", and just went from there. Eventually it became one of my favorite languages. With Crystal, a few years ago I was looking for a language that could provide me with the performance I needed, but that could produce smaller binaries, and that could be easier for others should they want to contribute to my projects (I was the only one I knew who worked with Lisp at the time). After some Wikipedia searching, I discovered Crystal and found that it fit my needs perfectly.
These days, I'd say they're both tied for my favorite language.

**Sometimes you first do a prototype in Lisp, and then a rewrite in Crystal, is that right?**

Yes, that's correct. Part of this is just due to my history of using Common Lisp. I've gotten used to the immediacy of it, especially when combined with an Emacs mode called Slime. You don't just have a REPL, but a live coding environment with the full compiler and image-based development. I can just put my cursor in a function, do C-c, and it'll recompile a function to native code, even while a program is running. So it makes the adjust->compile->test pipeline much shorter. Common Lisp is close enough to Crystal with respect to its capabilities and paradigms that moving between them also isn't too big of a deal for me.

However, my Lisp code stays as a prototype in most cases because my Lisp code is never as memory efficient as Crystal. In most cases I see a roughly 50-75% decrease in memory usage going from my initial Lisp prototype to Crystal. Shipping a source repo that someone can download and compile also isn't as clean as with Shards, and even if it was, I don't think most users wanting to compile their own software know the idiosyncrasies of the various Lisp compilers out there. So really, Crystal ends up making a lot more sense to me past the prototype stage in most cases.

Also, a Hello World binary built with Common Lisp is somewhere around 42mb (and can't be run through strip), whereas a Hello World in Crystal is only like 300k.

**Tell us about three projects that you're most proud of.**

I think the three I'm most proud of right now are [Benben](https://chiselapp.com/user/MistressRemilia/repository/benben/index), a player for a music format called VGM; [midi123](https://chiselapp.com/user/MistressRemilia/repository/midi123/index), a command line MIDI player that can use SoundFonts for audio synthesis; and [RemiAudio](https://chiselapp.com/user/MistressRemilia/repository/remiaudio/index), a general purpose audio processing library that is shared between them.

**You add audio chipsets to Benben.What's the story there?**

Yes! So most audio files (WAV, MP3, etc.) just store recorded audio samples, either in straight PCM format or a compressed format. VGM files are different in that they log the raw commands sent to various sound chips to read and write register values. To play them back, you need to have some sort of emulator for those sound chips. Benben implements these emulators using its backend library, YunoSynth. There were quite a few sound chips developed in the 80s and 90s for use in arcade games, as well as home consoles and computers. These ranged from simple "play back this sample at this time" chips, to full fledged synthesizers-on-a-chip that used frequency modulation synthesis to generate sound on the fly. The VGM format supports many of these chips, and I've been slowly porting emulators for them from the MAME project to YunoSynth/Benben.

**Are you missing many? And what got you into this project?**

I'm still missing about a dozen or so chips, some of which share a common emulation core. I expect these to take a bit longer to port because of how much more complex they are. Putting them off until later has also been beneficial because it means I now have more experience with porting emulation cores under my belt. But for now, I estimate Benben can now play back about half of the VGM files out there already.

I got into the project mostly out of a love of old video game music, and partially because I was never totally happy with the official command line VGM player. I felt I could write a better player, but I also didn't want to write plain C or C++ code. Crystal felt like a perfect match, given its speed and capabilities. I could have just written Crystal bindings to the official VGM libraries, but that just didn't sound nearly as fun as writing a 100% native Crystal port.

**Given your current experience with Crystal for kinda low-level stuff, what are the ups and the downs of writing such Crystal programs?**

Oh I **love** Crystal for these sort of things. The type system in Crystal, especially type unions, gives it a very comfy feel, almost as if it was a dynamic language. I can write quick experimental code without worrying about types, and yet still get good performance out of it. Later on, I can take my initial code and tighten it up with type annotations. Plus, it gives me a lot of high-level tools within its standard library, but never prevents me from dropping down to manipulating pointers for those rare cases where it's needed. Essentially, I find it to be a perfect balance between high and low level programming languages.

The only downside I've encountered so far is some of the error messages are sometimes a bit obscure. But those have gotten much better since the 0.3x days, and I'm sure they'll improve with time.

**Completely unrelated, and on a personal note: why Remilia Scarlet?**

Oh, the name? I am a huge fan of a game series called Touhou Project. One of my favorite characters from it is a vampire lady named Remilia. I started going by that online years ago, and got so used to it that I've just adopted it as my actual name. I guess I kind of identified with her lol. My actual real name is Alexa. Going by Remilia also means someone calling out to me won't trigger their Amazon Alexa device.

**Back to your projects, do you know if there are people using them?**

I'm not aware of anyone using my more recent audio-related projects. I'm hoping that will change, given that the libraries behind them could be a good option for music playback in video games.

**You mean, for video games made in Crystal?**

Yes, exactly! I've made a few prototype engines in Crystal, as well as an unfinished port of Doom, and feel that it could be a great language for writing video games based on my experiences with those.

**I remember your Doom port! You did some custom-made levels there, right?**

Yeah! I've been doing levels for Doom since the mid 90s, and writing my own Doom port has been on my bucket list since I was a kid.

**What's the prospect for the future?**

Benben is likely going to be my main project for the near future. Getting it to support most, or all, of the chips that the VGM format supports is a key goal for the project. I'd also like to backport some of its frontend features into midi123 since the frontends are very similar internally. Aside from that, I'm looking at doing an actual retro-style game, possibly either an FPS or a vertical shooter.

**The video game story for Crystal is much unexplored. I guess that now that [Windows support is almost there](https://crystal-lang.org/2023/07/06/windows-support-1.9/), that line will boost. Or at least, my experience is that gamers use Windows…**

I hope so, yeah! I think it would be a great language for game development given how great the performance is, and how easy it is to pick up the language.

**Where can we find more about you?**

I have a [personal web page](https://remilia.sdf.org/) where you can find all my projects. And as a teaser, you can hear The Secret of Monkey Island played with midi123 in [this video](https://www.youtube.com/watch?v=UX2in-whUik).
