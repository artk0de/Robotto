# RBender [![Code Climate](https://codeclimate.com/github/art2rik/rbender/badges/gpa.svg)](https://codeclimate.com/github/art2rik/rbender)
**RBender** is a DSL-specified framework to create bots on different platforms (now Telegram only supported). Framework are developed to be maximally comfortable and intuitive for developers and proposes ultimate tools for bot creation.

![](https://github.com/art2rik/rbender/blob/master/img/rbender.png "Logo")
## Current gem version
[![Gem Version](https://badge.fury.io/rb/rbender.svg)](https://badge.fury.io/rb/rbender)

## Features
* Domain Specific Language based
* FSM (Final State Machine) model
* Logically encapsulated codee
* Simple, clear and powerfull
* Supports Telegram
* WEB-like sessions


## Future features
* Logger
* i18n support
* Inline API support
* Game API support
* Payment support

# Getting started
## Before install
To use this framework you need MongoDB installed. Please [visit MongoDB website](https://docs.mongodb.com/manual/installation/) for more information.

## Install
```bash
~$ gem install rbender
```

## Usage

To create new project type in terminal:
```bash
~$ rbender new DemoBot
```
Then new project with templates will be created. 

To run your bot:
```bash
~$ cd DemoBot
~/DemoBot$ rbender start
```
## FSM intro

The *Rbender* framework based on [Final State Machine](https://en.wikipedia.org/wiki/Finite-state_machine) model. Every state a represents one set of actions, which user could do while in state. The main idea of *RBender* are describing states and their's inner structure.

Every state can include:
* Keyboard
* One or more inline keyboards
* Text/Audio/Video/other hooks
* Before/After hooks
* Helper methods

The first state where user should be after '/start' command is **start** state.


For example, this code redirects user to **:state_1** after *:start* state code has been executed.
```ruby
state :start do
  after do
    switch(:state_1)
    # used to change states
  end
end

state :state_1 do
  # ...
  # some code
  # ...
end
```
User's state before execution:

![](https://github.com/art2rik/rbender/blob/master/img/fsm1.png "Before")

User's state after execution:

![](https://github.com/art2rik/rbender/blob/master/img/fsm2.png "After")

Beside this, there are can be **global** state where you can define helper methods and command hooks.

# Create your first bot
## States
States are main logical part of bot. 
States could be described as follow by using **state** keyword:
```ruby
state :start do
 # do some code
end

state :state_first do
  # do some code
end

state :state_second do
  # do some code
end

global do
  # do some code
end
```

**:start** state is required and is a main entry point.

**Global** state helps developers to define global inline keyboards, helpers and commands.

## Hooks
Hooks are callbacks which execututes when user sends to bot some different type messages like text/audio/video.

### Typed hooks
```ruby
state :state_main do
  text do
    # execetues when user sends text message
  end
  
  image do
    # executes when user sends picture
  end
  
  video do
    # executes when user sends video
  end
end
```
Available typed hooks:
* text
* audio
* video
* voice
* document
* location
* contact
* animation
* sticker
* chat

### Before/After
**Before** hook executes immediatly when user before state has changed.

**After** hook executes after state has changed

```ruby
state :state_one do
  text do
   switch(:state_second) if message == 'switch'
  end
  
  after do
    # executes before switch happens
  end
end

state :state_second do
  before do
    # executes when state will be :state_second 
  end
end
```

### Commands hook
Commands are messages begins with '/' symbol. Commands are availble from all states to user and should be described as follows
```ruby
global do
  command '/about' do
    send_message(text: "by Arthur Korochansky @art2rik")
  end
  
  command '/with_params' do |params|
    # f.e. if command was /with_params 1 one odin
    # params = [1, 'one', 'odin']
  end
end
```
## Keyboard
Every keyboard are assigned to single state and executes at the same time as state has changed.
```ruby
state :state_main do
  keyboard_response = "This is a keyboard"
  keyboard keyboard_response do
    button :btn_one, "One" do
      set_response("You've pressed ONE") # change keyboard response to user
      # action callback
    end
    
    button :btn_two, "Two" do
    set_response("You've pressed TWO")
      # action callback
    end
    
    button :btn_third, "Thrid" do
      set_response("You've pressed THIRD")
      # action callback
    end
    
    add_line(:btn_one, :btn_two) # put "one" and "two" buttons in first line
    add_line(:btn_third) # put "third" button in second line
    resize() # auto resize button
    one_time() # hide keyboard after use    
  end
end
```

## Inline keyboards

Inline Keyboards are similar to common keyboard, but it's must be attached to message. 

There are three button types in inline mode:
* Button – classic button with callback
* Link button – button with URL
* Inline switch button – switch to inline mode

```ruby
state :state_main do
  before do
    # Invoke inline keyboard
    send_message(text: "This is inline keyboard under this message",
                 reply_markup: inline_markup(:kb_sample))
  end
  
  keyboard_inline :kb_sample do
    button :btn_hello, "Hi!" do
      # Action callback
      edit_message(text: "Hello!")
    end
    
    button_link(:btn_url, 
                "RBender homepage",
                https://github.com/art2rik/RBender)
                
    add_line(:btn_hello)
    add_line(:btn_url)
  end
end
```

## Sessions
Sessions are special structure which stores different user's information. 

You could find out following data in the sessions:
```ruby
session[:state] # Current user's state
session[:lang] # Current user's language
session[:user][:chat_id] # User's chat id
session[:user][:user_name] # Telegram alias if available
session[:user][:first_name] 
session[:user][:last_name] # If available
```

Futhermore, you can contain your own values inside **session** variable to store parameters and other user's data, but keys above are reserved (also *:state_stack*, *:keyboard_switchers*, *:keyboard_switch_groups* are reserved too).

```ruby
  state :state_main do
    before do
      # Init new user's session parameter
      session[:notes] = [] 
    end
    
    text do
      # Add user's message to saved notes
      session[:notes].push(message.text)
    end  
  end
```
## Methods
### RBender methods
#### General methods
| Method name| Arguements | Description|
|------------|------------|------------|
|state| **state_id** * *Symbol/String* id of a state <br> **&block** state block | Defines state |
|global| **&block** global state code block  | Defines global state|
|modules| — | Defines additional bot modules <br> *(Returns additional parameters api_driver and mongodb_driver)*|

#### In-state methods
| Method name| Arguements | Description|
|------------|------------|------------|
|keyboard| **kb_response** *String* message displayed to user when keyboard has showed <br> **&block** keyboard code block| Defines keyboard |
|keyboard_inline| **keyboard_id** *Symbol/String* inline keyboard id <br> **&block** keyboard code block | Defines inline keyboard |
|after| **&block** hook block code | Hook invoked after state are changed |
|before| **&block** hook block code | Hook invoked before over hooks are executed  |
|text| **&block** hook block code | Hook invoked on text messages |
|audio| **&block** hook block code | Hook invoked on audio messages |
|video| **&block** hook block code | Hook invoked on video messages |
|voice| **&block** hook block code | Hook invoked on voice messages |
|document| **&block** hook block code | Hook invoked on document messages |
|location| **&block** hook block code | Hook invoked on location messages |
|contact| **&block** hook block code | Hook invoked on contact messages |
|animation| **&block** hook block code | Hook invoked on animation messages |
|sticker| **&block** hook block code | Hook invoked on sticker messages |
|chat| **&block** hook block code | Hook invoked on messages with chats |
|command| **command** command name <br> **&block** action callback| Defines global commands <br> *(global state only)*
|helpers| **&block** block with defined helper methods | Defines helpers 

#### Hooks/callbacks
| Method name| Arguements | Description|
|------------|------------|------------|
|switch| **state_id** *Symbol* id of needed state | Changes state of user |
|switch_prev| – | Returns to previous state |
|inline_markup| **keyboard_id** *Symbol* id of required keyboard | Returns inline markup object
|session| – | Return user's session
|message| - | Returns last (usually actual) message

#### Keyboard
#### Inline keyboard


### API methods

## Helpers
Inside *helpers* block you could define helper methods inside your states.

```ruby

# You could define helpers visible inside a state only
state :state_main do
  kb_response = "Press any button"
  keyboard kb_response do
    button :btn_local, "Local helper" do
      local_helper_method()
    end
    
    button :btn_global, "Global helper" do
      global_helper_method()
    end
    
    add_line(:btn_local)
    add_line(:btn_global)
  end
  
  helpers do 
    def local_helper_method
      send_message(text: "Local helper method has been invoked")
    end
  end
end

# Or you could define global helper
global do
  helpers do
    def global_helper_method 
      send_message(text: "Global helper method has been invoked")
    end
  end
end
```
## Example

# Documentation
For detailed documentation [please visit our wiki](https://github.com/art2rik/RBender/wiki).

# RBender based projects
*RBender* widely used for e-commerce bot creation. There are at least one professional team, which successful integrated *RBender* into their work and uses the framework to create commercial bots ([Anybots team](https://t.me/anybots), Telegram: [@spiritized](https://telegram.me/spiritized)). Also, *RBender* is used for [inner-communication bots inside Innopolis city (Russia)](https://hightech.fm/2017/04/01/innopolis_bots).
## Bot examples
* [@HighTechFmBot](https://telegram.me/HighTechFmBot): [HighTech.FM](https://hightech.fm) media journal bot
* [@FintechRankingbot](https://telegram.me/FintechRankingbot): [FintechRanking](https://fintechranking.com) news bot
* [@icecakemoscowbot](https://telegram.me/icecakemoscowbot): Food delievery bot

## Badge for developers
![](https://github.com/art2rik/rbender/blob/master/img/madewithrbender.png "Stamp")
